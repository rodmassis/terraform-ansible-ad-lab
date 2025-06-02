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
  filename             = "${path.module}/ssh/infra-lab-key.pem"
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
  filename = "../ansible/inventory/hosts.ini"
  content  = <<-EOT
[linux]
${module.linux_server.public_ip}

[windows]
${module.windows_server.public_ip}
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

resource "null_resource" "ssh_key_setup" {
  provisioner "local-exec" {
    command = <<EOT
mkdir -p ~/.ssh
cp ${path.module}/ssh/infra-lab-key.pem ~/.ssh/infra-lab-key
chmod 600 ~/.ssh/infra-lab-key
echo "🔐 Key copied to ~/.ssh/infra-lab-key"

# Optional: Add to agent
if command -v ssh-agent > /dev/null && [ -z "$SSH_AUTH_SOCK" ]; then
  eval "$(ssh-agent -s)"
fi
ssh-add ~/.ssh/infra-lab-key || echo "⚠️ Could not add key to agent (maybe agent not running?)"
EOT
  }

  depends_on = [local_file.private_key_pem]
}

resource "null_resource" "get_windows_password" {
  provisioner "local-exec" {
    command = <<EOT
echo "🔐 Fetching Windows Administrator password..."
aws ec2 get-password-data \
  --instance-id ${module.windows_server.instance_id} \
  --priv-launch-key ~/.ssh/infra-lab-key.pem \
  --region ${var.aws_region} \
  --query PasswordData \
  --output text > ../ansible/windows_password.txt

if [ -s ansible/windows_password.txt ]; then
  echo "✅ Windows password stored in ansible/windows_password.txt"
  echo "🔑 Password: $(cat ansible/windows_password.txt)"
else
  echo "❌ Password not yet available — try again after a few minutes"
fi
EOT
  }

  triggers = {
    instance_id = module.windows_server.instance_id
  }

  depends_on = [module.windows_server]
}
