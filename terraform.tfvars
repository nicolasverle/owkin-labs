region             = "eu-west-1"
cluster_name       = "mycluster1"
kubernetes_version = "1.32"
environment        = "dev"

vpc_cidr        = "10.0.0.0/16"
private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

jupyterhub_chart_version = "3.3.7"
nexus_chart_version = "44.0.1"
