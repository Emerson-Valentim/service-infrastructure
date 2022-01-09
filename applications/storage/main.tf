resource "aws_ecr_repository" "main_ecr_storage" {
  name                 = "main-${var.env}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}