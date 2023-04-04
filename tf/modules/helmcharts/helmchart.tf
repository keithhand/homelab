resource "kubernetes_manifest" "helmchart" {
  manifest = {
    "apiVersion" = "helm.cattle.io/v1"
    "kind" = "HelmChart"
    "metadata" = {
      "name" = var.name
      "namespace" = var.namespace.management
    }
    "spec" = {
      "repo" = var.chart.repo
      "chart" = var.chart.name
      "targetNamespace" = var.namespace.target
    }
  }
}
