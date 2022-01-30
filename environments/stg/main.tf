provider "aws" {
  region = var.region
}

module "applications" {
  source = "../../applications"
  env    = var.env
  region = var.region
}