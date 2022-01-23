locals {
  log_group_name = "/aws/ecs/${var.service}-notification"
  parsed_env_vars = [
    for key, value in var.env_vars : {
      name  = key
      value = value
    }
  ]
}

resource "aws_iam_role" "iam_for_ecs" {
  name = "${var.service}-notification-${var.env}"

  assume_role_policy = file("${path.module}/ecs-policy.json")
}

resource "aws_iam_policy" "policy_for_ecs" {
  name = "${var.service}-notification-${var.env}"
  path = "/"
  policy = templatefile("${path.module}/ecs-policy.json.tpl", {
    cloudwatch_log_group = module.cloudwatch.logs.arn
  })
}

resource "aws_iam_role_policy_attachment" "ecs_policy_attachment" {
  role       = aws_iam_role.iam_for_ecs.name
  policy_arn = aws_iam_policy.policy_for_ecs.arn
}

module "cloudwatch" {
  source = "../../resources/cloudwatch"

  name = local.log_group_name
  env  = var.env
}

module "load_balancer" {
  source = "../../resources/load-balancer"

  env               = var.env
  security_groups   = var.security_groups
  subnets           = var.public_subnet_ids
  service           = "${var.service}-notification"
  vpc_id            = var.vpc_id
  dns               = var.dns
  health-check-port = 3000
}

module "ecs" {
  source = "../../resources/ecs"

  env          = var.env
  cluster      = var.cluster
  task_family  = "${var.service}-notification"
  service_name = "${var.service}-notification"

  security_groups = var.security_groups
  subnets         = var.subnet_ids
  dns             = var.dns

  load-balancer = {
    target-group-arn = module.load_balancer.target_group_arn
    container-port   = 3000
    container-name   = "notification"
  }

  ecs_role_arn = aws_iam_role.iam_for_ecs.arn

  container_definitions = templatefile("${path.module}/container-definition.json.tpl", {
    cloudwatch_log_group = module.cloudwatch.logs.name,
    env_vars             = jsonencode(local.parsed_env_vars),
    ecr_image            = "${var.ecr_url}:${var.service}-notification-${var.env}_latest",
    region               = "${var.region}"
  })
}