terraform {
  required_providers {
    onepassword = {
      source  = "1Password/onepassword"
      version = "~> 1.1.4"
    }
  }
}

# docs: https://registry.terraform.io/providers/paultyng/unifi/0.41.0/docs
provider "onepassword" {
  url = var.api_url
  token = var.token
}
