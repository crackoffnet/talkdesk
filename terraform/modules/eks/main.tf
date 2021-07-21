###############################
# IAM for EKS
###############################
resource "aws_iam_role" "iam_eks" {
  name = "${var.cluster_name}-${var.env}-eks-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
  tags       = "${merge(var.tags, tomap({"Name" = "Talkdesk-${var.env}-eks-iam-role"}))}"
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.iam_eks.name
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.iam_eks.name
}

resource "aws_iam_role" "node" {
  name = "${var.cluster_name}-${var.env}-eks-node-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node.name
}

resource "aws_iam_instance_profile" "node" {
  name = "${var.cluster_name}-eks-node-instance-profile"
  role = aws_iam_role.node.name
}

###############################
# EKS securityGroup
###############################
resource "aws_security_group" "cluster" {
  name        = "talkesk-terraform-${var.env}-eks-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags          = "${merge(var.tags, tomap({"Name" = "Talkdesk-${var.env}-eks-sg"}))}"
}

###############################
# EKS cluster
###############################
resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = aws_iam_role.iam_eks.arn

  vpc_config {
    security_group_ids = [aws_security_group.cluster.id]
    subnet_ids = "${var.private_subnet_id}"
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster-AmazonEKSServicePolicy,
  ]
}

resource "aws_eks_node_group" "eks-node" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.cluster_name}-${var.env}"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = "${var.private_subnet_id}"
  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }
  instance_types = [ "t2.medium" ]
  disk_size      = 10

  depends_on = [
    aws_eks_cluster.eks,
    aws_iam_role_policy_attachment.node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node-AmazonEKS_CNI_Policy
  ]
  tags          = "${merge(var.tags, tomap({"Name" = "Talkdesk-${var.env}-eks-sg"}))}"
}

data "aws_eks_cluster_auth" "eks" {
  name = aws_eks_cluster.eks.id
}