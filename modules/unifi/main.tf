module "networks" {
  for_each = var.network.networks
  source   = "./modules/network"
  name     = each.key
  purpose  = each.value.purpose
  vlan_id  = each.value.vlan_id
  subnet   = replace(var.network.base_subnet, "X", each.value.vlan_id)

  igmp_snooping = each.value.igmp_snooping
  multicast_dns = each.value.multicast_dns
}
