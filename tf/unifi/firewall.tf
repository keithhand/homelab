# LAN IN
resource "unifi_firewall_rule" "allow_est_rel" {
  name = "allow all established and related"
  action = "accept"
  ruleset = "LAN_IN"

  rule_index = 2000

  state_established = true
  state_related = true
  protocol = "all"
}

resource "unifi_firewall_group" "lan" {
  name = "LAN"
  type = "address-group"
  members = [unifi_network.lan.subnet]
}

resource "unifi_firewall_rule" "allow_lan_vlan" {
  name = "allow LAN to anywhere"
  action = "accept"
  ruleset = "LAN_IN"

  rule_index = 2001

  protocol = "all"
  src_firewall_group_ids = [unifi_firewall_group.lan.id]
}

resource "unifi_firewall_group" "local_private_network" {
  name = "Local Private Network"
  type = "address-group"
  members = [ for network in local.all_networks : network.subnet ]
}

resource "unifi_firewall_rule" "block_inter_vlan" {
  name = "block inter-VLAN traffic"
  action = "drop"
  ruleset = "LAN_IN"

  rule_index = 2999

  protocol = "all"
  src_firewall_group_ids = [unifi_firewall_group.local_private_network.id]
  dst_firewall_group_ids = [unifi_firewall_group.local_private_network.id]
}





# TODO: make into module
resource "unifi_firewall_group" "application_barrier" {
  name = "Barrier (Application)"
  type = "port-group"
  members = [24800]
}

resource "unifi_firewall_rule" "allow_barrier_inter_vlan" {
  name = "allow Barrier (application) inter-VLAN traffic"
  action = "accept"
  ruleset = "LAN_IN"

  rule_index = 2002

  protocol = "tcp"
  src_firewall_group_ids = [unifi_firewall_group.local_private_network.id]
  dst_firewall_group_ids = [unifi_firewall_group.lan.id, unifi_firewall_group.application_barrier.id] 
}





# LAN LOCAL
locals {
  all_gateways = [
    for network in local.all_networks : cidrhost(network.subnet, 1)
  ]
  # TODO: reverse this to "secure_vlans"
  insecure_vlans = {
    iot: unifi_network.iot,
    gaming: unifi_network.gaming,
    guest: unifi_network.guest,
    work: unifi_network.work,
    # TODO: add specific firewall rules so DNS still
    # kubernetes: unifi_network.kubernetes,
  }
}

resource "unifi_firewall_group" "all_gateways" {
  name = "All Gateways"
  type = "address-group"
  members = local.all_gateways
}

resource "unifi_firewall_group" "web_ssh" {
  name = "Web / SSH"
  type = "port-group"
  members = [
    "80",
    "443",
    "22",
  ]
}

resource "unifi_firewall_group" "non_insecure_vlan_gateways" {
  for_each = local.insecure_vlans
  name = "non-${each.value.name} gateways"
  type = "address-group"
  members = setsubtract([
    for gateway in local.all_gateways : gateway != cidrhost(each.value.subnet, 1) ? gateway : ""
  ], [""])
}

resource "unifi_firewall_rule" "block_inter_vlan_gateways" {
  for_each = local.insecure_vlans
  name = "block ${each.value.name} from other VLAN gateways"
  action = "drop"
  ruleset = "LAN_LOCAL"

  rule_index = "2${format("%02s", each.value.vlan_id)}0"

  protocol = "all"
  src_network_id = each.value.id
  dst_firewall_group_ids = [unifi_firewall_group.non_insecure_vlan_gateways[each.key].id]
}

resource "unifi_firewall_rule" "block_insecure_vlan_gateway_portals" {
  for_each = local.insecure_vlans
  name = "block ${each.value.name} from all gateway portals"
  action = "drop"
  ruleset = "LAN_LOCAL"

  rule_index = "2${format("%02s", each.value.vlan_id)}1"

  protocol = "all"
  src_network_id = each.value.id
  dst_firewall_group_ids = [unifi_firewall_group.all_gateways.id, unifi_firewall_group.web_ssh.id]
}
