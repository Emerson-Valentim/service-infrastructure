resource "aws_ecr_repository" "main_ecr_storage" {
  name                 = "main-${var.env}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "expire_policy" {
  repository = aws_ecr_repository.main_ecr_storage.name

  policy = file("${path.module}/ecr-expire-policy.json")
}

resource "aws_elasticache_replication_group" "worker-redis" {
  replication_group_description = "redis for worker"
  replication_group_id          = "worker-${var.env}"
  automatic_failover_enabled    = false
  engine                        = "redis"
  node_type                     = "cache.t2.micro"
  number_cache_clusters         = 1
  port                          = 6379
  subnet_group_name             = var.subnets
  security_group_ids            = var.redis-sg.worker
  apply_immediately             = true
}

resource "aws_elasticache_replication_group" "socket-redis" {
  replication_group_description = "redis for socket"
  replication_group_id          = "socket-${var.env}"
  automatic_failover_enabled    = false
  engine                        = "redis"
  node_type                     = "cache.t2.micro"
  number_cache_clusters         = 1
  port                          = 6379
  subnet_group_name             = var.subnets
  security_group_ids            = var.redis-sg.socket
  apply_immediately             = true
}