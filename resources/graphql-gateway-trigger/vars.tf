variable "env" {
  type    = string
  default = "stg"
}
variable "region" {
  type    = string
  default = "sa-east-1"
}

variable "service" {
  type    = string
  default = "unset"
}

variable "invoke_arn" {
  default = "unset"
  type    = string
}

variable "function_name" {
  default = "unset"
  type    = string
}

variable "gateway" {
  type    = any
  default = {}
}