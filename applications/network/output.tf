output "main-vpc" {
  value = module.main-vpc
}

output "main-api-sg" {
  value = aws_security_group.api
}

output "main-consumer-sg" {
  value = aws_security_group.consumer
}

output "main-notification-sg" {
  value = aws_security_group.notification
}

output "main-worker-sg" {
  value = aws_security_group.worker
}