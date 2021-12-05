# This app is NOT multi-region, and everything is hosted in us-east-1.

locals {
  base_domain = join(".", ["5e", local.app_domain])
  app_name    = "5e-zbmowrey-com"
  web_bucket  = "${local.app_name}-${var.environment}-web-primary"
  origin_id   = "${var.environment}-5e-origin"
}

resource "aws_s3_bucket" "five-e-tools" {
  provider = aws.secondary
  bucket   = local.web_bucket
  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
  versioning {
    enabled = true
  }
  lifecycle_rule {
    id      = "${var.app_name}-${var.environment}-web-primary-lifecycle"
    noncurrent_version_expiration {
      days = 7
    }
    enabled = true
  }
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Sid       = "OAIRead"
        Effect    = "Allow"
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.five-e-tools.iam_arn
        }
        Action    = ["s3:GetObject", "s3:GetObjectVersion"]
        Resource  = "arn:aws:s3:::${local.web_bucket}/*"
      }
    ]
  })
}

resource "aws_route53_record" "five-e-tools" {
  provider = aws.secondary
  name     = local.base_domain
  type     = "A"
  zone_id  = aws_route53_zone.public.zone_id
  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.five-e-tools.domain_name
    zone_id                = aws_cloudfront_distribution.five-e-tools.hosted_zone_id
  }
}

resource "aws_acm_certificate" "five-e-tools" {
  provider                  = aws.secondary
  domain_name               = local.base_domain
  subject_alternative_names = []
  validation_method         = "DNS"
  lifecycle {
    create_before_destroy = true
  }
  tags                      = {
    Name       = "5e-tools Managed by Terraform"
    CostCenter = local.app_name
  }
}

resource "aws_route53_record" "five-e-tools-acm" {
  for_each = {
  for option in aws_acm_certificate.five-e-tools.domain_validation_options : option.domain_name => {
    name   = option.resource_record_name
    record = option.resource_record_value
    type   = option.resource_record_type
  }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.public.zone_id
}

resource "aws_acm_certificate_validation" "five-e-tools" {
  certificate_arn         = aws_acm_certificate.five-e-tools.arn
  validation_record_fqdns = [for record in aws_route53_record.five-e-tools-acm : record.fqdn]
}

resource "aws_cloudfront_origin_access_identity" "five-e-tools" {
  provider = aws.secondary
  comment  = "Managed by ${local.app_name}-${var.environment} terraform"
}

resource "aws_cloudfront_distribution" "five-e-tools" {
  depends_on          = [aws_acm_certificate.five-e-tools]
  provider            = aws.secondary
  price_class         = "PriceClass_100"
  enabled             = true
  default_root_object = "index.html"

  aliases = [local.base_domain]

  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 30
  }
  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 30
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["HEAD", "GET", "OPTIONS"]
    target_origin_id       = local.origin_id
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    forwarded_values {
      query_string = false
      cookies {
        forward = "all"
      }
    }
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  origin {
    domain_name = aws_s3_bucket.five-e-tools.bucket_regional_domain_name
    origin_id   = local.origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.five-e-tools.cloudfront_access_identity_path
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = aws_acm_certificate.five-e-tools.arn
    ssl_support_method             = "sni-only"
  }
  tags = {
    Description = "${local.app_name}-${var.environment}"
    CostCenter  = local.app_name
  }
}