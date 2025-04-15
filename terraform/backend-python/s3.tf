resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name

  tags   = var.tags
}

resource "aws_s3_bucket_acl" "terraform_state_acl" {
  bucket = aws_s3_bucket.terraform_state.id
  acl    = "private"
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
