output "image_id" {
    value = "${data.aws_ami.ubuntu.id}"
}

output "prometheus_ec2_id" {
    value = aws_instance.prometheus-stack.id
}