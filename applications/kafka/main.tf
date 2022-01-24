locals {
  log_group_name = "/aws/kafka"
}

module "cloudwatch" {
  source = "../../resources/cloudwatch"

  name = local.log_group_name
  env  = var.env
}

module "kafka" {
  source = "cloudposse/msk-apache-kafka-cluster/aws"

  namespace                 = "eg"
  stage                     = var.env
  name                      = "app"
  vpc_id                    = var.network.main-vpc.vpc_id
  zone_id                   = var.dns.zone_id
  subnet_ids                = var.network.main-vpc.private_subnets
  kafka_version             = "2.6.2"
  number_of_broker_nodes    = 3
  broker_instance_type      = "kafka.t3.small"
  cloudwatch_logs_enabled   = true
  cloudwatch_logs_log_group = module.cloudwatch.logs.name

  associated_security_group_ids = [var.network.main-kafka-sg.id]

  properties = {
    "auto.create.topics.enable" = true
    "delete.topic.enable"       = true
  }
}