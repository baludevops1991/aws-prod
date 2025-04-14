provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "prod" {
  cidr_block = var.vpc_cidr
  tags       = var.tags
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.prod.id
  tags   = var.tags
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.prod.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags                    = var.tags
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.prod.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  tags              = var.tags
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.prod.id
  tags   = var.tags
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  domain = "vpc"
  tags   = var.tags
}


resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  tags          = var.tags
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.prod.id
  tags   = var.tags
}

resource "aws_route" "private_nat_access" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_security_group" "private_ec2" {
  name        = "private-ec2-sg"
  vpc_id      = aws_vpc.prod.id
  description = "Allow HTTP from ALB"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_launch_template" "ec2_template" {
  name_prefix   = "private-ec2-template"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name

  user_data = base64encode(<<-EOF
              #!/bin/bash
              apt update -y
              apt install -y nginx
  echo "<b>Hello from Auto Scaling Group instance - \$(hostname)</b>" > /var/www/html/index.html

cat <<EOT >> /var/www/html/index.html
<br>
<p style="color:blue;"><b>This instance is part of a scalable architecture.</b></p>
<p style="color:darkorange;"><b>Launched automatically using Launch Template.</b></p>
<p style="color:purple;"><b>Managed by Auto Scaling Group for high availability.</b></p>
EOT
EOF
  )

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.private_ec2.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "private_asg" {
  desired_capacity          = 2
  max_size                  = 3
  min_size                  = 2
  vpc_zone_identifier       = aws_subnet.private[*].id
  health_check_type         = "EC2"
  wait_for_capacity_timeout = "0"

  launch_template {
    id      = aws_launch_template.ec2_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "private-ec2"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  depends_on = [aws_launch_template.ec2_template]
}


resource "aws_security_group" "alb_sg" {
  name   = "alb-sg"
  vpc_id = aws_vpc.prod.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_lb" "app_lb" {
  name               = "app-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public[*].id
  security_groups    = [aws_security_group.alb_sg.id]
  tags               = var.tags
}

resource "aws_lb_target_group" "tg" {
  name        = "app-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.prod.id
  target_type = "instance"
  tags        = var.tags
}

resource "aws_autoscaling_attachment" "asg_alb" {
  autoscaling_group_name = aws_autoscaling_group.private_asg.name
  lb_target_group_arn    = aws_lb_target_group.tg.arn
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
