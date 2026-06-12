# Tagging & VM Bootstrap — Best Practices

> Companion to **[architecture-and-networking.md](./architecture-and-networking.md)**. Two habits that belong *before* your first VM, not after: label every resource so it's accountable, and give every VM a minimal first-boot script so it configures itself. Doing both from the start keeps the environment consistent and auditable instead of retrofitted.

---

## Part 1 — Tagging

### What tags are
Tags are key-value labels you attach to resources — like luggage tags. They let you sort, report on, bill, automate, and govern everything you build.

### The mandatory tag set
Pick a small set and put it on **everything**. This lab uses:

| Tag | Example value | Why it exists |
|---|---|---|
| `environment` | `lab` | Separate lab/dev/prod; target automation by it |
| `owner` | `cloudseamtech` | Who's responsible (accountability / incident response) |
| `project` | `isse-azure-lab` | Group resources and costs by initiative |
| `managedBy` | `terraform` | Signals "do not hand-edit — this is code-managed" |
| `dataClassification` | `unclassified-training` | Sensitivity label (maps to inventory/handling controls) |

### Where tagging belongs in the process
This is the key point: tagging is **cross-cutting**, applied at two moments —

1. **Define + apply — Phase 1 (Infrastructure as Code).** You declare the tag set once in Terraform and stamp it on every resource as it's created. Tags exist from the very first `apply`.
2. **Enforce — Phase 7 (Governance).** Azure Policy makes the tags *mandatory*: deny resources that lack them, or auto-inherit them from the resource group.

So you **define early and enforce late** — never bolt tags on after the fact.

### The Terraform pattern (define once, reuse everywhere)
```hcl
locals {
  common_tags = {
    environment        = "lab"
    owner              = "cloudseamtech"
    project            = "isse-azure-lab"
    managedBy          = "terraform"
    dataClassification = "unclassified-training"
  }
}

resource "azurerm_linux_virtual_machine" "web" {
  # ...
  tags = local.common_tags
}
```

### Enforce with Azure Policy
Policy effects you'll use: **`deny`** (block creation if a required tag is missing), **`audit`** (flag non-compliant resources), and **`modify`/inherit** (auto-copy tags from the resource group). This is what turns tagging from "we try to" into "we always."

### The rules people trip on
- Tags are **case-sensitive** — `Owner` and `owner` are two different tags. Pick one convention.
- Max **50 tags** per resource.
- Tags **do not auto-inherit** from resource group to resource — you apply them in code, or use a policy to inherit.

### Why it matters for the gov path
`owner` + `dataClassification` + a consistent inventory of tagged resources map directly to **CM-8 (system component inventory)** and accountability controls. Tagging discipline is an auditable control, not just tidiness.

---

## Part 2 — Bootstrapping (running a script at VM creation)

When a VM first boots you usually want it to configure itself — install packages, register an agent, join the domain — without you logging in. That's "bootstrapping."

### The options, and which to use
- **Linux (Rocky) → cloud-init** *(preferred for Linux)*. A first-boot config file passed as `custom_data`. See the starter file **[cloud-init-web.yaml](./cloud-init-web.yaml)**.
- **Windows → Custom Script Extension (CSE)**. A VM extension that runs PowerShell after the VM is up — the usual home for Windows setup and domain-join.
- **Avoid Terraform `provisioner` blocks** (`remote-exec`/`local-exec`). HashiCorp calls these a last resort: not idempotent, run only on create, fail in confusing ways. Use cloud-init/extensions instead.
- **Heavy lifting → Ansible / pre-baked images (Packer).** Anything beyond "reach a known state" belongs in config management or a golden image.

### Best-practice rules for the script
- **Keep it minimal and idempotent** — safe to run again on a rebuild; do just enough to make the host reachable and known.
- **No secrets in the script or `custom_data`** — that data is readable. Pull secrets at runtime from Key Vault / Delinea.
- **Fail loudly and log.** Use `set -euo pipefail` in Bash; cloud-init logs to `/var/log/cloud-init-output.log`, CSE exposes status/logs.
- **Do real hardening in Ansible/OpenSCAP**, not the boot script — so it's documented and re-runnable, not hidden.

### Linux (Terraform attaches the cloud-init file)
```hcl
resource "azurerm_linux_virtual_machine" "web" {
  # ...
  custom_data = base64encode(file("${path.module}/cloud-init-web.yaml"))
  tags        = local.common_tags
}
```

### Windows (Custom Script Extension)
```hcl
resource "azurerm_virtual_machine_extension" "bootstrap" {
  name                 = "bootstrap"
  virtual_machine_id   = azurerm_windows_virtual_machine.dc.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
  settings = jsonencode({
    commandToExecute = "powershell -ExecutionPolicy Unrestricted -File bootstrap.ps1"
  })
  tags = local.common_tags
}
```

### The mental model
**Bootstrap = "get the machine to a known state and tag it." Ansible/OpenSCAP = "do the documented hardening."** Together, tags + a minimal bootstrap + config management are the "consistent and reproducible" story auditors and hiring managers want to see.

---

## Where these sit in the build

| Practice | Define / do it in… | Enforce / mature it in… |
|---|---|---|
| Resource tagging | Phase 1 (IaC) — `locals.common_tags` on every resource | Phase 7 (Governance) — Azure Policy required-tags |
| VM bootstrap | At each VM's creation — cloud-init / CSE | Phase 3+/Ansible — full STIG hardening |
