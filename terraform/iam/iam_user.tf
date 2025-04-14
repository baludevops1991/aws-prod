resource "aws_iam_user" "ci_user" {
  name = var.iam_user_name
  path = "/"
  tags       = var.tags
}

resource "aws_iam_user_policy_attachment" "codepipeline_access" {
  user       = aws_iam_user.ci_user.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipelineFullAccess"
}

resource "aws_iam_user_policy_attachment" "codebuild_access" {
  user       = aws_iam_user.ci_user.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess"
}

resource "aws_iam_user_policy_attachment" "codedeploy_access" {
  user       = aws_iam_user.ci_user.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRole"
}

resource "aws_iam_user_policy_attachment" "iam_access" {
  user       = aws_iam_user.ci_user.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}
