# Terraform + Ansible Active Directory Lab

This repository contains a hybrid Infrastructure-as-Code (IaC) lab built to simulate a real-world infrastructure provisioning and configuration workflow using **Terraform** and **Ansible**. The goal is to provision a complete environment in AWS that includes:

- A VPC with public subnets
- A Linux instance (Amazon Linux 2)
- A Windows Server instance promoted to an Active Directory Domain Controller
- A Linux client joined to the Windows domain (via `realm`)
- Basic Terraform modularization for reusability
- Optional Ansible automation (e.g., AD setup)

---

## 📦 Stack

- **Terraform**: Infrastructure provisioning (VPC, EC2, etc)
- **Ansible**: Post-provisioning configuration (optional)
- **AWS**: Hosting environment
- **Windows Server 2019 Base AMI**: Domain Controller
- **Amazon Linux 2**: Domain member

---

## 🏗️ Architecture Overview

```
          +-----------------------------+
          |     AWS VPC (10.0.0.0/16)   |
          |                             |
          |  +-----------------------+  |
          |  |  Public Subnet 1      |  |
          |  |  - Linux Instance     |  |
          |  +-----------------------+  |
          |                             |
          |  +-----------------------+  |
          |  |  Public Subnet 2      |  |
          |  |  - Windows AD Server  |  |
          |  +-----------------------+  |
          +-----------------------------+
```

---

## 🚀 How to Use

### 1. Clone the Repo
```bash
git clone https://github.com/rodmassis/terraform-ansible-ad-lab.git
cd terraform-ansible-ad-lab
```

### 2. Customize Your `terraform.tfvars`
Update the `terraform.tfvars` file with values such as:
```hcl
aws_region         = "us-east-1"
key_name           = "interview-lab-keypair"
vpc_cidr           = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
availability_zones = ["us-east-1a", "us-east-1b"]
project_prefix     = "interview-lab"
linux_ami          = "ami-0c2b8ca1dad447f8a" # Amazon Linux 2
windows_ami        = "ami-007a8c6e3de28d435" # Windows Server 2019
linux_instance_type = "t2.micro"
windows_instance_type = "t2.large"
```

### 3. Run Terraform
```bash
terraform init
terraform plan
terraform apply
```

### 4. Connect to Your Instances
- Linux via SSH: `ssh -i ~/.ssh/interview-lab-keypair.pem ec2-user@<PublicIP>`
- Windows via RDP (Get password using `aws ec2 get-password-data` CLI)

---

## 🧩 Structure

```bash
.
├── main.tf                # Root module orchestrating submodules
├── terraform.tfvars       # Variable values
├── variables.tf           # Input variable declarations
├── modules/
│   ├── network/           # VPC + subnets
│   ├── linux_server/      # EC2 instance + SG
│   └── windows_server/    # Windows EC2 instance + SG
├── ansible/               # Ansible roles/playbooks (optional)
└── README.md
```

---

## ⚙️ Optional Add-ons

- Automate AD Domain setup via Ansible
- Add DNS forwarding / join Linux box to domain via `realm join`
- Set up CloudWatch Logs or SSM Agent for monitoring
- Add CI/CD with GitHub Actions for `terraform plan/apply`

---

## 🏁 Status

✅ Phase 1 complete: Infrastructure provisioned via Terraform  
⬜ Phase 2 in progress: AD Domain setup and Ansible automation  
⬜ Phase 3 (optional): Add front-end + job queue

---

## 📘 License
MIT — feel free to fork and adapt.

---

## 👤 Author
**Rodrigo Assis** — [github.com/rodmassis](https://github.com/rodmassis)
