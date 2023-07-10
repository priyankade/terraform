data "aws_ami" "ubuntu" {
    most_recent = true
 
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
 
    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
 
    filter {
        name   = "architecture"
        values = ["x86_64"]
    }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
}


resource "aws_launch_template" "launch_template" {
  name_prefix   = "${var.project_name}-launch-template"
  #vpc_security_group_ids = var.vpc_security_group_ids
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  user_data     = var.user_data
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  #availability_zones = [for az in var.availability_zones: az]
  vpc_zone_identifier = [var.private_app_subnet_az1_id, var.private_app_subnet_az2_id]
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1
  target_group_arns  = [var.alb_target_group_arn]

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }
}