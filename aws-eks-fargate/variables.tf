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