# Static website S3 bucket
resource "aws_s3_bucket" "website-bucket" {
  bucket = var.website_bucket_name
  acl = "public-read"

  tags = {
    Name = "selenium-with-tor-demo-website-bucket"
  }

  cors_rule {
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["*"]
    allowed_headers = ["*"]
    max_age_seconds = 3200
  }

  website {
    index_document = "index.html"
  }
}

# Add allowed public access block
resource "aws_s3_bucket_public_access_block" "website-bucket-access" {
  bucket = aws_s3_bucket.website-bucket.id

  block_public_acls = false
  ignore_public_acls = false
  block_public_policy = false
  restrict_public_buckets = false
}

# Create a policy document that allows public reads (for static website content)
data "aws_iam_policy_document" "website-bucket-policy" {
  statement {
    sid = "PublicReadForGetBucketObjects"
    effect = "Allow"
    principals {
      identifiers = ["*"]
      type = "*"
    }
    actions = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.website_bucket_name}/*"]
  }
}

# Attach the above policy to the static website bucket
resource "aws_s3_bucket_policy" "website-bucket-policy" {
  bucket = aws_s3_bucket.website-bucket.id
  policy = data.aws_iam_policy_document.website-bucket-policy.json
  depends_on = [aws_s3_bucket_public_access_block.website-bucket-access]  # Add a static depends_on block because of a persistent "conflicting conditional expression" error
}

# Upload the index.html file
resource "aws_s3_bucket_object" "index-file-upload" {
  bucket = aws_s3_bucket.website-bucket.id
  key = "index.html"
  source = "./index.html"
  etag = filebase64sha256("./index.html")

  content_type = "text/html"
}

output "website-endpoint" {
  value = "http://${aws_s3_bucket.website-bucket.website_endpoint}/"
}