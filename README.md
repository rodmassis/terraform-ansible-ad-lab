# Terraform + Ansible Active Directory Lab

This is a hands-on lab environment for deploying a hybrid infrastructure with **Terraform** and **Ansible** to simulate real-world DevOps tasks. It automatically provisions a **Windows Server promoted to Domain Controller (AD)** and a **Linux client** that joins the domain. Ideal for training, interviews, or testing automated provisioning workflows.

---

## 🚀 What It Does

- Provisions:
  - 1x **Windows Server** (AD Domain Controller)
  - 1x **Linux Server** (Domain-joined client)
- Fully automated using:
  - **Terraform** to create AWS infrastructure
  - **Ansible** to configure Active Directory and domain join
- Prepares for DevOps interview questions involving:
  - AWS Infrastructure as Code (IaC)
  - Active Directory management
  - Ansible orchestration
  - Cross-platform automation

---

## 🧱 Project Structure

terraform-ansible-ad-lab/
├── terraform/
│ ├── main.tf
│ ├── variables.tf
│ ├── terraform.tfvars
│ ├── modules/
│ │ ├── network/
│ │ ├── linux_server/
│ │ └── windows_server/
│ └── outputs.tf
└── ansible/
├── inventory/
│ └── hosts.ini
├── playbooks/
│ ├── promote-ad.yml
│ ├── join-linux-domain.yml
│ ├── validate-domain.yml
│ └── cleanup-domain.yml
└── site.yml


---

## ⚙️ How to Use

### Step 1: Deploy infrastructure (Terraform)

```bash
cd terraform
terraform init
terraform apply
```
