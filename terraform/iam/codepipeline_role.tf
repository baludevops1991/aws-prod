resource "aws_iam_role" "codepipeline_role" {
  name = "CodePipelineRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "codepipeline.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  role = aws_iam_role.codepipeline_role.name
  name = "CodePipelinePolicy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "codecommit:List*",
          "codecommit:Describe*",
          "s3:*",
          "iam:GetRole",
          "iam:PassRole",   # Grant permission to pass the roles
          "cloudwatch:PutMetricData",
          "sns:*"
        ]
        Resource = "*"
      }
    ]
  })
}
