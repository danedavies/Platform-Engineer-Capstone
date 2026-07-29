# Platform-Engineer-Capstone
# Operating the Network as Code: Automating Configuration, Connectivity, and Change

📌 **Overview**

This repository contains the end‑to‑end solution for the Platform Engineer Networking Bootcamp Capstone Project.

The goal is to operate a representative slice of a hybrid network environment entirely through code, using Terraform, Ansible, Git-based workflows, and CI/CD automation.

The project demonstrates how network operations can adopt the same declarative, version-controlled, observable model used by modern application platform teams.

---

🎯 **Objectives**

- Manage cloud network resources declaratively using Terraform with remote state.
- Automate configuration of reachable hosts, routers, firewalls, or services using Ansible.
- Execute all changes through a Git-based CI/CD pipeline triggered by pull requests.
- Provide observability into resource state, drift, and pipeline outcomes.
- Demonstrate a full workflow:  
  **Git commit → PR → dry-run → merge → deploy → validate**

---

🏗️ **Repository Structure**

```
terraform/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
│
├── vpc_app/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│
├── vpc_obs/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│
├── vpc_router/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│
├── peering/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│
└── ec2/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf

├── ansible/
│   ├── ansible.cfg  
│   ├── requirements.yml
│   ├── inventories/
│   │    ├── hosts.yml	
│   │	├── group_vars/
│   │	│	├── all.yml
│   │	│	├── public_hosts.yml 
│   │	│	├── private_hosts.yml 
│   │	│	└── routers.yml
│   │  	├── host_vars/
│   │	│	├── web01.yml
│   │	│	└── router01.yml
│   ├── roles/
│   │	├── common/
│   │	│	├── tasks/main.yml
│   │	│	└── handlers/main.yml
│   │	├── network/
│   │	│	├── tasks/main.yml 
│   │	│	├── templates/ 
│   │	│	└── defaults/main.yml 
│   │	├── routing/ 
│   │	├── tasks/main.yml 
│   │	│	└── defaults/main.yml
│   │	├── firewall/
│   │	│	├── tasks/main.yml
│   │	│	├── templates/
│   │	│	└── handlers/main.yml
│   │	├── webserver/
│   │	│	├── tasks/main.yml
│   │	│	├── files/index.html 
│   │	│	└── handlers/main.yml
│   │	└── monitoring/ 
│   │		├── tasks/main.yml
│   │		└── templates/
│   └── playbooks/
│ 	 ├── site.yml
│	 ├── configure_network.yml 
│	 ├── configure_firewall.yml 
│	 ├── validate.yml 
│	 └── audit.yml
│
├── pipeline/
│   ├── github-actions/
│   
│
├── observability/
│   ├── drift-checks/
│   ├── validation-scripts/
│   └── dashboards/
│
└── docs/
    ├── presentation/
    └── architecture-diagrams/
```

---

🌩️ **Cloud Networking (Terraform)**

This project provisions and manages cloud networking resources such as:

- VPCs / VNets  
- Subnets  
- Route tables  
- Security groups / NSGs  
- Peering / VPN endpoints  

All Terraform state is stored remotely to support collaboration and CI/CD automation.

---

🛠️ **Host Configuration (Ansible)**

Ansible roles and playbooks ensure hosts remain in a known-good state, including:

- Interface configuration  
- Routing  
- Firewall / ACL rules  
- Supporting services (DNS, monitoring agents, VPN daemons, etc.)

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

📡 **Observability**

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
- GitHub Actions or Jenkins runner  
- Access to provided cloud environment  
- Access to Automation Controller  

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

---

👥 **Team & Collaboration**

- Connor Klingensmith  
- Corey Dorsey  
- Dane Davies  
- David Altman
