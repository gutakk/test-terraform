resource "aws_ecr_repository" "main" {
  name = var.namespace

  tags = {
    Owner = var.owner
  }
}
