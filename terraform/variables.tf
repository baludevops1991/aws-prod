variable "codebuild_role_arn" {}
variable "codepipeline_role_arn" {}
variable "codedeploy_role_arn" {} # Optional

variable "github_owner" {}
variable "github_repo" {}
variable "github_branch" {}
variable "github_oauth_token" {} # Not committed, use terraform.tfvars or env var
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}
variable "iam_user_name" {
  description = "Name of the IAM user for CI/CD"
  type        = string
}
