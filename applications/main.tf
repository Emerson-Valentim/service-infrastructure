module "network" {
  source = "./network"
  env    = var.env
  region = var.region
}

module "storage" {
  source = "./storage"
  env    = var.env
  redis-sg = {
    worker = [module.network.main-worker-redis-sg.id]
    socket = [module.network.main-socket-redis-sg.id]
  }

  subnets = module.network.main-vpc.elasticache_subnet_group_name
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

module "kafka" {
  source  = "./kafka"
  env     = var.env
  network = module.network
  dns     = module.dns
}

module "service-1" {
  source  = "./example-service"
  service = "event-boilerplate"

  env    = var.env
  region = var.region

  gateway = module.api-gateway
  network = module.network
  ecr     = module.storage.main-ecr
  redis   = module.storage.redis
  kafka   = module.kafka
  dns     = module.dns
}