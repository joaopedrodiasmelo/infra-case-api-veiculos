module "vpc" {
  source = "../vpc"
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-security-group"
  description = "Permite trafego HTTP na porta 80"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permite tráfego de qualquer lugar
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Permite todo o tráfego de saída
  }

  tags = {
    Name = "alb-security-group"
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2-security-group"
  description = "Permite trafego HTTP na porta 80 apenas do ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]  # Permite tráfego apenas do ALB
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Permite todo o trafego de saida
  }

  tags = {
    Name = "ec2-security-group"
  }
}

resource "aws_instance" "ec2_private" {
  ami           = "ami-05b10e08d247fb927"  # Amazon Linux 2
  instance_type = "t2.micro"
  user_data     = file("${path.module}/user_data.sh")
  subnet_id     = module.vpc.private_subnet_id
  security_groups = [aws_security_group.ec2_sg.id]  # Associa o Security Group da EC2

  tags = {
    Name = "ec2-private-case-veiculos"
  }
}

resource "aws_lb_target_group" "tg" {
  name     = "tg-case-veiculos"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path                = "/api-in-dados-veiculos.icarros.com.br/v1/placa/health"
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }

  tags = {
    Name = "tg-case-veiculos"
  }
}

resource "aws_lb_target_group_attachment" "tg_attachment" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.ec2_private.id
  port             = 80
}

resource "aws_lb" "alb" {
  name               = "alb-case-veiculos"
  internal           = false  # ALB público
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [module.vpc.public_subnet_id,module.vpc.public_subnet_id2]

  tags = {
    Name = "alb-case-veiculos"
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}