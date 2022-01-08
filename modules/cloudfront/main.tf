resource "aws_cloudfront_distribution" "default" {
  enabled = true
  aliases = var.aliases

  viewer_certificate {
    acm_certificate_arn            = var.certificate_arn
    cloudfront_default_certificate = false
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2018"
  }

  default_root_object = "index.html"
  is_ipv6_enabled     = true
  wait_for_deployment = true


  origin {
    domain_name = var.domain_name
    origin_id   = var.origin_id

    s3_origin_config {
      origin_access_identity = var.origin_access_identity
    }
  }

  default_cache_behavior {
    target_origin_id       = var.origin_id
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]


    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    max_ttl     = 0
    default_ttl = 0
    compress    = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  custom_error_response {
    error_code            = 404
    error_caching_min_ttl = 300
    response_page_path    = "/index.html"
    response_code         = 200
  }

  tags = merge(var.tags, {
    Resource = "CloudfrontDistribution"
  })
}