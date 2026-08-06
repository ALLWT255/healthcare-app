resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "healthcare-db-credentials"
  description = "Database credentials for the Healthcare application"

  tags = {
    Name = "Healthcare DB Secret"
  }
}
resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id = aws_secretsmanager_secret.db_credentials.id

  secret_string = jsonencode({
    username = "postgres"
    password = "ChangeThisLater"
  })
}