variable "namespace" {
  type    = string
}

variable "labels" {
  type    = any
  default = {
    mylabel = "example-label"
  }
}