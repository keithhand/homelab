# unifi defaults
data "unifi_ap_group" "default" {}
data "unifi_user_group" "default" {}
data "unifi_radius_profile" "default" {}

resource "unifi_wlan" "lan" {
  name = "shhh"
  hide_ssid = true
  wlan_band = "5g"
  security = "wpapsk"
  passphrase = var.wifi_credentials.lan

  proxy_arp = true
  bss_transition = true
  multicast_enhance = true
  fast_roaming_enabled = true
  minimum_data_rate_2g_kbps = 0
  minimum_data_rate_5g_kbps = 0

  network_id = unifi_network.lan.id
  ap_group_ids = [data.unifi_ap_group.default.id]
  user_group_id = data.unifi_user_group.default.id
  radius_profile_id = data.unifi_radius_profile.default.id
}

resource "unifi_wlan" "iot" {
  name = "iot"
  hide_ssid = true
  wlan_band = "2g"
  security = "wpapsk"
  passphrase = var.wifi_credentials.iot

  uapsd = true
  proxy_arp = true
  bss_transition = true
  multicast_enhance = true
  minimum_data_rate_2g_kbps = 0
  minimum_data_rate_5g_kbps = 0

  network_id = unifi_network.iot.id
  ap_group_ids = [data.unifi_ap_group.default.id]
  user_group_id = data.unifi_user_group.default.id
  radius_profile_id = data.unifi_radius_profile.default.id
}

resource "unifi_wlan" "gaming" {
  name = "gaming"
  hide_ssid = true
  wlan_band = "5g"
  security = "wpapsk"
  passphrase = var.wifi_credentials.gaming

  uapsd = true
  proxy_arp = true
  bss_transition = true
  fast_roaming_enabled = true
  minimum_data_rate_2g_kbps = 0
  minimum_data_rate_5g_kbps = 0

  network_id = unifi_network.gaming.id
  ap_group_ids = [data.unifi_ap_group.default.id]
  user_group_id = data.unifi_user_group.default.id
  radius_profile_id = data.unifi_radius_profile.default.id
}

resource "unifi_wlan" "guest" {
  name = "wifi"
  hide_ssid = false
  wlan_band = "both"
  security = "wpapsk"
  passphrase = var.wifi_credentials.guest

  bss_transition = true
  fast_roaming_enabled = true
  minimum_data_rate_2g_kbps = 0
  minimum_data_rate_5g_kbps = 0

  network_id = unifi_network.guest.id
  ap_group_ids = [data.unifi_ap_group.default.id]
  user_group_id = data.unifi_user_group.default.id
  radius_profile_id = data.unifi_radius_profile.default.id
}

resource "unifi_wlan" "work" {
  name = "work"
  hide_ssid = true
  wlan_band = "5g"
  security = "wpaeap"

  bss_transition = true
  fast_roaming_enabled = true
  minimum_data_rate_2g_kbps = 0
  minimum_data_rate_5g_kbps = 0

  network_id = unifi_network.work.id
  ap_group_ids = [data.unifi_ap_group.default.id]
  user_group_id = data.unifi_user_group.default.id
  radius_profile_id = data.unifi_radius_profile.default.id
}
