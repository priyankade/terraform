# create application load balancer
# internet facing alb
resource "aws_lb" "alb" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    =  [var.alb_security_group_id]
  subnets            = [var.public_subnet_az1_id, var.public_subnet_az2_id]

  enable_deletion_protection = false

  # access_logs {
  #   bucket  = aws_s3_bucket.lb_logs.id
  #   prefix  = "test-lb"
  #   enabled = true
  # }

  tags = {
    Environment = "production"
  }
}

# create target group
resource "aws_lb_target_group" "alb_target_group" {
  name        = "${var.project_name}-tg"
  # target_type = "ip"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    interval            = 300
    path                = "/"
    timeout             = 60
    matcher             = 200
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

  lifecycle {
    create_before_destroy = true
  }
}

# # create target group
# resource "aws_lb_target_group" "prometheus_target_group" {
#   name        = "${var.project_name}-tg"
#   # target_type = "ip"
#   port        = 80
#   protocol    = "HTTP"
#   vpc_id      = var.vpc_id

#   health_check {
#     enabled             = true
#     interval            = 300
#     path                = "/"
#     timeout             = 60
#     matcher             = 200
#     healthy_threshold   = 5
#     unhealthy_threshold = 5
#   }
# }

resource "aws_lb_target_group_attachment" "target_group_attachement" {
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = var.prometheus_ec2_id
  port             = 80
}

# create a listener on port 80 with redirect action
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }

  # default_action {
  #   type = "redirect"

  #   redirect {
  #     port        = 443
  #     protocol    = "HTTPS"
  #     status_code = "HTTP_301"
  #   }
  # }
}

# # create a listener on port 443 with forward action
# resource "aws_lb_listener" "alb_https_listener" {
#   load_balancer_arn  = aws_lb.alb.arn
#   port               = "443"
#   protocol           = "HTTPS"
#   ssl_policy         = "ELBSecurityPolicy-2016-08"
#   certificate_arn    = var.certificate_arn

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.alb_target_group.arn
#   }
# }