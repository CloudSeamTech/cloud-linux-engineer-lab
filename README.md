# Cloud & Linux Engineer Lab — Azure, Hands-On, Narrated

A self-contained pathway from zero to working cloud / Linux / DevOps engineer, built
entirely in commercial Azure. **70 modules across 11 phases**, every one feasible in a
home lab, each mirroring how enterprise and government (IL5/6-style) systems are
actually engineered, hardened, monitored, and authorized — paired with a **92-part
narrated audio course** that teaches each module like a mentor sitting next to you.

The standing rule throughout: **never claim what your hands haven't done.** Everything
in this repo was built, broken, and fixed for real.

---

## What's in the box

| Path | What it is |
|---|---|
| `cloud_linux_engineer_lab.html` | **The class** — interactive Mission Console: 70 modules, progress tracking, cost rules, runbook, JD decoder (Zero Trust / DevSecOps / FISMA crosswalk) |
| `audio/` | **The voice** — 92 MP3 clips; the `NN_` prefix plays the course in order, `module-X-Y` maps each clip to its module |
| `narration/` | The full narration scripts (ElevenLabs v3 source + tag-free plain version) |
| `audio_index.md` / `audio_manifest.csv` | Clip ⇄ module crosswalk (human + machine readable) |
| `verify-audio.sh` | Checks `audio/` against the manifest — progress, gaps, misnamed files |
| `lab-vm/` | Terraform: the simple hardened AlmaLinux teaching VM (public IP locked to your `/32`) |
| `prod-vm/` | Terraform: the production pattern — **no public IP**, Bastion-only access, Trusted Launch, encryption at host, managed identity, auto-shutdown |
| `nginx-tls/` | Internal-CA PKI + NGINX-in-rootless-Podman HTTPS bundle (runs on the lab VM) |
| `cost-guard/` | The 7 PM "dead-man's switch": nightly Azure Automation runbook that deallocates VMs/Firewalls, stops App Gateways, deletes Bastion — plus $5 per-RG budget wiring |
| `feasibility_review.md` | Every module graded for home-lab feasibility, with free equivalents (Wazuh, Nessus Essentials, HashiCorp Vault, SCC) where enterprise tooling isn't obtainable |
| `docs/` | Reference write-ups (architecture, glossary, templates) |

## The course at a glance

Foundations & guardrails → Infrastructure as Code (Terraform that *scales*) →
Networking backbone (hub-spoke, NSGs, Bastion, private endpoints, egress control,
load balancing/AZs) → **Active Directory, DNS & GPO** (identity first) → **Linux**
(AlmaLinux, STIG hardening with OpenSCAP/SELinux, NGINX TLS, rootless Podman, the
7-rung diagnostic ladder, storage & performance) → Patching at scale (Update Manager,
Intune, Ansible) → Security operations (Defender, Sentinel + KQL, vuln scanning,
evidence, Key Vault) → Operations & delivery (RBAC/PIM, blue-green deployments,
runbooks, cost/FinOps, MFA/Conditional Access, CI/CD with OIDC — no stored secrets,
Python + Azure SDK) → **Capstone**: one-apply environment, assessed, documented
(SSP/POA&M), diagrammed, destroyed and rebuilt → Market add-ons (AKS, Docker, an AWS
slice, Prometheus/Grafana, GitOps with Flux v2, HPA/Cluster Autoscaler/KEDA) →
Resilience & response (backup/DR with tested restores, IR tabletop, **Sentinel SOC
capstone** — map your lab and watch who's knocking).

## Quickstart

```bash
git clone https://github.com/cloudseamtech/cloud-linux-engineer-lab.git
cd cloud-linux-engineer-lab
# open cloud_linux_engineer_lab.html in a browser — that's the class
# drop the audio in audio/ (or record your own from narration/), then:
bash verify-audio.sh
# start at Prerequisite 1 and press play on audio/01_course-intro.mp3
```

The infrastructure bundles are independently runnable — each folder's `README.md`
covers prerequisites, deploy, connect, and teardown (`lab-vm/` is the right first one).

## Cost discipline (the lesson inside the lesson)

- Build → prove → **tear down**. `terraform destroy` between sessions ≈ $0/month.
- Budgets + alerts from day one; hourly resources (Firewall, Bastion Standard, App
  Gateway) are session-only.
- `cost-guard/` enforces it mechanically: a nightly cloud-side sweep so the worst a
  forgotten resource can cost is one afternoon, never a month.
- Free trials cover the licensed pieces (Intune, Sentinel, Defender plans, Entra P2).

Run as designed: **~$30–70/month, often less.** Left running carelessly: $100+.
The discipline *is* the lesson.

## Repo hygiene

- The `.gitignore` keeps secrets and machine state out by construction: **never**
  commit `*.tfstate`, `*.tfvars`, keys, certs, or `.env` — and as configured, you
  can't by accident.
- This repo is **built to be public**: nothing sensitive lives in it, which is itself
  the demonstrated skill.
- Git history is permanent — if a secret ever lands in a commit, treat it as burned
  and rotate it immediately.

## Skills this demonstrates

Infrastructure as Code (Terraform modules, remote state, per-env isolation) ·
Linux engineering & STIG hardening (AlmaLinux, OpenSCAP, SELinux) · Active Directory,
DNS & GPO (incl. cross-platform `realm`/SSSD domain join) · CI/CD & DevSecOps (GitHub
Actions / Azure Pipelines, OIDC federation — zero stored credentials, embedded IaC
scanning) · GitOps (Flux v2) & Kubernetes autoscaling (HPA / Cluster Autoscaler /
KEDA) · blue-green & canary deployment · Zero Trust Architecture (identity-first,
micro-segmentation, assume-breach) · networking & least privilege (hub-spoke, NSGs,
Bastion, private endpoints, egress control) · patch & vulnerability management
(Update Manager, Ansible, Nessus/Trivy) · security operations (Defender, Sentinel,
KQL, SOAR playbooks) · secrets & PAM patterns (Key Vault, managed identity,
HashiCorp Vault) · Python automation (Azure SDK) · backup/DR with tested restores ·
incident response · FinOps · RMF / NIST 800-53 / FISMA control mapping & authorization
artifacts (SSP, POA&M).

---

See `LICENSE` for usage. This is a training scaffold built in commercial Azure; it is
not affiliated with, or endorsed by, DoD, DISA, NOAA, or any government program.
