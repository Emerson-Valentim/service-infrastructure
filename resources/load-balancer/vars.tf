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

variable "subnets" {
  type    = any
  default = {}
}

variable "security_groups" {
  type    = list(string)
  default = []
}

variable "vpc_id" {
  type    = string
  default = "unset"
}

variable "dns" {
  type    = any
  default = {}
}

variable "health-check-port" {
  type    = number
  default = 80
}