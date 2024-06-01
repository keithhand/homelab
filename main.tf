module "unifi" {
  source   = "./modules/unifi"
  insecure = true
  api_url  = var.credentials.unifi.api_url
  username = var.credentials.unifi.username
  password = var.credentials.unifi.password
  network  = var.unifi.network
}
