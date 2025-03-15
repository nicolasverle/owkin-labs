variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
  default     = "my-eks-cluster"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.29"
}

variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "dev"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "eks-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "eks_managed_ng_instance_types" {
  description = "Desired capacity of the managed node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "eks_managed_ng_desired_capacity" {
  description = "Desired capacity of the managed node group"
  type        = number
  default     = 3
}

variable "eks_managed_ng_max_capacity" {
  description = "Max capacity of the managed node group"
  type        = number
  default     = 5
}

variable "eks_managed_ng_min_capacity" {
  description = "Min capacity of the managed node group"
  type        = number
  default     = 1
}

variable "jupyterhub_chart_version" {
  description = "Helm chart version for JupyterHub"
  type        = string
  default     = "3.3.7"
}

variable "nexus_chart_version" {
  description = "Helm chart version for Nexus"
  type        = string
  default     = "44.0.1"
}
