resource "aws_subnet" "subnet_publica" {
  vpc_id            = aws_vpc.vpc_case_veiculos.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = format("%sa",var.aws_region)

  tags = {
    Name = format("%s-public-1a",var.cluster_name)
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "subnet_publica2" {
  vpc_id            = aws_vpc.vpc_case_veiculos.id
  cidr_block        = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = format("%sb",var.aws_region)

  tags = {
    Name = format("%s-public-1b",var.cluster_name)
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

# Associação da sub-rede pública1 à tabela de rotas
resource "aws_route_table_association" "public_subnet_asso" {
  subnet_id      = aws_subnet.subnet_publica.id
  route_table_id = aws_route_table.public_internet_access.id
}

# Associação da segunda sub-rede pública 2à tabela de rotas
resource "aws_route_table_association" "public_subnet_asso2" {
  subnet_id      = aws_subnet.subnet_publica2.id
  route_table_id = aws_route_table.public_internet_access.id
}
