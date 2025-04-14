resource "aws_iam_role" "codebuild_role" {
  name = "CodeBuildRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "codebuild.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "codebuild_policy" {
  role = aws_iam_role.codebuild_role.name
  name = "CodeBuildPolicy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "s3:*",
          "logs:*",
          "codepipeline:List*",
          "codepipeline:Describe*",
          "codecommit:List*",
          "codecommit:Describe*",
          "iam:GetRole",
          "sns:*"
        ]
        Resource = "*"
      }
    ]
  })
}
