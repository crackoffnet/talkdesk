provider "aws" {
  access_key = "AKIATHDYWRLV74BWEX67"
  secret_key = "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"
  region     = var.region[var.env]
}

provider "kubernetes" {
  host                   = module.eks.aws_eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = module.eks.auth_token
  load_config_file       = false
}