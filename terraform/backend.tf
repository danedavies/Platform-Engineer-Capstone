terraform {
  backend "s3" {
    bucket       = "platform-capstone-bucket"
    key          = "capstone/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}