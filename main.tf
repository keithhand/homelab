module "unifi" {
  source   = "./modules/unifi"
  insecure = true
  api_url  = var.unifi-creds.api_url
  username = var.unifi-creds.username
  password = var.unifi-creds.password
  network  = var.unifi.network
}
