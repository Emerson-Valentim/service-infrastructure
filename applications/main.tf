module "network" {
  source = "./network"
  env    = var.env
  region = var.region
}

module "storage" {
  source = "./storage"
  env    = var.env
}

module "service-1" {
  source = "./example-service"

  env    = var.env
  region = var.region

  network = module.network

  service = "event-boilerplate"

  ecr = module.storage.main-ecr
}