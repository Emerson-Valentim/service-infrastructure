output "target_group_arn" {
  value = aws_lb_target_group.lb_target_group.arn
}

output "domain" {
  value = aws_route53_record.domain.fqdn
}