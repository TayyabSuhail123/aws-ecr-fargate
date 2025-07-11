resource "aws_ecr_repository" "ecr_repo" {
  name = "${var.name}-repo"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.name}-ecr"
  }
}