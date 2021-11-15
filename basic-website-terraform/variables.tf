variable "website_bucket_name" {
  description = "The name of the S3 bucket in s3-bucket.tf, which will become part of your website name"
}

variable "aws_region" {
  default = "us-east-2"
  description = "The AWS region to use"
}