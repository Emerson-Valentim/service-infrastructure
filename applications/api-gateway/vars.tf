variable "env" {
  type    = string
  default = "stg"
}

variable "region" {
  type    = string
  default = "sa-east-1"
}

variable "dns" {
  type    = any
  default = {}
}