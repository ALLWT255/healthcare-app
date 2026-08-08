resource "aws_route53_zone" "healthcare_zone" {
  name = "healthcareapp.com"
}
resource "aws_route53_record" "healthcare_alias" {
  zone_id = aws_route53_zone.healthcare_zone.zone_id

  name = "healthcareapp.com"
  type = "A"

  alias {
    name                   = aws_lb.healthcare_alb.dns_name
    zone_id                = aws_lb.healthcare_alb.zone_id
    evaluate_target_health = true
  }
}