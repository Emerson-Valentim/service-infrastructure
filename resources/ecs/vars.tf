variable "env" {
  type    = string
  default = "stg"
}

variable "task_family" {
  type    = string
  default = "unset"
}

variable "service_name" {
  type    = string
  default = "unset"
}

variable "security_groups" {
  type    = list(string)
  default = []
}

variable "subnets" {
  type    = any
  default = {}
}

variable "cluster" {
  type    = any
  default = {}
}

variable "container_definitions" {
  type    = any
  default = {}
}