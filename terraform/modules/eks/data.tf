data "template_file" "kubeconfig" {
  template = file("${path.module}/kubeconfig.tpl")

  vars = {
    kubeconfig_name           = var.cluster_name
    endpoint                  = aws_eks_cluster.eks.endpoint
    cluster_auth_base64       = aws_eks_cluster.eks.certificate_authority[0].data
    token                     = data.aws_eks_cluster_auth.eks.token
  }
}