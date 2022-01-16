module "network" {
  source = "./network"
  env    = var.env
  region = var.region
}

module "storage" {
  source = "./storage"
  env    = var.env
}

module "dns" {
  source = "./dns"
}

module "api-gateway" {
  source = "./api-gateway"
  env    = var.env
  region = var.region
  dns    = module.dns
}

module "service-1" {
  source  = "./example-service"
  service = "event-boilerplate"

  env    = var.env
  region = var.region

  gateway = module.api-gateway
  network = module.network
  ecr     = module.storage.main-ecr
}