output "aws_autoscaling_group_arn" {
  value = aws_autoscaling_group.asg.arn
}

output "image_id" {
  value = data.aws_ami.ubuntu.id
}