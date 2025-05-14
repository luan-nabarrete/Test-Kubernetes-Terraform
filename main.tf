module "vpc" {
  source                = "./modules/vpc"
  name                  = var.vpc_name
  vpc_cidr              = var.vpc_cidr_block
  public_subnet_cidr    = var.public_subnet_cidr
  private_subnet_cidrs  = var.private_subnet_cidrs
  azs                   = var.azs
}

module "ec2_security_group" {
  source              = "./modules/security_groups"
  name                = var.vpc_name
  vpc_id              = module.vpc.vpc_id
  meu_ip              = var.meu_ip
  depends_on          = [module.vpc]
}

module "ec2" {
  source              = "./modules/ec2"
  subnet_id           = module.vpc.public_subnet_id
  sg_id               = module.ec2_security_group.ec2_sg_id
  instance_type       = var.instance_type
  depends_on          = [module.ec2_security_group]
}


output "ec2_public_ip_port" {
  description = "EC2 instance public IP + Port"
  value       = "${module.ec2.public_ip}:30080"
}

output "ec2_public_ip" {
  description = "EC2 instance public IP"
  value       = module.ec2.public_ip
}
