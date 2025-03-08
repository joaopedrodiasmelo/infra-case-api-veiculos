

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_case_veiculos.id

  tags = {
    Name = format("%s-internet-gateway", var.cluster_name)
  }
}

resource "aws_route_table" "public_internet_access" {
  vpc_id = aws_vpc.vpc_case_veiculos.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = format("%s-public-route", var.cluster_name)
  }
}

