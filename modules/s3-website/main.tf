resource "aws_s3_bucket" "default" {
  bucket        = var.full_name
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  tags = merge(local.tags, {
    Resource = "S3Bucket"
  })
}

data "template_file" "bucket_policy" {
  template = file("${path.module}/policies/bucket_policy.json.tpl")
  vars = {
    full_name = var.full_name
  }
}

resource "aws_s3_bucket_policy" "default" {
  bucket = aws_s3_bucket.default.id
  policy = data.template_file.bucket_policy.rendered
}
