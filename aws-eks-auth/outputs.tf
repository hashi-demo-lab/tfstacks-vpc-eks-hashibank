output "eks_token" {
  value = nonsensitive(data.aws_eks_cluster_auth.upstream_auth.token)
  sensitive = false
}

output "eks_endpoint" {
  value = data.aws_eks_cluster.upstream.endpoint
}

output "cluster_name" {
  value = data.aws_eks_cluster.upstream.id
}