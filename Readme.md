
# ☁️ Inca Agent‑Runner – Infra (Terraform)

Welcome! This repo provisions **everything needed for the Python Agent‑Runner app** using AWS + Terraform. You can deploy fully via GitHub Actions, no local tools required. Once you're done, destroy it the same way to avoid cost.

---

## 🚀 Quick Tour
| What you get | Why you care |
|--------------|--------------|
| **VPC + 2 public subnets** | High‑availability across 2 AZs; Internet‐facing demo. |
| **ALB → ECS Fargate** | Stable DNS, health‑checks; no server patching needed. |
| **ECR repo** | Private container registry for image pushes. |
| **IAM roles** |   • Task Execution  • CI/CD Provisioning (demo scope). |
| **Terraform ≥ 1.10+** | Native S3 state locking – no DynamoDB needed. Easier setup for CI/CD and demos. |

---

## 📦 Terraform Repo Structure & Best Practices

We structured the repo using reusable modules – a common pattern for real-world IaC setups:

```
.
├── modules/
│   ├── alb/
│   ├── ecs/
│   ├── ecr/
│   └── network/
├── .github/workflows/
│   ├── terraform.yml
│   └── terraform-cleanup.yml
├── backend.tf
├── main.tf
├── outputs.tf
├── providers.tf
├── terraform.tfvars
└── variables.tf
```

- `modules/` contain cleanly separated reusable components
- All state is remote (S3) with locking (thanks to TF ≥ 1.10)
- CI is done through GitHub Actions – no Terraform CLI required locally

---

## 🧠 Design Decisions

### Fargate vs. EC2 + Public IP
- **No servers to manage**, patch, or scale manually
- Pay-per-second, perfect for ephemeral demo workloads
- ALB handles health checks and auto-attach via task IPs

### ALB vs. Direct IP
- Fargate IPs change on every restart
- ALB gives **stable DNS**, better UX for demos
- Health checks ensure only healthy tasks are exposed

---

## 🔐 IAM User & Security Notes

We created a dedicated IAM user: **`inca-terraform-agent`**

The IAM policy attached to this user uses broad permissions (e.g., ec2:*, ecs:*, ecr:*, iam:*, etc.) for the purpose of the demo.
In production, this would be tightly scoped to least privilege, using precise ARNs and only required actions.

> **⚠️ Production Note:** These permissions are **too broad** and should be narrowed to the specific ARNs and actions required. For this demo, they are left permissive to avoid blockers.

---

## 🛠️ Deploy & Destroy using Github Actions

> **Nothing runs automatically** – you trigger it manually from GitHub Actions.

| Action | How | Notes |
|--------|-----|-------|
| **Plan / Apply** | **Actions → _🚀 Terraform CI/CD_ → _Run workflow_ → choose `plan` or `apply`** | See or apply changes. |
| **Destroy** | **Actions → _Terraform Destroy_ → Run workflow** | 💸 Please destroy after demo – ALB & Fargate can cost. |

### Output after Apply:
```
alb_url = "agent-runner-alb-30911118.eu-central-1.elb.amazonaws.com"
ecr_url = "905984969769.dkr.ecr.eu-central-1.amazonaws.com/agent-runner-repo"
public_subnet_ids = [
  "subnet-0679aef32f53e1bc1",
  "subnet-0a7757f7d254af4a7",
]
vpc_id = "vpc-088034a90bcb51a1a"
```

Use the alb_url/docs like the example below to access the swagger page for our python api which can be used to test the api

```
http://agent-runner-alb-30911118.eu-central-1.elb.amazonaws.com/docs
```
The Url might give 503 if you try to access it immediately so just be patient and wait a few minutes for the magic to happen and it will work.


All logs for the api can be found in Cloudwatch on AWS console in the loggroup

```
/ecs/agent-runner
```

## 🛠️ Deploy & Destroy locally 
If you prefer to run Terraform directly from your machine:

1. Set your AWS credentials in your terminal:
   ```bash
   export AWS_ACCESS_KEY_ID=your_key
   export AWS_SECRET_ACCESS_KEY=your_secret
   export AWS_REGION=eu-central-1
   ```

2. then run
   ```bash
   terraform init
   terraform apply
   ```
3. to destroy
    ```bash
    terraform destroy
    ```  
---

## 🔜 Next Steps

We're treating this as a strong starting point. Here's what's coming next:

### 🔐 Secrets Management with Vault

- Replace GitHub secrets with **HashiCorp Vault + AppRole**.
- Use **short-lived AWS credentials** generated dynamically per pipeline.
- Enforce strict Vault policies so each environment has **zero access** to others.

### 🧪 Multi-Environment Setup

We'll split infrastructure by environments:

- `envs/dev`, `envs/staging`, `envs/prod` folder structure
- Each environment will have:
  - Its **own `backend.tf`** (separate state file)
  - Its **own Vault configuration**
  - Its **own IAM role** allowed only to access resources of that env.

This ensures **full isolation**, prevents accidental cross-deployments, and aligns with Terraform and Vault best practices for production-grade environments.

### Branch Strategy & CI/CD Flow:
- Lock the main branch.
- Any push to a feature branch will only trigger terraform plan.
- Only a collaborator-approved merge to main will expose the manual terraform apply trigger.
- This ensures no accidental infrastructure deployment without peer review and control.

---

## 🤖 AI‑Assistance Note

Used **GPT‑4** to scaffold module structure and CI templates. Every block was manually reviewed and edited for naming, security, and logic.

---

Happy shipping! ✨
