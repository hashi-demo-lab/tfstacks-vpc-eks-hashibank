
# odic-identity pre-requisite
resource "kubernetes_cluster_role_binding_v1" "oidc_role" {
  metadata {
    generate_name = "odic-identity"
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
}

data "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
}

locals {
  new_role_yaml = <<-EOF
    - groups:
      - system:masters
      rolearn: arn:aws:iam::855831148133:role/aws_simon.lynch_test-developer
      username: aws_simon.lynch_test-developer
    EOF
}

# 8. Update aws-auth configmap
resource "kubernetes_config_map_v1_data" "aws_auth_new" {
  force = true

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    # Convert to list, make distinict to remove duplicates, and convert to yaml as mapRoles is a yaml string.
    # replace() remove double quotes on "strings" in yaml output.
    # distinct() only apply the change once, not append every run.
    mapRoles = replace(yamlencode(distinct(concat(yamldecode(data.kubernetes_config_map.aws_auth.data.mapRoles), yamldecode(local.new_role_yaml)))), "\"", "")
  }

  lifecycle {
    ignore_changes = []
  }
}