resource "aws_eks_identity_provider_config" "oidc_config" {
  cluster_name = var.cluster_name

  oidc {
    identity_provider_config_name = "tfstack-terraform-cloud"
    client_id                     = var.tfc_kubernetes_audience
    issuer_url                    = var.tfc_hostname
    username_claim                = "sub"
    groups_claim                  = "terraform_organization_name"
  }
}

data "aws_eks_cluster" "upstream" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "upstream_auth" {
  name = var.cluster_name
}


/*
resource "kubernetes_cluster_role_binding_v1" "oidc_role" {
  metadata {
    name = "odic-identity"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = var.tfc_organization_name
  }
} */