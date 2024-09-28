terraform {
  backend "s3" {
    bucket         = "my-bucket-task-rs"
    key            = "terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
