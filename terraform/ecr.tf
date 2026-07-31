resource "aws_ecr_repository" "healthcare_api" {
  name                 = var.ecr_repository_name
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Project     = "Healthcare Cloud Platform"
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}

resource "aws_ecr_lifecycle_policy" "healthcare_api" {
  repository = aws_ecr_repository.healthcare_api.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep only the latest 10 untagged images"

        selection = {
          tagStatus   = "untagged"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }

        action = {
          type = "expire"
        }
      }
    ]
  })
}