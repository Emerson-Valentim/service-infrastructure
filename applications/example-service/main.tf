module "api" {
  source = "../../modules/api"

  env        = var.env
  region     = var.region
  service    = var.service
  subnet_ids = var.network.main-vpc.private_subnets
}

module "consumer" {
  source = "../../modules/consumer"

  env    = var.env
  region = var.region
}

module "worker" {
  source = "../../modules/worker"

  env    = var.env
  region = var.region
}

module "notification" {
  source = "../../modules/notification"

  env    = var.env
  region = var.region
}