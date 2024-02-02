required_providers {
  aws = {
    source  = "hashicorp/aws"
    version = "~> 5.0"
  }

  hcp = {
    source  = "hashicorp/hcp"
    version = "~> 0.80.0"
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

   consul = {
      source = "hashicorp/consul"
      version = "2.20.0"
  }
}

/* provider "aws" "configurations" {
  for_each = var.regions

  config {
    region = each.value

    assume_role_with_web_identity {
      role_arn                = var.role_arn
      web_identity_token_file = var.aws_identity_token_file
    }
  }
}
 */
/* provider "hcp" "configuration" {

  config {
    project_id = var.hcp_project_id

    workload_identity {
      resource_name = var.workload_idp_name
      token_file = var.hcp_identity_token_file
    }
    
  }
} */

/* provider "kubernetes" "configurations" {
  for_each = var.regions
  config { 
    host                   = component.eks-oidc[each.value].eks_endpoint
    cluster_ca_certificate = base64decode(component.eks[each.value].cluster_certificate_authority_data)
    token   = component.eks-oidc[each.value].eks_token
  }
}

provider "kubernetes" "oidc_configurations" {
  for_each = var.regions
  config { 
    host                   = component.eks-oidc[each.value].eks_endpoint
    cluster_ca_certificate = base64decode(component.eks[each.value].cluster_certificate_authority_data)
    token   = file(var.k8s_identity_token_file)
  }
}

provider "helm" "oidc_configurations" {
  for_each = var.regions
  config {
    kubernetes {
      host                   = component.eks-oidc[each.value].eks_endpoint
      cluster_ca_certificate = base64decode(component.eks[each.value].cluster_certificate_authority_data)
      token   = file(var.k8s_identity_token_file)
    }
  }
}
 */
/* # NEEDS TO MOVE TO OIDC
provider "consul" "configurations" {
  for_each = var.regions
  config {
    address = component.hcp-consul.public_endpoint_url
    token = component.hcp-consul.root_token
    datacenter = component.hcp-consul.consul_datacenter
    scheme = "https"
  }
} */


provider "cloudinit" "this" {}
provider "kubernetes" "this" {}
provider "time" "this" {}
provider "tls" "this" {}
provider "local" "this" {}

