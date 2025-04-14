output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.prod.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.nat.id
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.private_asg.name
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.app_lb.dns_name
}


output "codebuild_project_name" {
  value = aws_codebuild_project.terraform_build.name
}

/*output "codedeploy_app_name" {
  value = aws_codedeploy_app.terraform_app.name
}*/

/*output "codedeploy_deployment_group_name" {
  value = aws_codedeploy_deployment_group.terraform_deploy_group.deployment_group_name
}*/
