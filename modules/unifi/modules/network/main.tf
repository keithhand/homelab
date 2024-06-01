resource "unifi_network" "network" {
  name    = var.name
  vlan_id = var.vlan_id
  purpose = var.purpose

  igmp_snooping = var.igmp_snooping
  multicast_dns = var.multicast_dns

  dhcp_enabled = true
  subnet       = "${var.subnet}/24"
  # dhcp_start = replace(var.subnet, "/\\d*$/", min_value)
  # dhcp_stop  = replace(var.subnet, "/\\d*$/", max_value)
  dhcp_start = replace(var.subnet, "/\\d*$/", 6)
  dhcp_stop  = replace(var.subnet, "/\\d*$/", 254)

  # Defaults from import
  ipv6_ra_enable         = true
  ipv6_ra_priority       = "high"
  ipv6_ra_valid_lifetime = 86400
  ipv6_pd_interface      = "wan"
  ipv6_pd_start          = "::2"
  ipv6_pd_stop           = "::7d1"
  dhcp_v6_start          = "::2"
  dhcp_v6_stop           = "::7d1"
}
