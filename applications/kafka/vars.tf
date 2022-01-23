variable "env" {
  type    = string
  default = "stg"
}

variable "network" {
  type    = any
  default = {}
}

variable "dns" {
  type    = any
  default = {}
}