required_providers {
  aws = {
    source  = "hashicorp/aws"
    version = "~> 5.0"
  }

  cloudinit = {
    source  = "hashicorp/cloudinit"
    version = "~> 2.0"
  }

  kubernetes = {
    source  = "hashicorp/kubernetes"
    version = "~> 2.25"
  }

  time = {
    source = "hashicorp/time"
    version = "~> 0.1"
  }
  
  tls = {
    source = "hashicorp/tls"
    version = "~> 4.0"
  }

  helm = {
    source = "hashicorp/helm"
    version = "~> 2.12"
  }

  local = {
    source = "hashicorp/local"
    version = "~> 2.4"
  }

}

provider "aws" "configurations" {
  #for_each = var.regions

  config {
    region = var.regions

    assume_role_with_web_identity {
      role_arn                = var.role_arn
      web_identity_token_file = var.aws_identity_token_file
    }
  }
}



provider "kubernetes" "configurations" {
  #for_each = var.regions
  config { 
    host                   = component.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(component.eks.cluster_certificate_authority_data)
    token   = component.eks.eks_token
  }
}

/* provider "kubernetes" "configurations"  {
  #for_each = var.regions
  config {
  host                   = component.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(component.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["sts", "AssumeRoleWithWebIdentity", "--web-identity-token", file(var.aws_identity_token_file), "--role-arn", var.role_arn,":", "aws", "eks", "get-token", "--cluster-name", var.cluster_name, "--role-arn", var.role_arn]
      command     = "aws"
    }
  }
}
 */
provider "kubernetes" "oidc_configurations" {
  #for_each = var.regions
  config { 
    host                   = component.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(component.eks.cluster_certificate_authority_data)
    token   = file(var.k8s_identity_token_file)
  }
}

provider "helm" "oidc_configurations" {
  #for_each = var.regions
  config {
    kubernetes {
      host                   = component.eks.cluster_endpoint
      cluster_ca_certificate = base64decode(component.eks.cluster_certificate_authority_data)
      token   = file(var.k8s_identity_token_file)
    }
  }
}


provider "cloudinit" "this" {}
provider "kubernetes" "this" {}
provider "time" "this" {}
provider "tls" "this" {}
provider "local" "this" {}