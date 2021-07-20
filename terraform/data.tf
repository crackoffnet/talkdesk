data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  private_subnets    = ["10.0.128.0/19", "10.0.160.0/19"]
  public_subnets     = ["10.0.4.0/24", "10.0.5.0/24"]
  availability_zones = data.aws_availability_zones.available.names
  az_subnet_numbers  = zipmap(var.availability_zones, range(0, length(var.availability_zones)))
  cluster_tags       = { for cluster_name in var.cluster_names : "kubernetes.io/cluster/${cluster_name}" => "shared" }
  cluster_name       = "eks-${var.env}"
}