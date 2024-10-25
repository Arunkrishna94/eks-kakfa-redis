provider "aws" {
  region = "ap-south-1"  # Change to your AWS region
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"  # Update if using a different config path
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

variable "cluster_name" {
  default = "eks-cluster"
}

variable "region" {
  default = "ap-south-1"
}
