variable "region" {
  type    = string
  default = "ap-southeast-2"
}

variable "cluster_name" {
  type    = string
  default = "eks-cluster"
}

variable "private_subnets" {
  type = list(string)
}

variable "vpc_id" {
  type    = string
}

variable "kubernetes_version" {
  type    = string
}
variable "manage_aws_auth_configmap" {
  type    = bool
  default = false
}

variable "tfc_hostname" {
  type    = string
  default = "https://app.terraform.io"
}

variable "tfc_kubernetes_audience" {
  type    = string
}

variable "eks_clusteradmin_arn" {
  type    = string
  default = "arn:aws:iam::855831148133:role/aws_simon.lynch_test-developer"
}

variable "eks_clusteradmin_username" {
  type    = string
  default = "aws_simon.lynch_test-developer"
}