# modules/windows_server/variables.tf

variable "ami_id" {
  description = "AMI ID to launch the Windows instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the Windows server"
  type        = string
  default     = "t3.medium"
}

variable "subnet_id" {
  description = "Subnet ID where the instance will be deployed"
  type        = string
}

variable "key_name" {
  description = "SSH key pair name to use for the instance (RDP access uses .pem file)"
  type        = string
}

variable "project_prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "allowed_ips" {
  description = "List of CIDRs allowed to access SSH or RDP"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for security group"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC for internal access"
  type        = string
}
