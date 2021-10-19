locals {
  web_primary_bucket   = join("-", [var.app_name, terraform.workspace, var.web_primary_bucket])
  web_secondary_bucket = join("-", [var.app_name, terraform.workspace, var.web_secondary_bucket])
  web_log_bucket       = join("-", [var.app_name, terraform.workspace, var.web_log_bucket])
  app_domain           = terraform.workspace == "main" ? var.root_domain : join(".", [terraform.workspace, var.root_domain])
  api_domain           = "api.${local.app_domain}"
  acm_validations      = []
  default_tags         = {
      CostCenter  = var.app_name
      Owner       = var.owner_name
      Environment = terraform.workspace
      Terraform   = true
  }
}
resource "aws_s3_bucket" "web-primary" {
  provider = aws.primary
  bucket   = local.web_primary_bucket
  acl      = "public-read"
  website {
    index_document = "index.html"
    error_document = "404.html"
  }
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid = "PublicRead"
      Effect = "Allow"
      Principal = "*"
      Action = ["s3:GetObject", "s3:GetObjectVersion"]
      Resource = ["arn:aws:s3:::${local.web_primary_bucket}/*"]
    }]
  })
}

# Secondary is us-east-1 (Virginia) - this is our failover origin

resource "aws_s3_bucket" "web-secondary" {
  provider = aws.secondary
  bucket   = local.web_secondary_bucket
  acl      = "public-read"
  website {
    index_document = "index.html"
    error_document = "404.html"
  }
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid = "PublicRead"
      Effect = "Allow"
      Principal = "*"
      Action = ["s3:GetObject", "s3:GetObjectVersion"]
      Resource = ["arn:aws:s3:::${local.web_secondary_bucket}/*"]
    }]
  })
}

resource "aws_s3_bucket" "web-logs" {
  provider = aws.secondary # logs should be written to us-east-1
  bucket   = local.web_log_bucket
}

resource "aws_cloudfront_origin_access_identity" "web-oai" {
  provider = aws.primary
  comment  = "Managed by ${var.app_name}-${var.environment} terraform"
}

resource "aws_cloudfront_distribution" "web-dist" {
  depends_on          = [aws_acm_certificate.web-cert]
  provider            = aws.primary
  price_class         = "PriceClass_100"
  enabled             = true
  default_root_object = "index.html"

  aliases = [local.app_domain, join(".", ["www", local.app_domain])]

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["HEAD", "GET", "OPTIONS"]
    target_origin_id       = "groupS3"
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      query_string = false
      cookies {
        forward = "all"
      }
    }
    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }
  origin_group {
    origin_id = "groupS3"
    failover_criteria {
      status_codes = [500, 502]
    }
    member {
      origin_id = "primaryS3"
    }
    member {
      origin_id = "failoverS3"
    }
  }
  origin {
    domain_name = aws_s3_bucket.web-primary.bucket_regional_domain_name
    origin_id   = "primaryS3"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.web-oai.cloudfront_access_identity_path
    }
  }

  origin {
    domain_name = aws_s3_bucket.web-secondary.bucket_regional_domain_name
    origin_id   = "failoverS3"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.web-oai.cloudfront_access_identity_path
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    acm_certificate_arn            = aws_acm_certificate.web-cert.arn
    ssl_support_method             = "sni-only"
  }
  tags = {
    Description = "${var.app_name}-${terraform.workspace}"
  }
}

resource "aws_acm_certificate" "web-cert" {
  provider                  = aws.secondary
  domain_name               = local.app_domain
  subject_alternative_names = [join(".", ["*", local.app_domain])]
  validation_method         = "DNS"
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "${var.app_name} - ${terraform.workspace}"
  }
}

