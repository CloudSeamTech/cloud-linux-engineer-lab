# Resilience & Response

Detection alone isn't a security program. This covers the two domains interviewers probe hardest: **getting your data back** (backup & disaster recovery) and **handling an incident calmly** (incident response).

---

## Part 1 — Backup & Disaster Recovery (DR)

### Plain English
- A **backup** is a copy of your data you can restore later.
- **Disaster recovery** is your plan to get the system running again after something breaks — a bad change, a failed disk, ransomware, a deletion.
- Two numbers define your goal: **RTO** (how *fast* you must be back up) and **RPO** (how much *data* you can afford to lose). Example: "back up the domain controller nightly (RPO = 1 day), restore within 4 hours (RTO = 4h)."

### The key insight
Your lab already recovers **infrastructure** from Terraform (`destroy` → `apply`). But that doesn't bring back **data**. So you back up the things that hold data (like the domain controller) and **rebuild the stateless stuff from code**. That split keeps costs down.

### What to do
1. Create a **Recovery Services Vault** and enable **Azure Backup** for the domain controller (and any data you care about).
2. Take a **disk snapshot** before risky changes — a cheap, instant rollback point.
3. Write down your **RTO/RPO** targets, then **prove them**: delete something and restore it.

### Why it matters / time & money
- **A backup you've never restored is a hope, not a backup** — the restore test is the whole point.
- **Cost:** Azure Backup bills per protected instance + storage used. In the lab, protect only the DC/data; let web/stateless hosts rebuild from Terraform. Snapshots are cheap and fast.
- **Control mapping:** this is the **Contingency Planning (CP)** family — a required, audited part of every ATO.

---

## Part 2 — Incident Response (IR)

### Plain English
When an alert fires, panic is expensive. A **runbook** turns an incident into a checklist so you act, not freeze. The industry standard lifecycle (NIST 800-61):

| Phase | What you do | Tools in this lab |
|---|---|---|
| **1. Prepare** | Have the runbook, contacts, logging, and backups ready *before* anything happens. | This doc, Sentinel, Azure Backup |
| **2. Detect & Analyze** | Spot it and confirm it's real; figure out scope. | Defender, Sentinel alerts/KQL |
| **3. Contain** | Stop the spread. Isolate the host, disable the account. | NSG isolation, disable user in AD/Entra |
| **4. Eradicate** | Remove the cause — malware, bad config, stolen key. | Defender remediation, rotate secrets |
| **5. Recover** | Restore clean systems and verify they're healthy. | Azure Backup restore, rebuild from Terraform |
| **6. Lessons Learned** | Write up what happened and fix the gap so it can't recur. | Update runbook, add to POA&M |

### Tabletop exercise (do this once)
Pick a scenario and walk every phase out loud — no clicking, just talking through decisions:

> **Scenario A — Compromised client.** Sentinel alerts on suspicious logins from `snet-clients`. Walk it: confirm in Defender (Detect) → isolate the machine with an NSG rule and disable the user (Contain) → remove malware and rotate the user's credentials (Eradicate) → restore the machine and re-enable access (Recover) → document and add MFA if it was missing (Lessons Learned).

> **Scenario B — Data spill.** Classified-marked data lands on an unclassified host. Walk it: stop and notify the security officer immediately → isolate the host → sanitize/re-image per policy (see media sanitization) → confirm clean → document.

### Why it matters / time & money
- **Cost: free** — it's process and practice. **Time:** an afternoon that pays off enormously when something real happens.
- A rehearsed team contains incidents faster, which directly limits damage.
- **Control mapping:** the **Incident Response (IR)** family. A documented, *exercised* plan (tabletops included) is a headline ATO requirement.

---

## How this connects to the rest of the lab
- **Detect** comes from Phase 6 (Defender/Sentinel).
- **Contain** uses Phase 2 (NSGs) and Phase 7 (disable accounts / RBAC).
- **Recover** uses backups (above) and Phase 8 (rebuild from code).
- **Lessons learned** feed your POA&M (Phase 8) — closing the RMF loop.
