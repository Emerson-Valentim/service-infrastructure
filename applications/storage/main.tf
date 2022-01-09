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