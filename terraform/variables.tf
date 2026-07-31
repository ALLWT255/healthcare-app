variable "aws_region" {
  description = "AWS region used fr the healthcare application"
  type        = string
  default     = "us-east-1"
}

variable "ecr_repository_name" {
  description = "Name os the ECR repository for the healthcare API"
  type        = string
  default     = "healthcare-api"
}

variable "private_subnet_ids" {
  description = "Private subnet IDs used by the ECS service"
  type        = list(string)

  default = [
    "subnet-placeholder-a",
    "subnet-placeholder-b"
  ]
}

variable "ecs_security_group_id" {
  description = "Security group attached to the ECS tasks"
  type        = string
  default     = "sg-placeholder"
}