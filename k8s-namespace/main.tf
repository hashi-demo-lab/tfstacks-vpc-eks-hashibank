resource "kubernetes_namespace_v1" "example" {
  metadata {
    annotations = {
      name = "example-annotation"
    }

    labels = {
      mylabel = "example-label"
    }

    name = var.namespace
  }
}