module "vpc" {
  source = "./modulos/vpc"
}

module "ec2" {
  source = "./modulos/ec2"
}
