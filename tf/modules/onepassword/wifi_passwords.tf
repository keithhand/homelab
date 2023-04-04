data "onepassword_item" "guest_wifi_password" {
  vault = data.onepassword_vault.homelab.uuid
  title = "Home Network - Guest"
}

data "onepassword_item" "iot_wifi_password" {
  vault = data.onepassword_vault.homelab.uuid
  title = "Home Network - IOT"
}

output "wifi_credentials" {
  sensitive = true
  value = {
    lan = data.onepassword_item.guest_wifi_password.password,
    gaming = data.onepassword_item.guest_wifi_password.password,
    iot = data.onepassword_item.iot_wifi_password.password,
    guest = data.onepassword_item.guest_wifi_password.password
  }
}
