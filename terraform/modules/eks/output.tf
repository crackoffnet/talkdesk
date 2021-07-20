output "aws_eks_cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "aws_eks_cluster_ca_cert" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}

output "cluster_id" {
  description = "The name/id of the EKS cluster."
  value       = aws_eks_cluster.eks.id
}

output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster."
  value       = aws_eks_cluster.eks.arn
}

output "cluster_certificate_authority_data" {
  description = "Nested attribute containing certificate-authority-data for your cluster. This is the base64 encoded certificate data required to communicate with your cluster."
  value       = aws_eks_cluster.eks.certificate_authority[0].data
}

output "kubeconfig" {
  description = "kubectl config file contents for this EKS cluster."
  value       = data.template_file.kubeconfig.rendered
}

output "auth_token" {
  value       = data.aws_eks_cluster_auth.eks.token
}