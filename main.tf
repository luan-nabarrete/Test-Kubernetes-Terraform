module "vpc" {
  source                = "./modules/vpc"
  name                  = var.vpc_name
  vpc_cidr              = var.vpc_cidr_block
  public_subnet_cidr    = var.public_subnet_cidr
  private_subnet_cidrs  = var.private_subnet_cidrs
  azs                   = var.azs
}

