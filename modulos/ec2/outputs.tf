output "ec2_ip_privado" {
    value = aws_instance.ec2_api_fake.private_ip
}