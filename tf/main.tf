module unifi {
  source = "./modules/unifi"

  username = var.unifi.username
  password = var.unifi.password
  api_url = var.unifi.api_url
  insecure = var.unifi.insecure

  wifi_credentials = module.onepassword.wifi_credentials
}

module "onepassword" {
  source = "./modules/onepassword"

  api_url = var.onepassword.api_url
  token = var.onepassword.token
}
