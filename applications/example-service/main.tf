resource "aws_ecs_cluster" "cluster" {
  name = "${var.service}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  capacity_providers = [
    "FARGATE",
    "FARGATE_SPOT"
  ]

  tags = {
    Environment = "${var.env}"
  }
}

module "api" {
  source = "../../modules/api"

  env        = var.env
  region     = var.region
  service    = var.service
  subnet_ids = var.network.main-vpc.private_subnets

  security_groups = [var.network.main-api-sg.id]
}


module "consumer" {
  source = "../../modules/consumer"

  env        = var.env
  region     = var.region
  service    = var.service
  subnet_ids = var.network.main-vpc.private_subnets

  security_groups = [var.network.main-consumer-sg.id]

  cluster = aws_ecs_cluster.cluster
}

module "worker" {
  source = "../../modules/worker"

  env        = var.env
  region     = var.region
  service    = var.service
  subnet_ids = var.network.main-vpc.private_subnets

  security_groups = [var.network.main-worker-sg.id]

  cluster = aws_ecs_cluster.cluster
}

module "notification" {
  source = "../../modules/notification"

  env        = var.env
  region     = var.region
  service    = var.service
  subnet_ids = var.network.main-vpc.private_subnets

  security_groups = [var.network.main-notification-sg.id]

  cluster = aws_ecs_cluster.cluster
}