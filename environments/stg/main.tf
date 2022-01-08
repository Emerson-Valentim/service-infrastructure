provider "aws" {
  region  = "sa-east-1"
}

module "applications" {
  source      = "../../applications"
  env = var.env
}