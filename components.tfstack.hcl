#AWS VPC
component "vpc" {
  #for_each = var.regions

  source = "./aws-vpc"

  inputs = {
    vpc_name = var.vpc_name
    vpc_cidr = var.vpc_cidr
  }

  providers = {
    aws     = provider.aws.configurations
  }
} 

#AWS EKS
component "eks" {
  #for_each = var.regions

  source = "./aws-eks-fargate"

  inputs = {
    vpc_id = component.vpc.vpc_id
    private_subnets = component.vpc.private_subnets
    kubernetes_version = var.kubernetes_version
    cluster_name = var.cluster_name
    tfc_hostname = var.tfc_hostname
    tfc_kubernetes_audience = var.tfc_kubernetes_audience
    eks_clusteradmin_arn = var.eks_clusteradmin_arn
    eks_clusteradmin_username = var.eks_clusteradmin_username
  }

  providers = {
    aws    = provider.aws.configurations
    cloudinit = provider.cloudinit.this
    kubernetes  = provider.kubernetes.this
    time = provider.time.this
    tls = provider.tls.this
  }
}

# Update K8s role-binding
component "k8s-rbac" {
  #for_each = var.regions

  source = "./k8s-rbac"

  inputs = {
    cluster_endpoint = component.eks.cluster_endpoint
    tfc_organization_name = var.tfc_organization_name
  }

  providers = {
    kubernetes  = provider.kubernetes.configurations
  }
}


# K8s Addons - aws load balancer controller, coredns, vpc-cni, kube-proxy
component "k8s-addons" {
  #for_each = var.regions

  source = "./aws-eks-addon"

  inputs = {
    cluster_name = component.eks.cluster_name
    vpc_id = component.vpc.vpc_id
    private_subnets = component.vpc.private_subnets
    cluster_endpoint = component.eks.cluster_endpoint
    cluster_version = component.eks.cluster_version
    oidc_provider_arn = component.eks.oidc_provider_arn
    cluster_certificate_authority_data = component.eks.cluster_certificate_authority_data
  }

  providers = {
    kubernetes  = provider.kubernetes.oidc_configurations
    helm  = provider.helm.oidc_configurations
    aws    = provider.aws.configurations
    time = provider.time.this
  }
}

# Namespace
component "k8s-namespace" {
  #for_each = var.regions

  source = "./k8s-namespace"

  inputs = {
    namespace = var.namespace
    labels = component.k8s-addons.eks_addons
  }

  providers = {
    kubernetes  = provider.kubernetes.oidc_configurations
  }
}

# Deploy Hashibank
component "deploy-hashibank" {
  #for_each = var.regions

  source = "./hashibank-deploy"

  inputs = {
    hashibank_namespace = component.k8s-namespace.namespace
  }

  providers = {
    kubernetes  = provider.kubernetes.oidc_configurations
    time = provider.time.this
  }
}