
resource "aws_vpc" "vpc_case_veiculos" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "vpc_case_veiculos"
  }
}

resource "aws_subnet" "subnet_publica" {
  vpc_id     = aws_vpc.vpc_case_veiculos.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "sub-rede-publica"
  }
}

resource "aws_subnet" "subnet_publica2" {
  vpc_id     = aws_vpc.vpc_case_veiculos.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "sub-rede-publica2"
  }
}

resource "aws_subnet" "subnet_privada" {
  vpc_id     = aws_vpc.vpc_case_veiculos.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "sub-rede-privada"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_case_veiculos.id

  tags = {
    Name = "internet-gateway-api-veiculo"
  }
}

resource "aws_route_table" "tabela_rotas" {
  vpc_id = aws_vpc.vpc_case_veiculos.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Tabela de Roteamento"
  }
}

resource "aws_route_table_association" "public_subnet_asso" {
  subnet_id      = aws_subnet.subnet_publica.id
  route_table_id = aws_route_table.tabela_rotas.id
}

resource "aws_route_table_association" "public_subnet_asso2" {
  subnet_id      = aws_subnet.subnet_publica2.id
  route_table_id = aws_route_table.tabela_rotas.id
}



