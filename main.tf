module "vpc" {
  source = "./modulos/vpc"

  cluster_name = var.cluster_name
  aws_region =  var.aws_region
}

module "cluster_eks" {
  source = "./modulos/eks/cluster"

  cluster_name = var.cluster_name
  aws_region =  var.aws_region
  k8s_version = var.k8s_version

  vpc_id = module.vpc.vpc_id
  private_subnet_id = module.vpc.private_subnet_id
  private_subnet_id2 = module.vpc.private_subnet_id2
}

module "eks_nodes" {
  source = "./modulos/eks/node"

  cluster_name = var.cluster_name
  aws_region =  var.aws_region
  k8s_version = var.k8s_version

  vpc_id = module.vpc.vpc_id
  private_subnet_id = module.vpc.private_subnet_id
  private_subnet_id2 = module.vpc.private_subnet_id2

  eks_cluster = module.cluster_eks.eks_cluster
  security_group = module.cluster_eks.security_group
}