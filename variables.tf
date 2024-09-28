variable "region" {
  description = "The AWS region to deploy resources"
  default     = "eu-north-1"
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "my-bucket-task-rs"
}
