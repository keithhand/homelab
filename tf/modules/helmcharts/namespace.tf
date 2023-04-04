resource "kubernetes_namespace" "target_namespace" {
  metadata {
    name = var.namespace.target
  }
}
