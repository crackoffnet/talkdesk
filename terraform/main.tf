###############################
# VPC
###############################
module "networking" {
  source             = "./modules/networking"
}


###############################
# EKS Kubernetes service
###############################
module "eks" {
}