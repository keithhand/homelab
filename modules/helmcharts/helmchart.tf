resource "kubernetes_manifest" "helmchart" {
  depends_on = [ kubernetes_manifest.helmchartconfig ]
  manifest = {
    "apiVersion" = "helm.cattle.io/v1"
    "kind" = "HelmChart"
    "metadata" = {
      "name" = var.name
      "namespace" = var.namespace.management
    }
    "spec" = {
      "helmVersion" = "v3"
      "repo" = var.chart.repo
      "chart" = var.chart.name
      "targetNamespace" = var.namespace.target
    }
  }
}
