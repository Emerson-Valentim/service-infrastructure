output "main-ecr" {
  value = aws_ecr_repository.main_ecr_storage
}

output "redis" {
  value = {
    worker = aws_elasticache_replication_group.worker-redis
    socket = aws_elasticache_replication_group.socket-redis
  }
}