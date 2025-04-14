resource "aws_iam_policy" "passrole_policy" {
  name        = "AllowPassRoleForCodeServices"
  description = "Allows passing roles to CodePipeline, CodeBuild, and CodeDeploy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "iam:PassRole",
        Resource = [
          aws_iam_role.codepipeline_role.arn,
          aws_iam_role.codebuild_role.arn,
          aws_iam_role.codedeploy_role.arn
        ]
      }
    ]
  })
}