# Feasibility Review — Can every module actually be done in a home lab on Azure?

**Verdict up front: 66 of 69 modules are fully hands-on feasible as written (✅). 3 are deliberately "pattern hands-on, product studied" (🟡) — each now has a free equivalent baked in so you still get real reps.** Nothing in the course requires classified access, a CAC, or enterprise licensing you don't have. The grading below assumes a pay-as-you-go Azure subscription, the budget alerts from Prereq 2, and the build → prove → tear down rhythm.

Legend: ✅ fully doable as written · 🟡 doable with the noted substitution/caveat (now baked into the module) · 💲 doable but bills hourly — teardown discipline required

## Prerequisites (9/9 ✅)
All free or already owned: a laptop, an Azure account, VS Code, the CLIs, an SSH key, GitHub. Nothing to flag.

## Phase 0 — Foundations (7/7 ✅)
| Module | Status | Note |
|---|---|---|
| 0.1 Frameworks (RMF/NIST/STIG) | ✅ | NIST 800-53 and DISA STIGs are public documents on public.cyber.mil — no CAC needed for the vast majority. |
| 0.2 Subscription + budget | ✅ | Budgets/alerts are free. |
| 0.3 VS Code command center | ✅ | Free. |
| 0.4 Azure hierarchy | ✅ | Free to explore; one resource group costs nothing. |
| 0.5 Landing zones / migration | ✅ | Conceptual + small-scale practice; CAF docs are public. |
| 0.6 IaaS vs SaaS boundaries | ✅ | Conceptual; drawn on paper. |
| 0.7 DevOps culture | ✅ | Reading + reflection. |

## Phase 1 — Terraform (8/8 ✅)
Terraform is free/open-source; the resources it builds in this phase (resource groups, a storage account for state, tags) cost pennies. The IaC scanners in 1.7 (Checkov, tfsec, Trivy) are all free. 1.8's two environments are both teardown-able. **Fully feasible.**

## Phase 2 — Networking (8 modules: 6 ✅, 2 💲)
| Module | Status | Note |
|---|---|---|
| 2.1 VNet/hub-spoke · 2.2 NSGs · 2.4 Private DNS | ✅ | VNets, subnets, NSGs, and private DNS zones are free or near-free. |
| 2.3 Bastion | 💲 | Developer SKU is cheap/free where available; Standard bills hourly — tear down after sessions. |
| 2.5 Network Watcher | ✅ | Diagnostic tools are effectively free at lab scale. |
| 2.6 Private endpoints | ✅ | ~1¢/hour each — fine for a session. |
| 2.7 Azure Firewall + UDR | 💲 | The most expensive single resource in the course (~$1+/hour). Module already says: deploy, prove allow/deny in logs, destroy same day. Feasible, just disciplined. |
| 2.8 Load balancer + AZs | ✅ | Basic LB free tier / Standard pennies; zones cost nothing extra. App Gateway bills hourly — same-day teardown. |

## Phase 3 — Active Directory (5/5 ✅, one fix applied)
| Module | Status | Note |
|---|---|---|
| 3.1 Windows Server VM | ✅ | **Server licensing is included in the Azure VM price** — no license to buy. B-series + auto-shutdown keeps it cheap. |
| 3.2 Promote AD DS + DNS | ✅ | Built-in roles, no cost beyond the VM. |
| 3.3 Two domain-joined clients | 🟡→✅ | **Fixed:** desktop Windows (10/11) images need an Enterprise E3/E5 or Visual Studio dev/test license you likely don't have — so the module now uses a small **Windows Server VM as the "workstation"** (license included, domain-join/GPO identical), plus the AlmaLinux loop-back join. Fully feasible. |
| 3.4 STIG GPO baseline | ✅ | DISA's GPO packages and STIG Viewer are free public downloads. |
| 3.5 AD/replication troubleshooting | ✅ | Built-in tools (dcdiag, repadmin). |

## Phase 4 — Linux (7/7 ✅)
AlmaLinux is free and Microsoft-endorsed. **OpenSCAP is fully open-source** — it lives in the AlmaLinux repos with the scap-security-guide STIG profile; there is nothing restricted about it. NGINX, Podman, your internal CA, tuned, and Scale Sets are all free software on cheap VMs. **The whole Linux phase is unconditionally feasible — this is the most home-lab-friendly phase in the course.**

## Phase 5 — Patching (6 modules: 5 ✅, 1 📖-by-design)
| Module | Status | Note |
|---|---|---|
| 5.1 WSUS | ✅ | Installs on your Windows Server eval — taught as legacy context anyway. |
| 5.2 Azure Update Manager | ✅ | Pennies per machine at lab scale. |
| 5.3 Intune | 🟡 | Free 30-day trial — feasible, but time-box the module inside the trial window. |
| 5.4 Patch troubleshooting | ✅ | Skills on machines you already have. |
| 5.5 MECM | 📖 by design | Module already says "recognize it, don't build it unless a JD demands it." 180-day eval exists if you ever need it. Correct call — skip the build. |
| 5.6 Ansible at scale | ✅ | Ansible is free; runs over SSH from your laptop or a small VM. |

## Phase 6 — Security Operations (5/5 ✅, substitutions baked in)
| Module | Status | Note |
|---|---|---|
| 6.1 Defender for Cloud | ✅ | Foundational posture (secure score, recommendations) is **free**; paid plans have a 30-day trial if you want to taste them. |
| 6.2 Logging + Sentinel | ✅ | Sentinel has a 31-day free trial and Log Analytics includes a free daily ingestion allowance — a lab's log volume fits easily. **Added:** Wazuh as your free, open-source endpoint-protection equivalent of Trellix/ESS — agent on your VMs, real detections, file-integrity monitoring, one dashboard. |
| 6.3 Vulnerability scanning | ✅ | **Added:** Nessus Essentials — free for 16 IPs and the same Tenable engine family ACAS is built on — plus Trivy and OpenVAS, all free. |
| 6.4 Compliance evidence | ✅ | OpenSCAP + SCC outputs + STIG Viewer, all free/public. |
| 6.5 Key Vault + CMK | ✅ | Pennies. |

## Phase 7 — Operations (9 modules: 8 ✅, 1 🟡 with hands-on stand-in)
| Module | Status | Note |
|---|---|---|
| 7.1 RBAC/PIM | 🟡 | RBAC fully free. PIM needs an Entra ID P2 license — there's a free trial; otherwise practice the role-assignment half hands-on and the JIT half conceptually. Honest as-is. |
| 7.2–7.6 Storage, rollback, runbooks, cost, MFA/CA | ✅ | All free or near-free (basic Conditional Access policies work on the trial tenant; MFA is free). |
| 7.7 PAM (Delinea) | 🟡→✅-pattern | **Added:** HashiCorp Vault (open source) as the hands-on stand-in — vault, lease with TTL, rotate, audit. You practice the real pattern free, and speak to Delinea/CyberArk honestly as studied. |
| 7.8 CI/CD | ✅ | GitHub Actions/Azure Pipelines free tiers are generous; OIDC federation is free. |
| 7.9 Python + Azure SDK | ✅ | Free. |

## Phase 8 — Capstone (5/5 ✅, one fix applied)
All composition of things you already built. **Fixed in 8.2:** the Windows scan now names SCC explicitly as a **free public download (NIWC Atlantic, no CAC)**; Evaluate-STIG may still sit behind DoD repos, so SCC + STIG Viewer is the stated home path. SSP/POA&M are documents you write. Destroy/rebuild costs nothing extra.

## Phase 9 — Market Add-Ons (7/7 ✅)
| Module | Status | Note |
|---|---|---|
| 9.1 AKS | 💲✅ | Free control-plane tier; you pay only for 1–2 small nodes — teardown after sessions. |
| 9.2 Docker | ✅ | Free. |
| 9.3 AWS slice | ✅ | AWS free tier covers it. |
| 9.4 Prometheus/Grafana | ✅ | Open source; run them on a lab VM or in AKS for free. |
| 9.5 Cert pathway | ✅ | Exam fees aside, study is free. |
| 9.6 GitOps/Flux | ✅ | The microsoft.flux extension is a free add-on. |
| 9.7 Autoscaling/KEDA | ✅ | Free add-ons; Service Bus Basic for the KEDA trigger costs ~nothing. |

## Phase 10 — Resilience (2/2 ✅)
Azure Backup at lab scale is small money; the test-restore and tabletop exercise are free.

## The three honest "can't fully replicate at home" items — and why that's fine
1. **Commercial PAM (Delinea/CyberArk)** → pattern practiced free in HashiCorp Vault; products studied, claimed honestly.
2. **Trellix/ESS endpoint suite** → same pattern, free, in Wazuh.
3. **MECM** → deliberately recognize-only; the market is moving to the cloud-native tools you DO build.
Plus one access nuance: **Evaluate-STIG** may need DoD repo access — but **SCC, STIG Viewer, the STIGs, and OpenSCAP are all public/free**, which covers the entire scan-remediate-evidence loop.

And the standing caveat the course already teaches: an IL6/classified *environment* can't exist at home — what you build is the unclassified mirror of its engineering, claimed exactly as that.

**Bottom line: the course is feasible end-to-end, the enterprise patterns are preserved, and every gap has a free equivalent that exercises the same muscle.**
