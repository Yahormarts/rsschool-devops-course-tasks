terraform {
  backend "s3" {
    bucket         = "my-bucket-task-rs"
    key            = "terraform.tfstate"         
    region         = "eu-north-1"                                      
  }
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-bucket-task-rs"  # Используйте ваше имя бакета
}
