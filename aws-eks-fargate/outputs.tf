output "configure_kubectl" {
  description = "Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
  value       = "aws eks --region ${var.region} update-kubeconfig --name ${module.eks.cluster_name}"
}

output "cluster_name" {
  description = "eks cluster_name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "eks cluster_endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_version" {
  description = "eks cluster_version"
  value       = module.eks.cluster_version
}

output "oidc_provider_arn" {
  description = "eks idc_provider_arn"
  value       = module.eks.oidc_provider_arn
}

output "cluster_certificate_authority_data" {
  description = "eks output cluster_certificate_authority_data"
  value       = module.eks.cluster_certificate_authority_data
}

output "eks_token" {
  value = nonsensitive(data.aws_eks_cluster_auth.upstream_auth.token)
  sensitive = false
}