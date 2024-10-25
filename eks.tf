# Create an SSH Key Pair for the EKS Nodes
resource "aws_key_pair" "eks_key" {
  key_name   = "eks-key-pair"  # Key name of your choice
  public_key = file("~/.ssh/id_rsa.pub")  # Path to your public key
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = "1.21"
  subnets         = aws_subnet.eks_subnet[*].id
  vpc_id          = aws_vpc.eks_vpc.id

  node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1

      instance_type = "t3.medium"
      key_name      = aws_key_pair.eks_key.key_name
    }
  }

  manage_aws_auth = true
}

output "eks_key_name" {
  value = aws_key_pair.eks_key.key_name
}
output "eks_key_pair" {
  value = aws_key_pair.eks_key.key_name
}
output "cluster_name" {
  value = module.eks.cluster_id
}

output "kubeconfig" {
  value = module.eks.kubeconfig
}
