variable "aws_profile" {
  type  = string
}

variable "region" {
  type  = string
}

variable "vpc_name" {
  type  = string 
}

variable "vpc_cidr_block" {
  type  = string 
}

variable "public_subnet_cidr" {
  type  = string 
}

variable "private_subnet_cidrs" {
  type  = list(string) 
}

variable "azs" {
  type  = list(string) 
}
