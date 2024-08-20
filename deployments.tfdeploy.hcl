identity_token "aws" {
  audience = ["terraform-stacks-private-preview"]
}

identity_token "k8s" {
  audience = ["k8s.workload.identity"]
}


deployment "development" {
  inputs = {
    aws_identity_token = identity_token.aws.jwt
    role_arn            = "arn:aws:iam::855831148133:role/tfstacks-role"
    regions             = "ap-southeast-2"
    vpc_name = "vpc-dev1"
    vpc_cidr = "10.0.0.0/16"

    #EKS Cluster
    kubernetes_version = "1.30"
    cluster_name = "eksdev03"
    
    #EKS OIDC
    tfc_kubernetes_audience = "k8s.workload.identity"
    tfc_hostname = "https://app.terraform.io"
    tfc_organization_name = "hashi-demos-apj"
    eks_clusteradmin_arn = "arn:aws:iam::855831148133:role/aws_simon.lynch_test-developer"
    eks_clusteradmin_username = "aws_simon.lynch_test-developer"

    #K8S
    k8s_identity_token = identity_token.k8s.jwt
    namespace = "hashibank"

  }
}

deployment "prod" {
  inputs = {
    aws_identity_token = identity_token.aws.jwt
    role_arn            = "arn:aws:iam::855831148133:role/tfstacks-role"
    regions             = "ap-southeast-2"
    vpc_name = "vpc-prod1"
    vpc_cidr = "10.20.0.0/16"

    #EKS Cluster
    kubernetes_version = "1.30"
    cluster_name = "eksprod03"
    
    #EKS OIDC
    tfc_kubernetes_audience = "k8s.workload.identity"
    tfc_hostname = "https://app.terraform.io"
    tfc_organization_name = "hashi-demos-apj"
    eks_clusteradmin_arn = "arn:aws:iam::855831148133:role/aws_simon.lynch_test-developer"
    eks_clusteradmin_username = "aws_simon.lynch_test-developer"

    #K8S
    k8s_identity_token = identity_token.k8s.jwt
    namespace = "hashibank"

  }
}