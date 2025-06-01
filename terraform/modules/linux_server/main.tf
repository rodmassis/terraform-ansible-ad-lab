# modules/linux_server/main.tf

resource "random_id" "suffix" {
  byte_length = 2
}

locals {
  suffix = random_id.suffix.hex
}

resource "aws_security_group" "this" {
  name        = "${var.project_prefix}-linux-sg-${local.suffix}"
  description = "Allow SSH inbound"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ips
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"        # allow ping
    cidr_blocks = [var.vpc_cidr]  # allow from inside VPC
  }

  tags = {
    Name = "${var.project_prefix}-linux-sg"
  }
}

resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.this.id]
  associate_public_ip_address = true

  tags = {
    Name = "${var.project_prefix}-linux"
  }
}
