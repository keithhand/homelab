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

resource "kubernetes_namespace" "application_charts" {
  metadata {
    name = "application-charts"
  }
}

locals {
  applications_dir = "${path.module}/applications"
  applications_config_file = "config.yaml"
}

data "local_file" "application_config_yaml" {
  for_each = toset([for config_file in fileset(local.applications_dir, "*/${local.applications_config_file}") : split("/", config_file)[0] ])
  filename = "${local.applications_dir}/${each.value}/${local.applications_config_file}"
}

module "helmcharts" {
  source = "./modules/helmcharts"
  for_each = data.local_file.application_config_yaml
  name = each.key
  chart = {
    # defaults: https://github.com/bjw-s/helm-charts/blob/main/charts/
    repo = lookup(lookup(yamldecode(each.value.content), "chart", {}), "repo", "https://bjw-s.github.io/helm-charts")
    name = lookup(lookup(yamldecode(each.value.content), "chart", {}), "name", "app-template")
  }
  namespace = {
    management = kubernetes_namespace.application_charts.id
    target = lookup(yamldecode(each.value.content), "namespace", each.key)
  }
  values = lookup(yamldecode(each.value.content), "values")
}
