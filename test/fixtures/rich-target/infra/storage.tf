resource "aws_s3_bucket" "measurements" {
  bucket = "rich-target-measurements"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "measurements" {
  bucket = aws_s3_bucket.measurements.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}
