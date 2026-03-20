resource "random_string" "bucket-name-prefix" {
  length  = 8
  upper   = false
  lower   = true
  numeric = false
  special = false
}

resource "aws_s3_bucket" "static_web_bucket" {
  bucket = "${var.s3_bucket_name}-${random_string.bucket-name-prefix.id}"

  force_destroy = true
  tags          = { Name = "web-hosting-bucket" }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.static_web_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.static_web_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_read_policy" {
  bucket = aws_s3_bucket.static_web_bucket.id

  depends_on = [aws_s3_bucket_public_access_block.public_access]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.static_web_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_website_configuration" "web-hosting" {
  bucket = aws_s3_bucket.static_web_bucket.id
  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.static_web_bucket.id
  key          = "index.html"
  source       = "static-web/index.html"
  etag         = filemd5("static-web/index.html")
  content_type = "text/html"
}
