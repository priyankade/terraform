provider "aws" {
  region = var.region
}

#create vpc
module "vpc" {
  source                       = "../modules/vpc"
  region                       = var.region
  project_name                 = var.project_name
  vpc_cidr                     = var.vpc_cidr
  public_subnet_az1_cidr       = var.public_subnet_az1_cidr
  public_subnet_az2_cidr       = var.public_subnet_az2_cidr
  private_app_subnet_az1_cidr  = var.private_app_subnet_az1_cidr
  private_app_subnet_az2_cidr  = var.private_app_subnet_az2_cidr
  private_data_subnet_az1_cidr = var.private_data_subnet_az1_cidr
  private_data_subnet_az2_cidr = var.private_data_subnet_az2_cidr
}

#create nat gateway
module "nat-gateway" {
  source                     = "../modules/nat-gateway"
  public_subnet_az1_id       = module.vpc.private_app_subnet_az1_id
  internet_gateway           = module.vpc.internet_gateway
  private_app_subnet_az1_id  = module.vpc.private_app_subnet_az1_id
  private_data_subnet_az1_id = module.vpc.private_data_subnet_az1_id
  vpc_id                     = module.vpc.vpc_id
}

#create security group
module "security-group" {
  source = "../modules/security-groups"
  vpc_id = module.vpc.vpc_id
}

# create application load balancer
module "alb" {
  source                = "../modules/alb"
  project_name          = var.project_name
  alb_security_group_id = module.security-group.alb_security_group_id
  public_subnet_az1_id  = module.vpc.public_subnet_az1_id
  public_subnet_az2_id  = module.vpc.public_subnet_az2_id
  vpc_id                = module.vpc.vpc_id
  prometheus_ec2_id     = module.ec2.prometheus_ec2_id
}

#create iam role
module "iam" {
  source       = "../modules/iam"
  project_name = var.project_name
}

module "ec2" {
  source                = "../modules/ec2"
  public_subnet_az1_id  = module.vpc.public_subnet_az1_id
  ec2_security_group_id = module.security-group.ec2_security_group_id
  user_data             = filebase64("user-data.sh")
}