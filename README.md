# Platform Engineer Networking Capstone
# Operating the Network as Code: Automating Configuration, Connectivity, and Change

## 👥 Team

- Connor Klingensmith  
- Corey Dorsey  
- Dane Davies  
- David Altman

---

## 📌 Overview

This project demonstrates an end-to-end Network as Code and infrastructure automation workflow using AWS, Terraform, Ansible, Prometheus, Grafana, Git, GitHub, Linux and GitHub Actions.

Terraform is used to provision and manage the AWS networking infrastructure, while Ansible configures the hosts and deploys application and monitoring services.

The environment includes multiple VPCs, VPC peering, public and private subnets, routing, security groups, a NAT gateway, Linux EC2 instances, and monitoring.

---

## 🎯 Architecture

The environment consists of three VPCs:

**VPC 1 - Application**

CIDR:
```
10.0.0.0/16
```

Contains:

Bastion host
Two private application servers
Public and private subnets
NAT Gateway

**VPC 2 - Observability**

CIDR:
```
10.1.0.0/16
```

Contains:

Prometheus server
Grafana server
Prometheus collects infrastructure metrics from node_exporter.

Grafana uses Prometheus as its datasource and provides visualization through the Infrastructure dashboard.

**VPC 3 - Router**

CIDR:
```
10.2.0.0/16
```

Contains:

Router
Public Subnet
Internet Gateway
Route Table

The router serves as the public entry point for the application and distributes HTTP requests between the two private application servers.

---

## 🌩️ Terraform Infrastructure
Terraform is responsible for provisioning and managing the AWS infrastructure.

Terraform manages:

- Three VPCs
- Public and private subnets
- Internet Gateway
- NAT Gateway
- NAT Gateway
- Route tables
- Route table associations
- VPC peering connections
- Security groups
- EC2 instances
- IAM role

This project uses a remote Terraform backend to store state. Remote state enables safe collaboration, automatic state locking, and seamless CI/CD execution.

Terraform configuration is stored in:
```
terraform/
```
🏗️ Terraform folder structure:
```
├── backend.tf
├── ec2/
│   ├── main.tf
│   └── variables.tf
│
├── main.tf
├── outputs.tf
│
├── peering/
│   ├── main.tf
│   ├── outputs.tf
│   └── variables.tf
│
├── providers.tf
├── terraform.tfstate
├── terraform.tfstate.backup
├── variables.tf
│
├── vpc_app/
│   ├── main.tf
│   ├── outputs.tf
│   └── variables.tf
│
├── vpc_obs/
│   ├── main.tf
│   ├── outputs.tf
│   └── variables.tf
│
└── vpc_router/
    ├── main.tf
    ├── outputs.tf
    └── variables.tf
```

---

## 🛠️ Ansible - Configuration Management
Ansible is used to configure the EC2 instances after the infrastructure is provisioned. Playbooks automate node_exporter installation, Prometheus deployment, Prometheus target configuration, Grafana deployment, Grafana datasource configuration, and Grafana dashboard provisioning.

Dynamic inventory configuration:
```
ansible/inventory/aws_ec2.yml
```
---
## AWS Dynamic Inventory
Ansible uses the AWS EC2 dynamic inventory plugin to automatically discover EC2 instances using AWS tags instead of relying on a manually maintained static inventory.

Instances are grouped using their AWS Role tags.

Including:
```
bastion
private_app
grafana
prometheus
router
```
---

## 🏗️ Ansible Folder Structure

```
├── ansible.cfg
│
├── collections/
│   └── requirements.yml
│
├── inventory/
│   ├── aws_ec2.yml
│   │
│   ├── group_vars/
│   │   ├── all.yaml
│   │   ├── all.yml
│   │   ├── cisco_router/
│   │   │   ├── tag_Role_router.yaml
│   │   │   └── vault.yaml
│   │   ├── router/
│   │   │   └── vault.yaml
│   │   └── tag_Role_private_app.yaml
│   │
│   ├── production/
│   │   └── hosts.yml
│   │
│   └── staging/
│       └── hosts.yml
│
├── playbooks/
│   ├── configure_router.yaml
│   ├── install_observability.yaml
│   ├── site.yml
│   └── verify_connectivity.yaml
│
└── roles/
    ├── cisco_router/
    │   ├── defaults/
    │   │   └── main.yaml
    │   ├── meta/
    │   │   └── main.yaml
    │   └── tasks/
    │       ├── bgp.yaml
    │       ├── main.yaml
    │       └── verify_bgp.yaml
    │
    ├── grafana/
    │   ├── defaults/
    │   │   └── main.yaml
    │   ├── handlers/
    │   │   └── main.yaml
    │   ├── tasks/
    │   │   └── main.yaml
    │   └── templates/
    │       └── datasources.yaml.j2
    │
    ├── node_exporter/
    │   ├── defaults/
    │   │   └── main.yaml
    │   └── tasks/
    │       └── main.yaml
    │
    └── prometheus/
        ├── handlers/
        │   └── main.yaml
        ├── tasks/
        │   └── main.yaml
        └── templates/
            └── prometheus.yaml.j2
```
---
## 📡 Monitoring and Observability
The monitoring environment consists of Prometheus, Grafana, and node_exporter.

## node_exporter
node_exporter runs on monitored Linux infrastructure and exposes system metrics on:
```
TCP Port 9100
```
Metrics include information about:

CPU utilization
Memory utilization
Network traffic
Filesystem usage
Host availability

## Prometheus
Prometheus collects metrics from the configured node_exporter targets.

Prometheus runs on:
```
TCP Port 9090
```

## Grafana
Grafana provides visualization for the metrics collected by Prometheus.

Grafana runs on:
```
TCP Port 3000
```
Ansible automatically configures:

- Prometheus as the Grafana datasource
- Capstone dashboard folder
- Capstone Infrastructure dashboard
- The dashboard provides visibility into infrastructure metrics including:

CPU usage
- Memory usage
- Network receive traffic
- Network transmit traffic
---
## Security
The project uses multiple layers of AWS network security.

These include:

Security Groups
Private application subnets
Bastion-based administrative access
NAT Gateway for outbound private subnet connectivity
VPC peering
IAM roles
Controlled inbound application access
The private application servers are not directly exposed to the public internet.

Public HTTP traffic enters through the router and is then forwarded to the private application servers.
---
## Infrastructure as Code
The AWS infrastructure is defined using Terraform.

This provides:

- Repeatable deployments
- Version-controlled infrastructure
- Configuration consistency
- Infrastructure change tracking
- Easier environment recreation
- Infrastructure validation before deployment
- Terraform configuration can be checked using:
```
terraform fmt
terraform validate
terraform plan
```
---
## Configuration as Code
Server configuration is managed through Ansible playbooks.

Playbooks can be validated before execution using:
```
ansible-playbook ansible/playbooks/<playbook>.yml --syntax-check
```
Ansible check mode can also be used:
```
ansible-playbook ansible/playbooks/<playbook>.yml --check
```
Configuration can then be applied with:
```
ansible-playbook ansible/playbooks/<playbook>.yml
```

---

## Idempotency
Ansible playbooks were tested for idempotency.

After the desired configuration has already been applied, running the playbook again produces results such as:
```
changed=0
failed=0
unreachable=0
```
This demonstrates that the automation does not unnecessarily modify resources that are already in the desired state.

---

## CI/CD
GitHub Actions workflow files are stored under:
```
.github/workflows/
```
The project includes workflows for:
```
ansible.yml
terraform.yml
```
These workflows are intended to automate infrastructure and configuration validation as part of the Git-based development process.

---

## Repository Structure
```
├── README.md
│
├── ansible/
│   ├── ansible.cfg
│   │
│   ├── collections/
│   │   └── requirements.yml
│   │
│   ├── inventory/
│   │   ├── aws_ec2.yml
│   │   │
│   │   ├── group_vars/
│   │   │   ├── all.yaml
│   │   │   ├── all.yml
│   │   │   ├── cisco_router/
│   │   │   │   ├── tag_Role_router.yaml
│   │   │   │   └── vault.yaml
│   │   │   ├── router/
│   │   │   │   └── vault.yaml
│   │   │   └── tag_Role_private_app.yaml
│   │   │
│   │   ├── production/
│   │   │   └── hosts.yml
│   │   │
│   │   └── staging/
│   │       └── hosts.yml
│   │
│   ├── playbooks/
│   │   ├── configure_router.yaml
│   │   ├── install_observability.yaml
│   │   ├── site.yml
│   │   └── verify_connectivity.yaml
│   │
│   └── roles/
│       ├── cisco_router/
│       │   ├── defaults/
│       │   │   └── main.yaml
│       │   ├── meta/
│       │   │   └── main.yaml
│       │   └── tasks/
│       │       ├── bgp.yaml
│       │       ├── main.yaml
│       │       └── verify_bgp.yaml
│       │
│       ├── grafana/
│       │   ├── defaults/
│       │   │   └── main.yaml
│       │   ├── handlers/
│       │   │   └── main.yaml
│       │   ├── tasks/
│       │   │   └── main.yaml
│       │   └── templates/
│       │       └── datasources.yaml.j2
│       │
│       ├── node_exporter/
│       │   ├── defaults/
│       │   │   └── main.yaml
│       │   └── tasks/
│       │       └── main.yaml
│       │
│       └── prometheus/
│           ├── handlers/
│           │   └── main.yaml
│           ├── tasks/
│           │   └── main.yaml
│           └── templates/
│               └── prometheus.yaml.j2
│
└── terraform/
    ├── backend.tf
    │
    ├── ec2/
    │   ├── main.tf
    │   └── variables.tf
    │
    ├── main.tf
    ├── outputs.tf
    │
    ├── peering/
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    │
    ├── providers.tf
    ├── terraform.tfstate
    ├── terraform.tfstate.backup
    ├── variables.tf
    │
    ├── vpc_app/
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    │
    ├── vpc_obs/
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    │
    └── vpc_router/
        ├── main.tf
        ├── outputs.tf
        └── variables.tf
```
---

🚀 **CI/CD Pipeline**

The pipeline includes:

### 1. Validate Stage
- Terraform fmt / validate  
- Ansible syntax check  
- Linting  

### 2. Dry-Run Stage
- Terraform plan posted back to PR  
- Ansible check mode  
- Diff artifacts for reviewer visibility

### 3. Deploy Stage
- Terraform apply  
- Ansible apply  
- Post-deployment validation  

Guardrails ensure safe promotion between environments.
---

 **Observability**

The solution provides visibility into:

- Current resource state  
- Configuration drift  
- Pipeline outcomes  
- Validation checks and API polling results  

This enables teams to detect failures, correct them through code, and re-run the workflow.
---

🎬 **Final Demonstration Scenario**

The final demo showcases:

- A PR introducing a multi-touch network change  
- Automated dry-run with diffs  
- Merge → automated deployment  
- Validation of cloud + host state  
- Intentional failure injection  
- Detection, correction, and successful re-run  

---

🔐 **Security & Guardrails**

- All credentials stored in Ansible Vault, Automation Controller, or approved secrets managers  
- No plaintext secrets in the repository  
- Direct CLI access allowed only for read-only verification  
- All changes must be reproducible from a clean clone  

---

📚 **How to Use This Repository**

### Prerequisites
- Terraform CLI  
- Ansible + required collections  
- GitHub Actions
- Access to provided cloud environment  

### Basic Workflow
1. Create a feature branch  
2. Implement Terraform + Ansible changes  
3. Open a pull request  
4. Review dry-run output  
5. Merge to trigger deployment  
6. Validate results  

---

📄 **Documentation**

- Architecture diagrams  
- Inventory model  
- Variable hierarchy  
- CI/CD pipeline flow  
- Observability tooling  
- Final presentation deck  
