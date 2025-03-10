# Criação de um Elastic IP para o NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = format("%s-eip",var.cluster_name)
  }
}

# Criação do NAT Gateway na sub-rede pública
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id  # Associa o Elastic IP ao NAT Gateway
  subnet_id     = aws_subnet.subnet_publica.id

  tags = {
    Name = format("%s-nat-gateway",var.cluster_name)
  }
}

# Tabela de rotas para a sub-rede privada, com rota padrão para o NAT Gateway
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc_case_veiculos.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = format("%s-private-route",var.cluster_name)
  }
}