  # Criação da VPC
  resource "aws_vpc" "vpc_case_veiculos" {
    cidr_block           = "10.0.0.0/16"
    enable_dns_hostnames = true

    tags = {
      Name = "vpc_case_veiculos"
    }
  }

  # Sub-rede pública na zona de disponibilidade us-east-1a
  resource "aws_subnet" "subnet_publica" {
    vpc_id            = aws_vpc.vpc_case_veiculos.id
    cidr_block        = "10.0.1.0/24"
    availability_zone = "us-east-1a"

    tags = {
      Name = "sub-rede-publica"
    }
  }

  # Sub-rede pública na zona de disponibilidade us-east-1b
  resource "aws_subnet" "subnet_publica2" {
    vpc_id            = aws_vpc.vpc_case_veiculos.id
    cidr_block        = "10.0.2.0/24"
    availability_zone = "us-east-1b"

    tags = {
      Name = "sub-rede-publica2"
    }
  }

  # Sub-rede privada na zona de disponibilidade us-east-1a
  resource "aws_subnet" "subnet_privada" {
    vpc_id            = aws_vpc.vpc_case_veiculos.id
    cidr_block        = "10.0.3.0/24"
    availability_zone = "us-east-1a"

    tags = {
      Name = "sub-rede-privada"
    }
  }

  resource "aws_subnet" "subnet_privada2" {
    vpc_id            = aws_vpc.vpc_case_veiculos.id
    cidr_block        = "10.0.4.0/24"
    availability_zone = "us-east-1b"

    tags = {
      Name = "sub-rede-privada2"
    }
  }

  # Criação do Internet Gateway para permitir acesso à internet
  resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc_case_veiculos.id

    tags = {
      Name = "internet-gateway-api-veiculo"
    }
  }

  # Tabela de rotas para sub-redes públicas, com rota padrão para o Internet Gateway
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

  # Associação da sub-rede pública à tabela de rotas
  resource "aws_route_table_association" "public_subnet_asso" {
    subnet_id      = aws_subnet.subnet_publica.id
    route_table_id = aws_route_table.tabela_rotas.id
  }

  # Associação da segunda sub-rede pública à tabela de rotas
  resource "aws_route_table_association" "public_subnet_asso2" {
    subnet_id      = aws_subnet.subnet_publica2.id
    route_table_id = aws_route_table.tabela_rotas.id
  }

  # Criação de um Elastic IP para o NAT Gateway
  resource "aws_eip" "nat_eip" {
    domain = "vpc"

    tags = {
      Name = "eip-nat-gateway-case-veiculos"
    }
  }

  # Criação do NAT Gateway na sub-rede pública
  resource "aws_nat_gateway" "nat_gateway" {
    allocation_id = aws_eip.nat_eip.id  # Associa o Elastic IP ao NAT Gateway
    subnet_id     = aws_subnet.subnet_publica.id  # NAT Gateway deve estar em uma sub-rede pública

    tags = {
      Name = "nat-gateway-case-veiculos"
    }
  }

  # Tabela de rotas para a sub-rede privada, com rota padrão para o NAT Gateway
  resource "aws_route_table" "private_route_table" {
    vpc_id = aws_vpc.vpc_case_veiculos.id

    route {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat_gateway.id  # Rota padrão para o NAT Gateway
    }

    tags = {
      Name = "private-route-table-case-veiculos"
    }
  }

  # Associação da sub-rede privada à tabela de rotas privada
  resource "aws_route_table_association" "private_subnet_asso" {
    subnet_id      = aws_subnet.subnet_privada.id
    route_table_id = aws_route_table.private_route_table.id
  }