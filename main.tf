terraform {
  backend "s3" {
    bucket = var.bucket_name
    key    = "terraform.tfstate"
    region = var.region
  }
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name  
  acl    = "private"        
}
