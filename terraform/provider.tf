provider "aws" {
  access_key = "AKIATHDYWRLVYDXVQJ7P"
  secret_key = "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"
  region     = var.region[var.env]
}

provider "kubernetes" {
  host                   = module.eks.aws_eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = module.eks.auth_token
  load_config_file       = false
}