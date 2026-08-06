resource "aws_db_subnet_group" "healthcare_db_subnet_group" {
  name = "healthcare-db-subnet-group"

  subnet_ids = [
    aws_subnet.private_subnet_a.id,
    aws_subnet.private_subnet_b.id
  ]

  tags = {
    Name = "Healthcare Database Subnet Group"
  }
}
resource "aws_db_instance" "healthcare_db" {
  identifier = "healthcare-db"

  engine         = "postgres"
  engine_version = "15.7"

  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = "healthcare"
  username = "postgres"
  password = "ChangeThisLater"

  db_subnet_group_name = aws_db_subnet_group.healthcare_db_subnet_group.name

  vpc_security_group_ids = [
    aws_security_group.rds_sg.id
  ]
  publicly_accessible = false

  skip_final_snapshot = true

  tags = {
    Name = "Healthcare-RDS"
  }
}
