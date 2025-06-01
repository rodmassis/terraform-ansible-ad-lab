# Root main.tf for setting up reusable AWS infrastructure (VPC + EC2 Linux + EC2 Windows for AD)

provider "aws" {
  region = var.aws_region
}
resource "tls_private_key" "infra_lab" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "infra_lab" {
  key_name   = var.key_name
  public_key = tls_private_key.infra_lab.public_key_openssh
}

resource "local_file" "private_key_pem" {
  content              = tls_private_key.infra_lab.private_key_pem
  filename             = "${path.module}/infra-lab-key.pem"
  file_permission      = "0400"
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

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/ansible/inventory/hosts.ini"
  content  = <<-EOT
[linux]
${module.linux_server.private_ip}

[windows]
${module.windows_server.private_ip}
EOT
}

output "linux_public_ip" {
  description = "Public IP of the Linux server"
  value       = module.linux_server.public_ip
}

output "linux_private_ip" {
  description = "Private IP of the Linux server"
  value       = module.linux_server.private_ip
}

output "linux_instance_id" {
  description = "EC2 Instance ID of the Linux server"
  value       = module.linux_server.instance_id
}

output "windows_public_ip" {
  description = "Public IP of the Windows (AD) server"
  value       = module.windows_server.public_ip
}

output "windows_private_ip" {
  description = "Private IP of the Windows (AD) server"
  value       = module.windows_server.private_ip
}

output "windows_instance_id" {
  description = "EC2 Instance ID of the Windows (AD) server"
  value       = module.windows_server.instance_id
}

# resource "null_resource" "generate_ansible_inventory" {
#   provisioner "local-exec" {
#     command = <<EOT
#       echo "[windows]" > ansible/inventory/hosts.ini
#       echo "${module.windows_server.private_ip}" >> ansible/inventory/hosts.ini
#       echo "\n[linux]" >> ansible/inventory/hosts.ini
#       echo "${module.linux_server.private_ip}" >> ansible/inventory/hosts.ini
#     EOT
#   }
#   depends_on = [module.linux_server, module.windows_server]
# }
