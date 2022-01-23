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

output "main-kafka-sg" {
  value = aws_security_group.kafka
}

output "main-worker-redis-sg" {
  value = aws_security_group.worker-redis
}

output "main-socket-redis-sg" {
  value = aws_security_group.socket-redis
}