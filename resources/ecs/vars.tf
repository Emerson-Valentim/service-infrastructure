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

variable "ecs_role_arn" {
  type    = string
  default = "unset"
}

variable "load-balancer" {
  type = object({
    target-group-arn = string
    container-name   = string
    container-port   = number
  })

  default = {
    target-group-arn = ""
    container-name   = ""
    container-port   = 0
  }
}

variable "dns" {
  type    = any
  default = {}
}