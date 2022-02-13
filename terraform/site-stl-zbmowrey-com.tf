# This app is NOT multi-region, and everything is hosted in us-east-1.

#locals {
#  stl_base_domain = join(".", ["stl", local.app_domain])
#  stl_app_name = "stl-zbmowrey-com"
#  stl_web_bucket  = "${local.stl_app_name}-${terraform.workspace}-web-primary"
#  stl_origin_id   = "${terraform.workspace}-stl-origin"
#}
#
#resource "aws_s3_bucket" "stl" {
#  provider = aws.secondary
#  bucket   = local.stl_web_bucket
#  acl      = "public-read"
#  tags = {
#    CostCenter = local.stl_app_name
#  }
#  policy   = jsonencode({
#    Version   = "2012-10-17"
#    Statement = [
#      {
#        Sid       = "PublicRead"
#        Effect    = "Allow"
#        Principal = "*"
#        Action    = ["s3:GetObject", "s3:GetObjectVersion"]
#        Resource  = ["arn:aws:s3:::${local.stl_web_bucket}/*"]
#      }
#    ]
#  })
#}
#
#resource "aws_route53_record" "stl" {
#  provider = aws.secondary
#  name     = local.stl_base_domain
#  type     = "A"
#  zone_id  = aws_route53_zone.public.zone_id
#  alias {
#    evaluate_target_health = false
#    name                   = aws_cloudfront_distribution.stl.domain_name
#    zone_id                = aws_cloudfront_distribution.stl.hosted_zone_id
#  }
#}
#
#resource "aws_acm_certificate" "stl" {
#  provider                  = aws.secondary
#  domain_name               = local.stl_base_domain
#  subject_alternative_names = []
#  validation_method         = "DNS"
#  lifecycle {
#    create_before_destroy = true
#  }
#  tags                      = {
#    Name = "5e-tools Managed by Terraform"
#    CostCenter = local.stl_app_name
#  }
#}
#
#resource "aws_cloudfront_origin_access_identity" "stl" {
#  provider = aws.secondary
#  comment  = "Managed by ${local.stl_app_name}-${terraform.workspace} terraform"
#}
#
#resource "aws_cloudfront_distribution" "stl" {
#  depends_on          = [aws_acm_certificate.stl]
#  provider            = aws.secondary
#  price_class         = "PriceClass_100"
#  enabled             = true
#  default_root_object = "index.html"
#
#  aliases = [local.stl_base_domain]
#
#  custom_error_response {
#    error_code            = 404
#    response_code         = 200
#    response_page_path    = "/index.html"
#    error_caching_min_ttl = 30
#  }
#  custom_error_response {
#    error_code            = 403
#    response_code         = 200
#    response_page_path    = "/index.html"
#    error_caching_min_ttl = 30
#  }
#
#  default_cache_behavior {
#    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
#    cached_methods         = ["HEAD", "GET", "OPTIONS"]
#    target_origin_id       = local.stl_origin_id
#    viewer_protocol_policy = "redirect-to-https"
#    compress = true
#    forwarded_values {
#      query_string = false
#      cookies {
#        forward = "all"
#      }
#    }
#    min_ttl                = 0
#    default_ttl            = 3600
#    max_ttl                = 86400
#  }
#
#  origin {
#    domain_name = aws_s3_bucket.stl.bucket_regional_domain_name
#    origin_id   = local.stl_origin_id
#
#    s3_origin_config {
#      origin_access_identity = aws_cloudfront_origin_access_identity.stl.cloudfront_access_identity_path
#    }
#  }
#
#  restrictions {
#    geo_restriction {
#      restriction_type = "whitelist"
#      locations        = ["US"]
#    }
#  }
#
#  viewer_certificate {
#    cloudfront_default_certificate = false
#    acm_certificate_arn            = aws_acm_certificate.stl.arn
#    ssl_support_method             = "sni-only"
#    minimum_protocol_version       = "TLSv1.2_2019"
#  }
#  tags = {
#    Description = "${local.stl_app_name}-${terraform.workspace}"
#    CostCenter = local.stl_app_name
#  }
#}