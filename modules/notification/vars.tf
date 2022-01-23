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

variable "public_subnet_ids" {
  type    = list(string)
  default = []
}

variable "security_groups" {
  type    = list(string)
  default = []
}

variable "cluster" {
  type    = any
  default = {}
}

variable "env_vars" {
  type    = map(string)
  default = {}
}

variable "ecr_url" {
  type    = string
  default = "unset"
}

variable "vpc_id" {
  type    = string
  default = "unset"
}

variable "dns" {
  type    = any
  default = {}
}
