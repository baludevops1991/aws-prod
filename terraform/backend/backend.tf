
terraform {
  backend "s3" {
    bucket = "aws-prod-terraform-state-bucket"
    key    = "terraform/state"
    region = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt = true
  }
}