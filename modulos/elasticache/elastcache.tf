# Subnet Group
resource "aws_elasticache_subnet_group" "sub_group" {
  name       = "subnet-group"
  subnet_ids = [var.private_subnet_id, var.private_subnet_id2]
}

# Security Group
resource "aws_security_group" "sg" {
  name        = "security-group"
  description = "grupo de seguranca"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Redis Cluster
resource "aws_elasticache_cluster" "elasticache" {
  cluster_id           = "cluster-elasticache"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  engine_version       = "6.2"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.sub_group.name
  security_group_ids   = [aws_security_group.sg.id]
}

