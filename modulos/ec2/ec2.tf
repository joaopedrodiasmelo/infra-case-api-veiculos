
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-security-group"
  description = "Permite trafego HTTP na porta 80 apenas do ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-security-group"
  }
}

resource "aws_instance" "ec2_api_fake" {
  ami           = "ami-05b10e08d247fb927"  # Amazon Linux 2
  instance_type = "t2.micro"
  user_data     = file("${path.module}/user_data.sh")
  subnet_id     = var.private_subnet_id
  security_groups = [aws_security_group.ec2_sg.id]  # Associa o Security Group da EC2

  tags = {
    Name = "ec2-private-case-veiculos"
  }
}
