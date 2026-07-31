resource "aws_ecs_cluster" "healthcare_cluster" {
  name = "healthcare-cluster"

  tags = {
    Project     = "Healthcare Cloud Platform"
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}
resource "aws_ecs_task_definition" "healthcare_task" {
  family                   = "healthcare-api"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = "256"
  memory = "512"

  execution_role_arn = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "healthcare-api"
      image = "${aws_ecr_repository.healthcare_api.repository_url}:latest"

      essential = true

      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
          protocol      = "tcp"

        }
      ]
      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.healthcare_logs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}
resource "aws_cloudwatch_log_group" "healthcare_logs" {
  name              = "/ecs/healthcare-api"
  retention_in_days = 30

  tags = {
    Project     = "Healthcare Cloud Platform"
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}
resource "aws_ecs_service" "healthcare_service" {
  name            = "healthcare-api-service"
  cluster         = aws_ecs_cluster.healthcare_cluster.id
  task_definition = aws_ecs_task_definition.healthcare_task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.ecs_security_group_id]
    assign_public_ip = false
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  tags = {
    Project     = "Healthcare Cloud Platform"
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}