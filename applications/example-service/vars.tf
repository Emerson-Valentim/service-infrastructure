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

variable "network" {
  type    = any
  default = {}
}

variable "ecr" {
  type    = any
  default = {}
}

variable "gateway" {
  type    = any
  default = {}
}

variable "kafka" {
  type    = any
  default = {}
}

variable "redis" {
  type    = any
  default = {}
}

variable "dns" {
  type    = any
  default = {}
}