
component "vpc" {
  for_each = var.regions

  source = "./aws-vpc"

  inputs = {
    vpc_name = var.vpc_name
    vpc_cidr = var.vpc_cidr
  }

  providers = {
    aws     = provider.aws.configurations[each.value]
  }
} 

component "eks" {
  for_each = var.regions

  source = "./aws-eks-fargate"

  inputs = {
    vpc_id = component.vpc[each.value].vpc_id
    private_subnets = component.vpc[each.value].private_subnets
    kubernetes_version = var.kubernetes_version
    cluster_name = var.cluster_name
    manage_aws_auth_configmap = var.manage_aws_auth_configmap
  }

  providers = {
    aws    = provider.aws.configurations[each.value]
    cloudinit = provider.cloudinit.this
    kubernetes  = provider.kubernetes.this
    time = provider.time.this
    tls = provider.tls.this
  }
}

# AWS EKS OIDC pre-reqs
component "eks-oidc" {
  for_each = var.regions

  source = "./aws-eks-oidc"

  inputs = {
    cluster_name = component.eks[each.value].cluster_name
    tfc_kubernetes_audience = var.tfc_kubernetes_audience
    tfc_hostname = var.tfc_hostname
    
  }

  providers = {
    aws    = provider.aws.configurations[each.value]
  }
}

# Create K8s Namespace
component "k8s-identity" {
  for_each = var.regions

  source = "./k8s-oidc"

  inputs = {
    cluster_namespace = component.eks-oidc[each.value].cluster_name
    tfc_organization_name = var.tfc_organization_name
  }

  providers = {
    kubernetes  = provider.kubernetes.configurations[each.value]
  }
}

# K8s Addons
component "k8s-addons" {
  for_each = var.regions

  source = "./aws-eks-addon"

  inputs = {
    cluster_name = component.eks-oidc[each.value].cluster_name
    vpc_id = component.vpc[each.value].vpc_id
    private_subnets = component.vpc[each.value].private_subnets
    cluster_endpoint = component.eks-oidc[each.value].eks_endpoint
    cluster_version = component.eks[each.value].cluster_version
    oidc_provider_arn = component.eks[each.value].oidc_provider_arn
    cluster_certificate_authority_data = component.eks[each.value].cluster_certificate_authority_data   
  }

  providers = {
    kubernetes  = provider.kubernetes.oidc_configurations[each.value]
    helm  = provider.helm.oidc_configurations[each.value]
    aws    = provider.aws.configurations[each.value]
    time = provider.time.this
  }
}

# Namespace
component "k8s-namespace" {
  for_each = var.regions

  source = "./k8s-namespace"

  inputs = {
    namespace = var.namespace
    tfc_organization_name = var.tfc_organization_name
  }

  providers = {
    kubernetes  = provider.kubernetes.oidc_configurations[each.value]
  }
}

# Deploy Hashibank
component "deploy-hashibank" {
  for_each = var.regions

  source = "./hashibank-deploy"

  inputs = {
    hashicups_namspace = component.k8s-namespace[each.value].namespace
  }

  providers = {
    kubernetes  = provider.kubernetes.oidc_configurations[each.value]
  }
}