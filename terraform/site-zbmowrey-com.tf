# We're going to create a multi-bucket static site in separate regions
# to provide high availability in case of regional failure.

locals {
  web_bucket     = "give-it-a-name-here"
  app_domain     = "give-us-a-domain-here"
  default_tags    = {
    CostCenter  = var.app_name
    Owner       = var.owner_name
    Environment = terraform.workspace
    Terraform   = true
  }
}

resource "aws_kms_key" "web" {
  description             = "Used to encrypt s3 objects"
  enable_key_rotation     = true
  multi_region            = true
  deletion_window_in_days = 7
}

resource "aws_s3_bucket" "web" {
  bucket = local.web_bucket
}

resource "aws_s3_bucket_website_configuration" "web" {
  bucket         = aws_s3_bucket.web.id
  index_document = "index.html"
  error_document = "index.html"
}

resource "aws_s3_bucket_versioning" "web" {
  bucket  = aws_s3_bucket.web.id
  enabled = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "web" {
  bucket = aws_s3_bucket.web.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "web" {
  bucket = aws_s3_bucket.web.id
  rule {
    id     = "web-lifecycle"
    status = "Enabled"
    noncurrent_version_expiration {
      days = 7
    }
  }

}

resource "aws_s3_bucket_policy" "web" {
  bucket = aws_s3_bucket.web.id
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Sid       = "OAIRead"
        Effect    = "Allow"
        Principal = aws_cloudfront_origin_access_identity.web-oai.iam_arn
        Action    = ["s3:GetObject", "s3:GetObjectVersion"]
        Resource  = ["arn:aws:s3:::${local.web_bucket}/*"]
      }
    ]
  })
}


resource "aws_cloudfront_origin_access_identity" "web-oai" {
  provider = aws.us-east-1
  comment  = "Managed by ${var.app_name}-${terraform.workspace} terraform"
}

resource "aws_cloudfront_distribution" "web-dist" {
  provider            = aws.us-east-1
  depends_on          = [aws_acm_certificate.web-cert]
  price_class         = "PriceClass_100"
  enabled             = true
  default_root_object = "index.html"

  aliases = [local.app_domain, join(".", ["www", local.app_domain])]

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
  }

  origin {
    domain_name = aws_s3_bucket.web.bucket_regional_domain_name
    origin_id   = "primaryS3"

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
    cloudfront_default_certificate = false
    acm_certificate_arn            = aws_acm_certificate.web-cert.arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2019"
  }

}

resource "aws_acm_certificate" "web-cert" {
  provider                  = aws.us-east-1
  domain_name               = local.app_domain
  subject_alternative_names = [join(".", ["*", local.app_domain])]
  validation_method         = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}