identity_token "aws" {
  audience = ["terraform-stacks-private-preview"]
}

identity_token "k8s" {
  audience = ["k8s.workload.identity"]
}


deployment "development" {
  inputs = {
    aws_identity_token_file = identity_token.aws.jwt_filename
    role_arn            = "arn:aws:iam::855831148133:role/tfstacks-role"
    regions             = "ap-southeast-2"
    vpc_name = "eks-vpc-3"
    vpc_cidr = "10.0.0.0/16"

    #EKS Cluster
    kubernetes_version = "1.29"
    cluster_name = "eks-cluster-3"
    
    #EKS OIDC
    tfc_kubernetes_audience = "k8s.workload.identity"
    tfc_hostname = "https://app.terraform.io"
    tfc_organization_name = "hashi-demos-apj"
    eks_clusteradmin_arn = "arn:aws:iam::855831148133:role/aws_simon.lynch_test-developer"
    eks_clusteradmin_username = "aws_simon.lynch_test-developer"

    #K8S
    k8s_identity_token_file = identity_token.k8s.jwt_filename
    namespace = "hashibank"

  }
}

deployment "prod" {
  inputs = {
    aws_identity_token_file = identity_token.aws.jwt_filename
    role_arn            = "arn:aws:iam::855831148133:role/tfstacks-role"
    regions             = "ap-southeast-2"
    vpc_name = "eks-vpc-prod"
    vpc_cidr = "10.20.0.0/16"

    #EKS Cluster
    kubernetes_version = "1.29"
    cluster_name = "eks-cluster-3-prod"
    
    #EKS OIDC
    tfc_kubernetes_audience = "k8s.workload.identity"
    tfc_hostname = "https://app.terraform.io"
    tfc_organization_name = "hashi-demos-apj"
    eks_clusteradmin_arn = "arn:aws:iam::855831148133:role/aws_simon.lynch_test-developer"
    eks_clusteradmin_username = "aws_simon.lynch_test-developer"

    #K8S
    k8s_identity_token_file = identity_token.k8s.jwt_filename
    namespace = "hashibank"

  }
}