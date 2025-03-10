# Cluster EKS
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  version  = var.k8s_version
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [var.private_subnet_id, var.private_subnet_id2]
    security_group_ids = [aws_security_group.cluster_sg.id]
  }
}

# Dados do cluster para autenticação
data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.eks_cluster.name
}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.eks_cluster.name
}

# Provedor Kubernetes configurado para o EKS
provider "kubernetes" {
  host                   = aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

