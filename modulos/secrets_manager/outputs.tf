output "secrets_manager_arn" {
  value = aws_secretsmanager_secret.ec2_ip_secret.arn
}