output acm_certificate_arn  {
    value = aws_acm_certificate.alb_ssl_primary_cert.arn
    description = "ARN of the cetificate cteate by ACM"
}