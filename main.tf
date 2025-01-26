resource "aws_s3_bucket" "static_web_s3" {
  bucket = var.s3_name

  tags = {
    Name        = "my-s3-hosted-static-website"
  }
}

resource "aws_s3_bucket_ownership_controls" "s3_ownership" {
  bucket = aws_s3_bucket.static_web_s3.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_public_access" {
  bucket = aws_s3_bucket.static_web_s3.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "s3_public_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.s3_ownership,
    aws_s3_bucket_public_access_block.s3_public_access,
  ]

  bucket = aws_s3_bucket.static_web_s3.id
  acl    = "public-read"
}

resource "aws_s3_object" "s3_index_page" {
  bucket = aws_s3_bucket.static_web_s3.id
  key    = var.s3_obj_index_page_key
  source = var.s3_obj_index_page_path
  acl    = "public-read"
  content_type = "text/html"
  etag = filemd5(var.s3_obj_index_page_path)
}

resource "aws_s3_object" "s3_error_page" {
  bucket = aws_s3_bucket.static_web_s3.id
  key    = var.s3_obj_error_page_key
  source = var.s3_obj_error_page_path
  acl    = "public-read"
  content_type = "text/html"
  etag = filemd5(var.s3_obj_error_page_path)
}

resource "aws_s3_bucket_website_configuration" "s3_website_config" {
  bucket = aws_s3_bucket.static_web_s3.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [ aws_s3_bucket_acl.s3_public_acl ]
}