# modules/windows_server/main.tf

resource "random_id" "suffix" {
  byte_length = 2
}

locals {
  suffix = random_id.suffix.hex
}

resource "aws_security_group" "this" {
  name        = "${var.project_prefix}-windows-sg-${random_id.suffix.hex}"
  description = "Allow RDP, AD, DNS, and internal traffic"
  vpc_id      = var.vpc_id

  # Allow RDP from your IP
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = var.allowed_ips
  }

  ingress {
    description = "Allow WinRM HTTPS"
    from_port   = 5986
    to_port     = 5986
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # or limit to your IP
  }

  # Allow internal AD traffic (Linux join, ping, etc.)
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_prefix}-windows-sg"
  }
}

resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.this.id]
  associate_public_ip_address = true

  user_data = <<-EOF
  <powershell>
  # Install WinRM
  winrm quickconfig -q
  Enable-PSRemoting -Force

  # Create Self-Signed Cert
  $Cert = New-SelfSignedCertificate -DnsName "$env:COMPUTERNAME" -CertStoreLocation Cert:\LocalMachine\My

  # Create HTTPS Listener
  New-Item -Path WSMan:\LocalHost\Listener -Transport HTTPS -Address * -CertificateThumbprint $Cert.Thumbprint -Force

  # Allow Unencrypted/BASIC Auth
  winrm set winrm/config/service '@{AllowUnencrypted="true"}'
  winrm set winrm/config/service/auth '@{Basic="true"}'

  # Set WinRM timeout
  winrm set winrm/config '@{MaxTimeoutms="1800000"}'

  # Open firewall
  New-NetFirewallRule -Name "WinRM-HTTPS" -DisplayName "WinRM over HTTPS" -Enabled True -Protocol TCP -LocalPort 5986 -Action Allow
  </powershell>
  EOF

  tags = {
    Name = "${var.project_prefix}-windows"
  }
}
