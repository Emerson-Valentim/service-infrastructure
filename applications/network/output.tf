output "main-vpc" {
  value = module.main-vpc
}

output "main-api-sg" {
  value = aws_security_group.api
}