resource "aws_security_group" "alb_sg" {
  name        = "healthcare-alb-sg"
  description = "Allow public web traffic to the Application Load Balancer"
  vpc_id      = aws_vpc.healthcare_vpc.id

  ingress {
    description = "Allow HTTP from the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS from the internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Healthcare-ALB-SG"
  }
}
resource "aws_security_group" "ecs_sg" {
  name        = "healthcare-ecs-sg"
  description = "Allow Flask API traffic only from the ALB"
  vpc_id      = aws_vpc.healthcare_vpc.id

  ingress {
    description     = "Allow Flask traffic from the ALB"
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    description = "Allow ECS tasks to reach required services"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Healthcare-ECS-SG"
  }
}
resource "aws_security_group" "rds_sg" {
  name        = "healthcare-rds-sg"
  description = "Allow PostgreSQL traffic only from ECS"
  vpc_id      = aws_vpc.healthcare_vpc.id

  ingress {
    description     = "Allow PostgreSQL from ECS"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Healthcare-RDS-SG"
  }
}