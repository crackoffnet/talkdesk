###############################
# VPC
###############################
module "networking" {
  source             = "./modules/networking"
  env                = var.env
  region             = var.region[var.env]
  cidr_block         = "10.0.0.0/16"
  private_subnets    = local.private_subnets
  public_subnets     = local.public_subnets
  availability_zones = local.availability_zones

  tags = {
    Project                                       = "Talkdesk on AWS"
    Environment                                   = var.env
    Module                                        = "VPC"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}


###############################
# EKS Kubernetes service
###############################
module "eks" {
  cluster_name       = local.cluster_name
  source             = "./modules/eks"
  region             = var.region[var.env]
  env                = var.env
  availability_zones = local.availability_zones
  vpc_id             = module.networking.aws_vpc_id
  private_subnet_id  = module.networking.private_subnet_id

  depends_on = [module.networking]

  tags = {
    Project     = "Talkdesk on AWS"
    Environment = var.env
    Module      = "EKS"
  }
}