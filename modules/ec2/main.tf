data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
}

resource "aws_instance" "prometheus-stack" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  subnet_id     = var.public_subnet_az1_id
  vpc_security_group_ids = [var.ec2_security_group_id]
  key_name      = "eks"
  user_data     = var.user_data

  tags = {
    Name = "prometheus-stack"
  }
}

