# We're going to create a multi-bucket static site in separate regions
# to provide high availability in case of regional failure.

locals {

  base-domain = var.stage == "main" ? var.base-domain : join(".", [var.stage, var.base-domain])

  web-one = join("-", [var.app, var.stage, "-web-primary"])
  web-two = join("-", [var.app, var.stage, "-web-secondary"])
  web-log = join("-", [var.app, var.stage, "-web-logs"])

  default_tags = {
    CostCenter  = var.app
    Owner       = var.owner
    Environment = var.stage
    Terraform   = true
  }
}

resource "aws_s3_bucket" "web-one" {
  provider = aws.primary
  bucket   = local.web-one
  website {
    index_document = "index.html"
    error_document = "index.html"
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.kms-key-arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  versioning {
    enabled = true
  }
  lifecycle_rule {
    id      = "${var.stage}-web-primary-lifecycle"
    noncurrent_version_expiration {
      days = 7
    }
    enabled = true
  }
  policy   = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Sid       = "OAIRead"
        Effect    = "Allow"
        Principal = [aws_cloudfront_origin_access_identity.web.iam_arn]
        Action    = ["s3:GetObject", "s3:GetObjectVersion"]
        Resource  = ["arn:aws:s3:::${local.web-one}/*"]
      }
    ]
  })
}

# Secondary is us-east-1 (Virginia) - this is our failover origin

resource "aws_s3_bucket" "web-two" {
  provider = aws.secondary
  bucket   = local.web-two
  website {
    index_document = "index.html"
    error_document = "index.html"
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.kms-key-arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  versioning {
    enabled = true
  }
  lifecycle_rule {
    id      = "${var.stage}-web-secondary-lifecycle"
    noncurrent_version_expiration {
      days = 7
    }
    enabled = true
  }
  policy   = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Sid       = "OAIRead"
        Effect    = "Allow"
        Principal = [aws_cloudfront_origin_access_identity.web.iam_arn]
        Action    = ["s3:GetObject", "s3:GetObjectVersion"]
        Resource  = ["arn:aws:s3:::${local.web-two}/*"]
      }
    ]
  })
}

resource "aws_s3_bucket" "web-log" {
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.kms-key-arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  versioning {
    enabled = true
  }

  provider = aws.secondary # logs should be written to us-east-1
  bucket   = local.web-log
  lifecycle_rule {
    id      = "${var.stage}-web-log-lifecycle"
    enabled = true
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    noncurrent_version_expiration {
      days = 7
    }
    expiration {
      days = 60
    }
  }
}

resource "aws_cloudfront_origin_access_identity" "web" {
  provider = aws.primary
  comment  = "Managed by ${var.app}-${var.stage} terraform"
}

resource "aws_cloudfront_distribution" "web" {
  provider            = aws.primary
  price_class         = "PriceClass_100"
  enabled             = true
  default_root_object = "index.html"

  aliases = [local.base-domain, join(".", ["www", local.base-domain])]

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
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
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
    domain_name = aws_s3_bucket.web-one.bucket_regional_domain_name
    origin_id   = "primaryS3"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.web.cloudfront_access_identity_path
    }
  }

  origin {
    domain_name = aws_s3_bucket.web-two.bucket_regional_domain_name
    origin_id   = "failoverS3"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.web.cloudfront_access_identity_path
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.acm-certificate-arn
    ssl_support_method  = "sni-only"
  }

  tags = {
    Description = "${var.app}-${var.stage}"
  }
}
