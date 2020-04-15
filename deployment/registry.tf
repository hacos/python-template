resource "aws_ecr_repository" "main" {
  name                 = "${var.prefix}-${local.environment}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
