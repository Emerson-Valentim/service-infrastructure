resource "aws_lb" "load_balancer" {
  name               = var.service
  load_balancer_type = "application"

  subnets         = var.subnets
  security_groups = var.security_groups

  drop_invalid_header_fields = false
  enable_deletion_protection = false
  enable_http2               = true

  ip_address_type = "ipv4"

  tags = {
    Environment = "${var.env}"
  }
}

resource "aws_lb_target_group" "lb_target_group" {
  name = var.service

  target_type = "ip"

  port             = 80
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  vpc_id           = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = var.health-check-port
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

}

resource "aws_lb_listener" "ld_listener_http" {
  port     = 443
  protocol = "HTTPS"

  load_balancer_arn = aws_lb.load_balancer.id
  certificate_arn   = var.dns.certificate_arn

  default_action {
    target_group_arn = aws_lb_target_group.lb_target_group.id
    type             = "forward"
  }

  tags = {
    Environment = "${var.env}"
  }
}

resource "aws_route53_record" "domain" {
  zone_id = var.dns.zone_id
  name    = var.service
  type    = "A"

  alias {
    name                   = aws_lb.load_balancer.dns_name
    zone_id                = aws_lb.load_balancer.zone_id
    evaluate_target_health = true
  }
}