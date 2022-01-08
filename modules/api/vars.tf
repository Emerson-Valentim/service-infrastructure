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

variable "subnet_ids" {
  type    = list(string)
  default = []
}

variable "security_groups" {
  type    = any
  default = {}
}
  