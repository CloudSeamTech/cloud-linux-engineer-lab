# Audio Index & Naming Convention — Cloud & Linux Engineer Lab

**92 clips. Phase 3 = Active Directory, Phase 4 = Linux; 10.3 Sentinel SOC capstone closes the course.** `module-X-Y` ⇄ course module X.Y; `NN_` prefix = play order. Keep `audio/` flat; run `verify-audio.sh` from the repo root after each batch.

## Crosswalk (play order → class location)


### Intro

| # | Audio file | Course location | Title |
|---|------------|-----------------|-------|
| 01 | `01_course-intro.mp3` | Intro | Course Introduction |

### Prerequisites

| # | Audio file | Course location | Title |
|---|------------|-----------------|-------|
| 02 | `02_prereq-01-workstation.mp3` | Prerequisite | Prerequisite 1: A workstation you control |
| 03 | `03_prereq-02-subscription-budget.mp3` | Prerequisite | Prerequisite 2: An Azure subscription, and a budget alert |
| 04 | `04_prereq-03-vscode.mp3` | Prerequisite | Prerequisite 3: Install Visual Studio Code |
| 05 | `05_prereq-04-install-clis.mp3` | Prerequisite | Prerequisite 4: Install the command-line tools |
| 06 | `06_prereq-05-vscode-extensions.mp3` | Prerequisite | Prerequisite 5: Add the editor extensions |
| 07 | `07_prereq-06-sign-in-verify.mp3` | Prerequisite | Prerequisite 6: Sign in and verify |
| 08 | `08_prereq-07-ssh-key.mp3` | Prerequisite | Prerequisite 7: Create an SSH key |
| 09 | `09_prereq-08-git-github.mp3` | Prerequisite | Prerequisite 8: Set up Git and GitHub |
| 10 | `10_prereq-09-glossary.mp3` | Prerequisite | Prerequisite 9: Skim the glossary |

### P0 — Foundations & Guardrails

| # | Audio file | Course location | Title |
|---|------------|-----------------|-------|
| 11 | `11_phase0-intro.mp3` | Phase intro | Phase 0: Foundations & Guardrails |
| 12 | `12_module-0-1.mp3` | 0.1 | Learn the role and the frameworks |
| 13 | `13_module-0-2.mp3` | 0.2 | Create the subscription and lock down cost |
| 14 | `14_module-0-3.mp3` | 0.3 | Make VS Code your command center (install + verify the toolchain) |
| 15 | `15_module-0-4.mp3` | 0.4 | Map the Azure hierarchy (tenant → RG → resource) |
| 16 | `16_module-0-5.mp3` | 0.5 | Landing zones & on-prem-to-cloud migration (the process) |
| 17 | `17_module-0-6.mp3` | 0.6 | IaaS vs SaaS — two authorization boundaries for one org |
| 18 | `18_module-0-7.mp3` | 0.7 | What DevOps really is — culture, flow, and business value |

### P1 — Infrastructure as Code (Terraform)

| # | Audio file | Course location | Title |
|---|------------|-----------------|-------|
| 19 | `19_phase1-intro.mp3` | Phase intro | Phase 1: Infrastructure as Code (Terraform) |
| 20 | `20_module-1-1.mp3` | 1.1 | Grasp why IaC exists |
| 21 | `21_module-1-2.mp3` | 1.2 | First Terraform project: provider + resource group |
| 22 | `22_module-1-3.mp3` | 1.3 | Remote state with locking |
| 23 | `23_module-1-4.mp3` | 1.4 | Variables, outputs, and a reusable module |
| 24 | `24_module-1-5.mp3` | 1.5 | Rollbacks, import, and state surgery |
| 25 | `25_module-1-6.mp3` | 1.6 | Tag from day one + the VM (Virtual Machine) bootstrap pattern |
| 26 | `26_module-1-7.mp3` | 1.7 | Scan your Infrastructure-as-Code for misconfigurations |
| 27 | `27_module-1-8.mp3` | 1.8 | Make your Terraform scale — reusable modules and per-environment state |

### P2 — Networking Backbone

| # | Audio file | Course location | Title |
|---|------------|-----------------|-------|
| 28 | `28_phase2-intro.mp3` | Phase intro | Phase 2: Networking Backbone |
| 29 | `29_module-2-1.mp3` | 2.1 | VNet, subnets, and hub-and-spoke |
| 30 | `30_module-2-2.mp3` | 2.2 | Network Security Groups (least privilege) |
| 31 | `31_module-2-3.mp3` | 2.3 | Secure admin access (Bastion / jumpbox) |
| 32 | `32_module-2-4.mp3` | 2.4 | Private DNS (Domain Name System) and name resolution |
| 33 | `33_module-2-5.mp3` | 2.5 | Network troubleshooting toolkit |
| 34 | `34_module-2-6.mp3` | 2.6 | Private Endpoints — keep platform services off the internet |
| 35 | `35_module-2-7.mp3` | 2.7 | Azure Firewall, UDRs & egress control — and proving it enforces |
| 36 | `36_module-2-8.mp3` | 2.8 | Load balancing, availability zones, and scaling the app tier |

### P3 — Active Directory, DNS (Domain Name System) & GPO (Group Policy Object)

| # | Audio file | Course location | Title |
|---|------------|-----------------|-------|
| 37 | `37_phase3-intro.mp3` | Phase intro | Phase 3: Windows & Active Directory Identity |
| 38 | `38_module-3-1.mp3` | 3.1 | Deploy a Windows Server DC from Terraform |
| 39 | `39_module-3-2.mp3` | 3.2 | Promote to AD DS (Active Directory Domain Services) + integrated DNS (Domain Name System) |
| 40 | `40_module-3-3.mp3` | 3.3 | OUs, two domain-joined clients, and a test user |
| 41 | `41_module-3-4.mp3` | 3.4 | Apply a DISA STIG (Security Technical Implementation Guide) GPO baseline |
| 42 | `42_module-3-5.mp3` | 3.5 | AD (Active Directory) account & replication troubleshooting |

### P4 — Linux: AlmaLinux, NGINX, Containers

| # | Audio file | Course location | Title |
|---|------------|-----------------|-------|
| 43 | `43_phase4-intro.mp3` | Phase intro | Phase 4: Linux — AlmaLinux, NGINX, Containers |
| 44 | `44_module-4-1.mp3` | 4.1 | Deploy an AlmaLinux VM (Virtual Machine) from Terraform |
| 45 | `45_module-4-2.mp3` | 4.2 | Harden it: SSH (Secure Shell), firewalld, SELinux (Security-Enhanced Linux), OpenSCAP STIG (Security Technical Implementation Guide) scan |
| 46 | `46_module-4-3.mp3` | 4.3 | NGINX as a hardened TLS (Transport Layer Security) reverse proxy |
| 47 | `47_module-4-4.mp3` | 4.4 | Containers with Podman (rootless) |
| 48 | `48_module-4-5.mp3` | 4.5 | Linux storage troubleshooting (the classic 'disk full') |
| 49 | `49_module-4-6.mp3` | 4.6 | Linux common issues & quick fixes (SELinux (Security-Enhanced Linux), firewall, systemd…) |
| 50 | `50_module-4-7.mp3` | 4.7 | Performance, optimization & elastic scale (Linux + cloud) |

### P5 — Patch & Endpoint Management

| # | Audio file | Course location | Title |
|---|------------|-----------------|-------|
| 51 | `51_phase5-intro.mp3` | Phase intro | Phase 5: Patching & Configuration at Scale |
| 52 | `52_module-5-1.mp3` | 5.1 | Stand up WSUS (and know it's deprecated) |
| 53 | `53_module-5-2.mp3` | 5.2 | Azure Update Manager (the modern successor) |
| 54 | `54_module-5-3.mp3` | 5.3 | Intune enrollment & compliance policies |
| 55 | `55_module-5-4.mp3` | 5.4 | Patch troubleshooting & content cleanup |
| 56 | `56_module-5-5.mp3` | 5.5 | MECM / Configuration Manager — the brain over WSUS (Windows Server Update Services) |
| 57 | `57_module-5-6.mp3` | 5.6 | Linux patch management at scale (cloud-native) |

### P6 — Security Tooling & Monitoring

| # | Audio file | Course location | Title |
|---|------------|-----------------|-------|
| 58 | `58_phase6-intro.mp3` | Phase intro | Phase 6: Security Operations |
| 59 | `59_module-6-1.mp3` | 6.1 | Microsoft Defender for Cloud (posture + compliance) |
| 60 | `60_module-6-2.mp3` | 6.2 | Centralized logging + Sentinel SIEM (Security Information and Event Management) |
| 61 | `61_module-6-3.mp3` | 6.3 | Vulnerability scanning |
| 62 | `62_module-6-4.mp3` | 6.4 | Compliance scanning & evidence capture |
| 63 | `63_module-6-5.mp3` | 6.5 | Key Vault & customer-managed encryption |

### P7 — Operations, Troubleshooting & Efficiency

| # | Audio file | Course location | Title |
|---|------------|-----------------|-------|
| 64 | `64_phase7-intro.mp3` | Phase intro | Phase 7: Operations, Troubleshooting & Efficiency |
| 65 | `65_module-7-1.mp3` | 7.1 | Identity done right (RBAC (Role-Based Access Control), PIM (Privileged Identity Management), break-glass) |
| 66 | `66_module-7-2.mp3` | 7.2 | Storage troubleshooting playbook (Azure side) |
| 67 | `67_module-7-3.mp3` | 7.3 | Deployment & rollback playbook (CI/CD (Continuous Integration / Continuous Delivery)) |
| 68 | `68_module-7-4.mp3` | 7.4 | Efficiency: tagging, naming, modules, runbooks |
| 69 | `69_module-7-5.mp3` | 7.5 | Cost optimization & teardown discipline |
| 70 | `70_module-7-6.mp3` | 7.6 | MFA & Conditional Access — the Zero Trust gate |
| 71 | `71_module-7-7.mp3` | 7.7 | Privileged Access Management (PAM) with Delinea |
| 72 | `72_module-7-8.mp3` | 7.8 | CI/CD pipelines with GitHub Actions and Azure Pipelines |
| 73 | `73_module-7-9.mp3` | 7.9 | Python for automation and the Azure SDK |

### P8 — Capstone — The ATO (Authorization to Operate) Simulation

| # | Audio file | Course location | Title |
|---|------------|-----------------|-------|
| 74 | `74_phase8-intro.mp3` | Phase intro | Phase 8: The Capstone |
| 75 | `75_module-8-1.mp3` | 8.1 | Build the full environment from one apply |
| 76 | `76_module-8-2.mp3` | 8.2 | Assess: run all scans, capture posture |
| 77 | `77_module-8-3.mp3` | 8.3 | Document: mini SSP + POA&M (Plan of Action and Milestones) |
| 78 | `78_module-8-4.mp3` | 8.4 | Diagram + control mapping |
| 79 | `79_module-8-5.mp3` | 8.5 | Destroy and rebuild from code |

### P9 — Market Add-Ons — Cloud Engineer Consensus

| # | Audio file | Course location | Title |
|---|------------|-----------------|-------|
| 80 | `80_phase9-intro.mp3` | Phase intro | Phase 9: Market Add-Ons |
| 81 | `81_module-9-1.mp3` | 9.1 | Kubernetes (AKS (Azure Kubernetes Service)) — container orchestration |
| 82 | `82_module-9-2.mp3` | 9.2 | Docker fluency — images & registries |
| 83 | `83_module-9-3.mp3` | 9.3 | Cross-cloud exposure — a slice of AWS |
| 84 | `84_module-9-4.mp3` | 9.4 | Observability — Prometheus + Grafana |
| 85 | `85_module-9-5.mp3` | 9.5 | Certification pathway — clear the resume filter |
| 86 | `86_module-9-6.mp3` | 9.6 | GitOps on AKS with Flux v2 |
| 87 | `87_module-9-7.mp3` | 9.7 | Kubernetes autoscaling in depth — HPA, Cluster Autoscaler, KEDA |

### P10 — Resilience & Response

| # | Audio file | Course location | Title |
|---|------------|-----------------|-------|
| 88 | `88_phase10-intro.mp3` | Phase intro | Phase 10: Resilience & Response |
| 89 | `89_module-10-1.mp3` | 10.1 | Backup & Disaster Recovery |
| 90 | `90_module-10-2.mp3` | 10.2 | Incident Response runbook + tabletop |
| 91 | `91_module-10-3.mp3` | 10.3 | Sentinel SOC capstone — map your lab and watch who's knocking |

### Closing

| # | Audio file | Course location | Title |
|---|------------|-----------------|-------|
| 92 | `92_closing.mp3` | Closing | Closing |

*92 clips — regenerated from current sources.*
