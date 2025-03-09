resource "aws_secretsmanager_secret" "ec2_ip_secret" {
  name        = "secrets-case-veiculos2"
  description = "Armazena o IP privado da instância EC2 e a Chave da API de veiculos"
}


resource "aws_secretsmanager_secret_version" "ec2_ip_secret_version" {
  secret_id     = aws_secretsmanager_secret.ec2_ip_secret.id
  secret_string = jsonencode({
    private_ip = var.ec2_ip_privado
    apiKey = "chave-api"
    redis_endpoint = var.redis_endpoint
  })
}