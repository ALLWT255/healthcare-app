resource "aws_acm_certificate" "healthcare_certificate" {
  domain_name       = "healthcareapp.com"
  validation_method = "DNS"

  tags = {
    Name = "Healthcare Certificate"
  }

  lifecycle {
    create_before_destroy = true
  }
}