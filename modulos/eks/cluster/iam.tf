data "aws_iam_policy_document" "eks_cluster_role" {

  statement {

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

  }

}

resource "aws_iam_role" "eks_cluster_role" {
  name = format("%s-role", var.cluster_name)
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_role.json
}

resource "aws_iam_role_policy_attachment" "eks-cluster-cluster" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "eks-cluster-service" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role" "eks_pod_role" {
  name               = format("%s-pod-role", var.cluster_name)
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_role.json
}

resource "aws_iam_policy" "secrets_manager_policy" {
  name        = "SecretsManagerAccessPolicy"
  description = "Policy to access AWS Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:ListSecrets"
        ]
        Effect   = "Allow"
        Resource = var.secrets_manager_arn
      }
    ]
  })
}

resource "aws_iam_policy" "elasticache_policy" {
  name        = "ElastiCacheAccessPolicy"
  description = "Policy to access Amazon ElastiCache"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [
          "elasticache:DescribeCacheClusters",
          "elasticache:DescribeReplicationGroups",
          "elasticache:DescribeCacheSubnetGroups",
          "elasticache:ListTagsForResource",
          "elasticache:Connect"
        ]
        Effect   = "Allow"
        Resource = var.redis_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "secrets_manager_attach" {
  role       = aws_iam_role.eks_pod_role.name
  policy_arn = aws_iam_policy.secrets_manager_policy.arn
}

resource "aws_iam_role_policy_attachment" "elasticache_attach" {
  role       = aws_iam_role.eks_pod_role.name
  policy_arn = aws_iam_policy.elasticache_policy.arn
}


