resource "aws_s3_bucket" "terraform_state" {
  bucket = "aws-prod-terraform-state-bucket"
  acl    = "private"
  
  tags       = var.tags
}

resource "aws_s3_bucket_object" "terraform_state_file" {
  bucket = aws_s3_bucket.terraform_state.bucket
  key    = "terraform/state"
  acl    = "private"

  tags       = var.tags
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"
  
  attribute {
    name = "LockID"
    type = "S"
  }

  tags       = var.tags
}
