variable "codebuild_role_arn" {}
variable "codepipeline_role_arn" {}
variable "codedeploy_role_arn" {} # Optional

variable "github_owner" {}
variable "github_repo" {}
variable "github_branch" {}
variable "github_oauth_token" {} # Not committed, use terraform.tfvars or env var
variable "artifact_bucket_name" {}  # This should be an existing S3 bucket
