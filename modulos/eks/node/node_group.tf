resource "aws_eks_node_group" "node_group" {

  cluster_name = var.eks_cluster.name
  node_group_name = format("%s-node-group", var.cluster_name)
  node_role_arn = aws_iam_role.eks_nodes_roles.arn

  subnet_ids = [
    var.private_subnet_id,
    var.private_subnet_id2
  ]

  instance_types = ["t3.large"]

  scaling_config {
    desired_size    = 2
    max_size        = 4
    min_size        = 1
  }

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }

}