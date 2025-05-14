aws_profile          = "devops"
region               = "us-east-1"

meu_ip               = "191.254.65.181"

vpc_name             = "nginx"
vpc_cidr_block       = "10.14.0.0/16"
public_subnet_cidr   = "10.14.2.0/24"
private_subnet_cidrs = ["10.14.1.0/24", "10.14.3.0/24"]
azs                  = ["us-east-1a", "us-east-1b"]
instance_type        = "t3.medium"


