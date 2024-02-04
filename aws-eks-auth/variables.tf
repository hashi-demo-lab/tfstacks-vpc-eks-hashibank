variable "tfc_kubernetes_audience" {
  type    = string
  default = "k8s.workload.identity"
}

variable "tfc_hostname" {
  type    = string
  default = "https://app.terraform.io"
}

variable "cluster_name" {
  type    = string
}

