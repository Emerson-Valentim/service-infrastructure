resource "aws_ecs_task_definition" "ecs_task_definition" {
  family = "${var.task_family}-${var.env}"

  task_role_arn      = var.ecs_role_arn
  execution_role_arn = var.ecs_role_arn

  network_mode = "awsvpc"

  requires_compatibilities = ["FARGATE"]

  memory = 512
  cpu    = 256

  container_definitions = var.container_definitions

  tags = {
    Environment = "${var.env}"
  }
}

data "aws_ecs_task_definition" "ecs_task_definition" {
  task_definition = aws_ecs_task_definition.ecs_task_definition.family
}

resource "aws_ecs_service" "ecs_service" {
  name = "${var.service_name}-${var.env}"

  cluster         = var.cluster.arn
  task_definition = "${aws_ecs_task_definition.ecs_task_definition.family}:${max("${aws_ecs_task_definition.ecs_task_definition.revision}", "${data.aws_ecs_task_definition.ecs_task_definition.revision}")}"

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  dynamic "load_balancer" {
    for_each = length(var.load-balancer.target-group-arn) > 0 ? [1] : []
    content {
      target_group_arn = var.load-balancer.target-group-arn
      container_name   = var.load-balancer.container-name
      container_port   = var.load-balancer.container-port
    }
  }

  deployment_controller {
    type = "ECS"
  }

  deployment_circuit_breaker {
    enable   = false
    rollback = false
  }

  health_check_grace_period_seconds = 0
  desired_count                     = 1
  platform_version                  = "LATEST"
  enable_ecs_managed_tags           = true
  enable_execute_command            = false

  launch_type = "FARGATE"

  network_configuration {
    assign_public_ip = true
    security_groups  = var.security_groups
    subnets          = var.subnets
  }

  tags = {
    Environment = "${var.env}"
  }

}