# Terraform + Ansible + Active Directory Lab

This lab automates the provisioning and configuration of a hybrid environment using **Terraform** and **Ansible**. It deploys a **Windows Server** (promoted to Domain Controller with Active Directory) and a **Linux server** (domain-joined client) on AWS — great for DevOps POCs, demonstrations, and practice.

---

## What This Project Does

- Provisions AWS infrastructure:
  - VPC, subnets, and security groups
  - Windows Server 2019
  - Amazon Linux 2
- Promotes Windows Server to AD Domain Controller
- Joins Linux instance to the domain
- Validates domain join status
- Reusable and modular Terraform + Ansible code

---

## Project Structure

```
terraform-ansible-ad-lab/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── outputs.tf
│   └── modules/
│       ├── network/
│       ├── linux_server/
│       └── windows_server/
├── ansible/
│   ├── inventory/
│   │   └── hosts.ini
│   ├── playbooks/
│   │   ├── promote-ad.yml
│   │   ├── join-linux-domain.yml
│   │   ├── validate-domain.yml
│   │   └── cleanup-domain.yml
│   └── site.yml
└── README.md
```

---

## How to Use

### 1. Deploy Infrastructure (Terraform)

```bash
cd terraform
terraform init
terraform apply
```

> Terraform will output the IPs used by Ansible.

---

### 2. Configure with Ansible

Edit the generated `ansible/inventory/hosts.ini` if needed, then:

```bash
cd ../ansible
ansible-playbook -i inventory/hosts.ini site.yml
```

This:
- Promotes the Windows Server to a Domain Controller
- Joins the Linux machine to the domain
- Validates domain membership

---

### 3. Clean Up (Optional)

```bash
ansible-playbook -i inventory/hosts.ini playbooks/cleanup-domain.yml
```

To destroy all infrastructure:

```bash
cd terraform
terraform destroy
```

---

## Useful for

- Realistic Active Directory automation
- Full hybrid environment simulation
- POC-ready DevOps/IaC use case
- Expandable with Ansible Tower, GitLab CI, or web UIs

---

## Requirements

- AWS account or sandbox (e.g., A Cloud Guru)
- Terraform v1.x
- Ansible 2.10+
- SSH key pair registered in AWS
- AWS CLI + credentials configured
- Python (for some Ansible modules)

---

## TODOs / Ideas for Expansion

- Add backend (S3 + DynamoDB) for Terraform state
- Dynamic inventory for Ansible
- Automate AD OU/GPO provisioning
- Add GitLab or Jenkins integration
- Create a web UI for provisioning

---
