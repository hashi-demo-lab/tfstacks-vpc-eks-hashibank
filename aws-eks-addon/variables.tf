
variable "vpc_id" {
  type    = string
}

variable "cluster_name" {
  type    = string
}

variable "cluster_endpoint" {
  type    = string
}

variable "cluster_version" {
  type    = string
}

variable "oidc_provider_arn" {
  type    = string
}

variable "cluster_certificate_authority_data" {
  type    = string
}

variable "oidc_binding_id" {
  type    = string
  description = "used for component dependency"
}