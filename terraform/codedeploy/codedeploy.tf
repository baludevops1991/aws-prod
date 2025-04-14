/*resource "aws_codedeploy_app" "terraform_app" {
  name              = "MyCodeDeployApp"
  compute_platform  = "Server"
}

resource "aws_codedeploy_deployment_group" "terraform_deploy_group" {
  app_name              = aws_codedeploy_app.terraform_app.name
  deployment_group_name = "MyDeploymentGroup"
  service_role_arn      = var.codedeploy_role_arn

  deployment_style {
    deployment_type   = "IN_PLACE"
    deployment_option = "WITHOUT_TRAFFIC_CONTROL"
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Environment"
      type  = "KEY_AND_VALUE"
      value = "prod"
    }
  }
}
*/