resource "aws_s3_bucket" "default" {
  bucket        = var.full_name
  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = merge(var.tags, {
    Resource = "S3Bucket"
  })
}

resource "aws_s3_bucket_policy" "OAI_policy" {
  bucket = aws_s3_bucket.default.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.default.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    sid       = "CloudfrontOriginAccessIdentity"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.default.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.OAI.iam_arn]
    }
  }
  statement {
    sid     = "AllowSSLRequestsOnly"
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.default.arn,
      "${aws_s3_bucket.default.arn}/*"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}
resource "aws_cloudfront_origin_access_identity" "OAI" {
  comment = var.full_name
}
