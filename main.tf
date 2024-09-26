terraform {
  backend "s3" {
    bucket         = "my-bucket-task-rs"
    key            = "terraform.tfstate"         
    region         = "eu-north-1"                                      
  }
