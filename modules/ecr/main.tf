resource "aws_ecr_repository" "ecr_repo" {
  name         = "${var.name}-repo"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.name}-ecr"
  }
}