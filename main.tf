data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

locals {
    account_id = data.aws_caller_identity.current.account_id
}

provider "aws" {
  region  = var.region
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.4"

  cluster_name                             = var.cluster_name
  cluster_version                          = var.kubernetes_version
  subnet_ids                               = module.vpc.private_subnets
  vpc_id                                   = module.vpc.vpc_id
  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  cluster_addons = {
    vpc-cni            = {
      most_recent = true
    }
    coredns            = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
        most_recent = true
        service_account_role_arn = "arn:aws:iam::${local.account_id}:role/AmazonEKS_EBS_CSI_DriverRole"
    }
  }

  eks_managed_node_groups = {
    default = {
      desired_capacity = var.eks_managed_ng_desired_capacity
      max_capacity     = var.eks_managed_ng_max_capacity
      min_capacity     = var.eks_managed_ng_min_capacity

      instance_types = var.eks_managed_ng_instance_types
    }
  }

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}

resource "helm_release" "jupyterhub" {
  name             = "jhub"
  repository       = "https://jupyterhub.github.io/helm-chart"
  chart            = "jupyterhub"
  version          = var.jupyterhub_chart_version
  namespace        = "jupyterhub"
  create_namespace = true

  values     = [file("jupyterhub-values.yaml")]
  depends_on = [module.eks]
}

resource "helm_release" "nexus" {
  name       = "nexus"
  namespace  = "nexus"
  repository = "https://sonatype.github.io/helm3-charts/"
  chart      = "nexus-repository-manager"
  version    = var.nexus_chart_version
  create_namespace = true
  
  depends_on = [module.eks]
}
