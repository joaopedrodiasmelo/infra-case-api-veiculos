output "vpc_id" {
  description = "ID da VPC criada"
  value       = aws_vpc.vpc_case_veiculos.id
}

output "public_subnet_id" {
  description = "ID da subnet pública"
  value       = aws_subnet.subnet_publica.id
}

output "public_subnet_id2" {
  description = "ID da subnet pública2"
  value       = aws_subnet.subnet_publica2.id
}

output "private_subnet_id" {
  description = "ID da subnet privada"
  value       = aws_subnet.subnet_privada.id
}