resource "kubernetes_manifest" "helmchartconfig" {
  manifest = {
    "apiVersion" = "helm.cattle.io/v1"
    "kind"       = "HelmChartConfig"
    "metadata" = {
      "name"      = var.name
      "namespace" = var.namespace.management
    }
    "spec" = {
      "valuesContent" = yamlencode(var.values)
    }
  }
  field_manager {
    name = "valuesContent"
    force_conflicts = true
  }
}
