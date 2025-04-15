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

resource "aws_s3_bucket" "artifact_bucket" {
  bucket = "aws-prod-artifact-bucket"  # Replace with a globally unique name

  tags = var.tags
}

# Separate resource for versioning
resource "aws_s3_bucket_versioning" "artifact_bucket_versioning" {
  bucket = aws_s3_bucket.artifact_bucket.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

# Encryption settings
resource "aws_s3_bucket_server_side_encryption_configuration" "artifact_bucket_encryption" {
  bucket = aws_s3_bucket.artifact_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ACL resource
resource "aws_s3_bucket_acl" "artifact_bucket_acl" {
  bucket = aws_s3_bucket.artifact_bucket.bucket
  acl    = "private"
}


resource "aws_s3_bucket_public_access_block" "artifact_block" {
  bucket = aws_s3_bucket.artifact_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
