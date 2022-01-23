variable "env" {
  type    = string
  default = "stg"
}

variable "redis-sg" {
  type = object({
    worker = list(string)
    socket = list(string)
  })
}

variable "subnets" {
  type    = any
  default = {}
}