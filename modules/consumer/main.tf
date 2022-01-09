locals {
  log_group_name = "/ecs/${var.service}/consumer"
  parsed_env_vars = [
    for key, value in var.env_vars : {
      name  = key
      value = value
    }
  ]
}

resource "aws_iam_role" "iam_for_ecs" {
  name = "${var.service}-consumer-${var.env}"

  assume_role_policy = file("${path.module}/ecs-policy.json")
}

resource "aws_iam_policy" "policy_for_ecs" {
  name = "${var.service}-consumer-${var.env}"
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

module "ecs" {
  source = "../../resources/ecs"

  env          = var.env
  cluster      = var.cluster
  task_family  = "${var.service}-consumer"
  service_name = "${var.service}-consumer"

  security_groups = var.security_groups
  subnets         = var.subnet_ids

  ecs_role_arn = aws_iam_role.iam_for_ecs.arn

  container_definitions = templatefile("${path.module}/container-definition.json.tpl", {
    cloudwatch_log_group = local.log_group_name,
    env_vars             = jsonencode(local.parsed_env_vars),
    ecr_image            = "${var.ecr_url}:${var.service}-consumer-${var.env}_latest",
    region               = "${var.region}"
  })
}