terraform {
  required_providers {
    unifi = {
      source  = "paultyng/unifi"
      version = "~> 0.41"
    }
  }
}

# docs: https://registry.terraform.io/providers/paultyng/unifi/0.41.0/docs
provider "unifi" {
  username = var.username
  password = var.password
  api_url  = var.api_url
  allow_insecure = var.insecure
}
