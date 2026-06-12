# Glossary — Plain English

Two parts: the **acronyms** you'll keep bumping into, and the **Azure services** we use — each with *why you'd use it* and *how it affects time and money*.

---

## Part 1 — Acronyms

| Term | In plain English |
|---|---|
| **ISSE** | Information Systems Security Engineer — the person who builds systems so they pass the security audit and earn permission to operate. |
| **RMF** | Risk Management Framework — the 6-step lifecycle every government system follows (Categorize → Select → Implement → Assess → Authorize → Monitor). |
| **NIST 800-53** | The master catalog of security controls (the "what must be true" list). |
| **STIG** | Security Technical Implementation Guide — a product-specific hardening checklist (the "exactly how to set it" list). |
| **ATO** | Authorization to Operate — official permission to run the system. |
| **SSP** | System Security Plan — the document describing how each control is met. |
| **POA&M** | Plan of Action & Milestones — the list of known gaps with fix dates. |
| **IL5 / IL6** | DoD cloud Impact Levels; IL6 = classified up to SECRET (Azure Government Secret only). |
| **VNet / Subnet** | Virtual Network (your private cloud network) / a slice of it for one job. |
| **NSG** | Network Security Group — a firewall of allow/deny rules on a subnet or VM. |
| **IaC** | Infrastructure as Code — defining your environment as text files instead of clicking. |
| **PAM** | Privileged Access Management — guarding the powerful admin/service credentials. |
| **PIM** | Privileged Identity Management — Azure's just-in-time admin elevation. |
| **RBAC** | Role-Based Access Control — who is allowed to do what. |
| **MFA** | Multi-Factor Authentication — password *plus* a second factor. |
| **CA** | Conditional Access — the rules engine that decides who gets in and how. |
| **SIEM** | Security Information & Event Management — the system that collects logs and raises alerts. |
| **EDR / XDR** | Endpoint Detection & Response / the broader cross-signal version. |
| **CMK** | Customer-Managed Key — you (not the cloud) hold the encryption key. |
| **SUP** | Software Update Point — the MECM role that drives WSUS. |
| **MECM** | Microsoft Configuration Manager (was SCCM/MECM) — the fleet-management brain over WSUS. |
| **WSUS** | Windows Server Update Services — the update warehouse for Windows. |
| **RTO / RPO** | Recovery Time Objective (how fast you recover) / Recovery Point Objective (how much data you can afford to lose). |
| **IR** | Incident Response — the process for handling a security event. |
| **CP** | Contingency Planning — the control family covering backup and recovery. |

---

## Part 2 — Azure services (why + time/money)

| Service | Plain English | Why you use it | Time & money |
|---|---|---|---|
| **Resource Group** | A folder for related resources. | Organize everything, and delete it all at once. | Free. Deleting the group is the fastest full teardown — instant savings. |
| **VNet / Subnet** | Your private network and its sections. | Isolation and segmentation. | Free — you only pay for what runs inside. |
| **NSG** | Firewall rules. | Least-privilege "deny by default." | Free. |
| **Azure Bastion** | Browser-based admin access with no public IP on the target. | Reach machines securely without exposing RDP/SSH. | Bills **hourly even when idle** — delete it when done for the day, or use a cheaper jumpbox. |
| **Public IP (static)** | An internet-reachable address. | A stable front-door address. | Small monthly charge; a reserved one costs even if unused — release it if you don't need it. |
| **Application Gateway + WAF** | A smart front door with a web firewall. | Protect the public web app, terminate TLS. | Hourly + capacity — pricier; only deploy when you build the public-facing piece. |
| **VM (B-series)** | A burstable virtual machine. | Cheapest family for bursty lab workloads. | Lowest VM cost; pair with **auto-shutdown + deallocate** for the biggest savings. |
| **Managed Disk** | A VM's storage. | Reliable disks for VMs. | You pay **even when the VM is stopped** — delete unused disks; Standard is cheaper than Premium. |
| **Storage Account** | Cloud file/blob storage. | Terraform state, logs, files. | Cheap; cool/archive tiers cut cost for data you rarely touch. |
| **Key Vault** | A safe for secrets and keys. | No hard-coded secrets; customer-managed encryption. | Tiny per-use cost; Standard is cheap, HSM (Premium) costs more. |
| **Private Endpoint** | Pulls a platform service onto your private network. | Keep Key Vault/Storage off the public internet (near-required at IL5/6). | Small hourly + data charge per endpoint — modest; remove at teardown. |
| **Log Analytics Workspace** | The central log database. | One place for all logs; the backbone for Sentinel. | Billed **per GB ingested** + retention — filter noise, set a daily cap, short retention in the lab. |
| **Microsoft Sentinel** | Cloud SIEM on top of Log Analytics. | Detect and investigate threats. | Per GB; **31-day free trial (10 GB/day)**, and many security logs ingest free. |
| **Defender for Cloud** | Security posture scoring + compliance dashboard. | See gaps and compliance status continuously. | Foundational posture (CSPM) is **free**; workload protection plans bill per resource — enable selectively. |
| **Defender for Endpoint** | The EDR agent on your clients/servers. | Endpoint detection and response. | Free trial; licensed per user/device after. |
| **Azure Policy** | Automatic governance rules. | Force standards (e.g., "every resource must be tagged"). | **Free.** Saves time by preventing mistakes instead of fixing them. |
| **Recovery Services Vault / Azure Backup** | Managed backups + restore. | Get your data back after loss. | Per protected instance + storage used — back up only what matters (the DC/data), rebuild stateless servers from code. |
| **Azure Update Manager** | Cloud patch orchestration for VMs. | Patch and report compliance without on-prem servers. | Free for Azure VMs. |
| **AKS (Kubernetes)** | Managed container orchestration. | Run containers at scale with self-healing. | Control-plane has a free tier; you pay for node VMs — **scale to zero / stop** to save. |
| **Entra ID P1 / P2** | The licensed identity tiers. | Needed for Conditional Access (P1) and PIM (P2). | Use a **free trial** in the lab; basic MFA (security defaults) is free without them. |
