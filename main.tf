# Root main.tf for setting up reusable AWS infrastructure (VPC + EC2 Linux + EC2 Windows for AD)

provider "aws" {
  region = var.aws_region
}

module "network" {
  source = "./modules/network"
  vpc_cidr = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones = var.availability_zones
  project_prefix = var.project_prefix
}

module "linux_server" {
  source = "./modules/linux_server"
  ami_id = var.linux_ami
  instance_type = var.linux_instance_type
  subnet_id = module.network.public_subnets[0]
  key_name = var.key_name
  project_prefix = var.project_prefix
  allowed_ips   = ["0.0.0.0/0"]
  vpc_id        = module.network.vpc_id
  vpc_cidr = var.vpc_cidr
}

module "windows_server" {
  source = "./modules/windows_server"
  ami_id = var.windows_ami
  instance_type = var.windows_instance_type
  subnet_id = module.network.public_subnets[1]
  key_name = var.key_name
  project_prefix = var.project_prefix
  allowed_ips   = ["0.0.0.0/0"]
  vpc_id        = module.network.vpc_id
  vpc_cidr = var.vpc_cidr
}
