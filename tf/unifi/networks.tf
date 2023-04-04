locals {
  defaults = {
    ipv6_pd_interface = "wan"
    ipv6_pd_start = "::2"
    ipv6_pd_stop = "::7d1"
    ipv6_ra_priority = "high"
    ipv6_ra_valid_lifetime = 0
    ipv6_ra_preferred_lifetime = 0
    dhcp_v6_lease = 0
    dhcp_v6_dns_auto = false
  }
}

resource "unifi_network" "default" {
  name = "Default"
  purpose = "corporate"
  subnet = "10.0.0.1/24"
  vlan_id = "0"
  dhcp_start = "10.0.0.6"
  dhcp_stop  = "10.0.0.254"
  dhcp_enabled = true
  domain_name = "local"

  # set because the default network can't/shouldn't be deleted.
  # import this with: tf import unifi_network.default $NETWORK_ID
  lifecycle {
    prevent_destroy = true
  }

  # defaults set by unifi
  ipv6_pd_start = local.defaults.ipv6_pd_start
  ipv6_pd_stop = local.defaults.ipv6_pd_stop
  ipv6_ra_valid_lifetime = local.defaults.ipv6_ra_valid_lifetime
  ipv6_ra_preferred_lifetime = local.defaults.ipv6_ra_preferred_lifetime
  dhcp_v6_dns_auto = local.defaults.dhcp_v6_dns_auto
  dhcp_v6_lease = local.defaults.dhcp_v6_lease
}

resource "unifi_network" "lan" {
  name = "Home"
  purpose = "corporate"
  subnet = "10.0.1.1/24"
  vlan_id = "39"
  dhcp_start = "10.0.1.6"
  dhcp_stop  = "10.0.1.254"
  dhcp_enabled = true
  igmp_snooping = false
  multicast_dns = true

  # defaults set by unifi
  ipv6_pd_interface = local.defaults.ipv6_pd_interface
  ipv6_pd_start = local.defaults.ipv6_pd_start
  ipv6_pd_stop = local.defaults.ipv6_pd_stop
  ipv6_ra_priority = local.defaults.ipv6_ra_priority
  ipv6_ra_valid_lifetime = local.defaults.ipv6_ra_valid_lifetime
}

resource "unifi_network" "iot" {
  name = "IOT"
  purpose = "corporate"
  subnet = "10.10.10.1/24"
  vlan_id = "11"
  dhcp_start = "10.10.10.6"
  dhcp_stop  = "10.10.10.254"
  dhcp_enabled = true
  igmp_snooping = false
  multicast_dns = true

  # defaults set by unifi
  ipv6_pd_interface = local.defaults.ipv6_pd_interface
  ipv6_pd_start = local.defaults.ipv6_pd_start
  ipv6_pd_stop = local.defaults.ipv6_pd_stop
  ipv6_ra_priority = local.defaults.ipv6_ra_priority
}

resource "unifi_network" "gaming" {
  name = "Gaming"
  purpose = "corporate"
  subnet = "10.13.37.1/24"
  vlan_id = "69"
  dhcp_start = "10.13.37.6"
  dhcp_stop  = "10.13.37.254"
  dhcp_enabled = true
  igmp_snooping = false
  multicast_dns = false

  # defaults set by unifi
  ipv6_pd_interface = local.defaults.ipv6_pd_interface
  ipv6_pd_start = local.defaults.ipv6_pd_start
  ipv6_pd_stop = local.defaults.ipv6_pd_stop
  ipv6_ra_priority = local.defaults.ipv6_ra_priority
}

resource "unifi_network" "guest" {
  name = "Guest"
  purpose = "corporate"
  subnet = "10.0.10.0/24"
  vlan_id = "10"
  dhcp_start = "10.0.10.6"
  dhcp_stop  = "10.0.10.254"
  dhcp_enabled = true

  # defaults set by unifi
  ipv6_pd_interface = local.defaults.ipv6_pd_interface
  ipv6_pd_start = local.defaults.ipv6_pd_start
  ipv6_pd_stop = local.defaults.ipv6_pd_stop
  ipv6_ra_priority = local.defaults.ipv6_ra_priority
  ipv6_ra_valid_lifetime = local.defaults.ipv6_ra_valid_lifetime
}

resource "unifi_network" "kubernetes" {
  name = "Kubernetes"
  purpose = "corporate"
  subnet = "10.8.0.0/20"
  vlan_id = "8"
  dhcp_start = "10.8.8.1"
  dhcp_stop  = "10.8.8.254"
  dhcp_enabled = true
  dhcp_dns = ["1.1.1.1", "1.0.0.1"]

  # defaults set by unifi
  ipv6_pd_interface = local.defaults.ipv6_pd_interface
  ipv6_pd_start = local.defaults.ipv6_pd_start
  ipv6_pd_stop = local.defaults.ipv6_pd_stop
  ipv6_ra_priority = local.defaults.ipv6_ra_priority
  ipv6_ra_valid_lifetime = local.defaults.ipv6_ra_valid_lifetime
}

resource "unifi_network" "work" {
  name = "Work LAN"
  purpose = "corporate"
  subnet = "10.0.2.0/24"
  vlan_id = "2"
  dhcp_start = "10.0.2.6"
  dhcp_stop  = "10.0.2.254"
  dhcp_enabled = true

  # defaults set by unifi
  ipv6_pd_interface = local.defaults.ipv6_pd_interface
  ipv6_pd_start = local.defaults.ipv6_pd_start
  ipv6_pd_stop = local.defaults.ipv6_pd_stop
  ipv6_ra_priority = local.defaults.ipv6_ra_priority
}

locals {
  all_networks = [
    unifi_network.default,
    unifi_network.lan,
    unifi_network.iot,
    unifi_network.gaming,
    unifi_network.guest,
    unifi_network.kubernetes,
    unifi_network.work,
  ]
}