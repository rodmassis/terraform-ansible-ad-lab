# root/variables.tf

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "project_prefix" {
  description = "Project name prefix for resource naming"
  type        = string
}

variable "linux_ami" {
  description = "AMI ID for Linux EC2 instance"
  type        = string
}

variable "linux_instance_type" {
  description = "Instance type for Linux EC2 instance"
  type        = string
}

variable "windows_ami" {
  description = "AMI ID for Windows EC2 instance"
  type        = string
}

variable "windows_instance_type" {
  description = "Instance type for Windows EC2 instance"
  type        = string
}

variable "key_name" {
  description = "Name of the AWS key pair for SSH/RDP access"
  type        = string
}
