output "namespace" {
  value = kubernetes_namespace_v1.example.metadata[0].name
}