resource "aws_subnet" "subnet_privada" {
  vpc_id            = aws_vpc.vpc_case_veiculos.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = format("%sa",var.aws_region)

  tags = {
    Name = format("%s-private-1a",var.cluster_name)
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "subnet_privada2" {
  vpc_id            = aws_vpc.vpc_case_veiculos.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = format("%sb",var.aws_region)

  tags = {
    Name = format("%s-private-2a",var.cluster_name)
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_route_table_association" "private_subnet_asso" {
  subnet_id      = aws_subnet.subnet_privada.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet2_asso" {
  subnet_id      = aws_subnet.subnet_privada2.id
  route_table_id = aws_route_table.private_route_table.id
}