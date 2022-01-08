module "cloudwatch" {
  source = "../../resources/cloudwatch"

  name = "/ecs/${var.service}/consumer"
}

module "ecs" {
  source = "../../resources/ecs"

  env          = var.env
  cluster      = var.cluster
  task_family  = "${var.service}-task"
  service_name = "${var.service}-service"

  security_groups = var.security_groups
  subnets         = var.subnet_ids

  container_definitions = templatefile("${path.module}/container-definition.json.tpl", {
    cloudwatch_log_group = module.cloudwatch.logs.arn,
    env_vars             = jsonencode([
      {
        "name" : "NODE_ENV",
        "value" : "${var.env}"
      },
    ]),
    ecr_image            = "",
    region               = "${var.region}"
  })
}