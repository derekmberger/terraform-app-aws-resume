###############################
# AWS ACM Certificate Request #
###############################
resource "aws_acm_certificate" "cert" {
  domain_name       = "${var.service_name}.${data.aws_route53_zone.hosted_zone.name}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

##########################
# DNS Validation Records #
##########################
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id         = data.aws_route53_zone.hosted_zone.zone_id
  name            = each.value.name
  type            = each.value.type
  ttl             = 60
  records         = [each.value.record]
  allow_overwrite = true
}

################################
# Validate the ACM Certificate #
################################
resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for r in aws_route53_record.cert_validation : r.fqdn]
}

###############
# DNS Records #
###############
resource "aws_route53_record" "alias" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = "${var.service_name}.${data.aws_route53_zone.hosted_zone.name}"
  type    = "A"
  alias {
    name                   = aws_alb.alb.dns_name
    zone_id                = aws_alb.alb.zone_id
    evaluate_target_health = false
  }
}
