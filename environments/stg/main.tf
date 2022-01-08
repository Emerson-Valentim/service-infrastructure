provider "aws" {
  region = "${var.region}-1"
}

module "applications" {
  source = "../../applications"
  env    = var.env
  region = var.region
}