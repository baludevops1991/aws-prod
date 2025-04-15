variable "region" {
  description = "AWS region"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}

variable "key_name" {
  description = "Key pair name to use for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "bucket_name" {
  description = "The name of the S3 bucket to store Terraform state"
  type        = string
}

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
variable "codestar_connection_arn" {
  description = "ARN of the CodeStar connection to GitHub"
  type        = string
}
