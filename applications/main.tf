module "network" {
  source = "./network"
  env    = var.env
  region = var.region
}

module "service-1" {
  source = "./example-service"

  env    = var.env
  region = var.region
}