resource "aws_iam_role" "ecs_task_role" {
  name = "healthcare-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "Healthcare ECS Task Role"
  }
}
resource "aws_iam_policy" "secrets_manager_policy" {
  name        = "healthcare-secrets-manager-policy"
  description = "Allow ECS tasks to retrieve database credentials"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "secretsmanager:GetSecretValue"
        ]

        Resource = aws_secretsmanager_secret.db_credentials.arn
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "ecs_task_secrets_policy" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.secrets_manager_policy.arn
}