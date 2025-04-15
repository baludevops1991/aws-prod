resource "aws_s3_bucket" "artifact_bucket" {
  bucket = "aws-prod-artifact-bucket"  # Choose a unique name for the S3 bucket
  acl    = "private"

  # Enable versioning for the bucket (optional but recommended)
  versioning {
    enabled = true
  }

  tags       = var.tags
}



# CodePipeline
resource "aws_codepipeline" "infra_pipeline" {
  name     = "infra-pipeline"
  role_arn = var.codepipeline_role_arn

  artifact_store {
    location = aws_s3_bucket.artifact_bucket.bucket  # Reference the bucket created above
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "SourceAction"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner      = var.github_owner
        Repo       = var.github_repo
        Branch     = var.github_branch
        OAuthToken = var.github_oauth_token
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "BuildAction"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.infra_build.name
      }
    }
  }

  # Optional Deploy stage if needed
}
