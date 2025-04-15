variable "codepipeline_role_arn" {}
variable "codebuild_role_arn" {}
variable "codedeploy_role_arn" {}
variable "artifact_bucket" {}
variable "github_owner" {}
variable "github_repo" {}
variable "github_branch" {}
variable "github_token" {}
variable "codebuild_project_name" {}
variable "codedeploy_app_name" {}
variable "codedeploy_deployment_group" {}
variable "tags" {
  type = map(string)
}
