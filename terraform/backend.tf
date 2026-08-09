terraform {
  backend "s3" {
    bucket         = "capstone-bucket"
    key            = "capstone/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "capstone-lock"
    encrypt        = true
  }
}
