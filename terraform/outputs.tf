output "ecr_repository_name" {
  description = "Name of the healthcare API ECR repository"
  value       = aws_ecr_repository.healthcare_api.name
}

output "ecr_repository_url" {
  description = "URL GitHub Actions and ECS will use for the Docker image"
  value       = aws_ecr_repository.healthcare_api.repository_url
}