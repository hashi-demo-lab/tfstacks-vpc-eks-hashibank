locals {

  tags = {
    Blueprint  = var.cluster_name
  }
}


module "eks" {
  source  = "git::https://github.com/hashi-demo-lab/terraform-aws-eks.git?ref=v19.21.4"

  cluster_name                   = var.cluster_name
  cluster_version                = var.kubernetes_version 
  cluster_endpoint_public_access = true

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  manage_aws_auth_configmap = var.manage_aws_auth_configmap
  aws_auth_roles = var.aws_auth_roles

  # Fargate profiles use the cluster primary security group so these are not utilized
  create_cluster_security_group = false
  create_node_security_group    = false

  cluster_enabled_log_types = [] #disabling logs for cost - lab only

  fargate_profiles = {
    app_wildcard = {
      selectors = [
        { namespace = "hashibank*" },
        { namespace = "product*" },
        { namespace = "consul*" },
        { namespace = "frontend*" },
        { namespace = "payments*" }
      ]
    }
    kube_system = {
      name = "kube-system"
      selectors = [
        { namespace = "kube-system" }
      ]
    }
  }

  tags = local.tags
}