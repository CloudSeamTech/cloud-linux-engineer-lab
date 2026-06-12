# Reusable Lab VM (Terraform)

One command spins up your **exact** hardened Linux VM in Azure; one command tears it
down. This is the repetition engine: build it, do a drill, destroy it, repeat — until
the workflow is muscle memory.

## Why AlmaLinux (not Rocky)
Rocky Linux has **no free image** on the Azure Marketplace. AlmaLinux is the free,
RHEL-family, drop-in equivalent — same `dnf`, `firewalld`, **SELinux**, and STIG
experience. Everything you practice here transfers 1:1 to Rocky/RHEL on the job.

## Step 0 — Azure account + subscription (do this first)
Nothing deploys without an Azure **subscription** — it's the billing-and-container
boundary. If you don't have one, create an **Azure free account** (~$200 credit for
30 days) or **Pay-As-You-Go** (billed to a card). Confirm what you've got with
`az account show`; if you have more than one, pick it with
`az account set --subscription "<name-or-id>"`. Set a **budget alert**
(Cost Management -> Budgets) at $50 / $80 / $100 before you build anything.

## One-time setup (on your laptop — this is your "work-from-home" workbench)
The normal setup is: tools on your laptop, **all infrastructure in Azure**. You run
`terraform`/`az`/`ssh` locally and they reach into Azure — exactly how a remote cloud
engineer works. (Don't want local installs? See the Cloud Shell option below.)

1. Install **Terraform** and the **Azure CLI**, then `az login`.
2. Make an SSH key if you don't have one: `ssh-keygen -t ed25519`
3. Find your public IP and set it as the only SSH source (least privilege):
   `curl ifconfig.me` -> put it in a file `terraform.tfvars`:
   ```
   allow_ssh_cidr = "YOUR.IP.HERE/32"
   ```
4. (If `apply` fails with `VMMarketplaceInvalidInput`) accept the image terms once:
   ```
   az vm image terms accept --publisher almalinux --offer almalinux-x86_64 --plan 9-gen2
   ```
   ...and uncomment the `plan { }` block in `main.tf`. Confirm the current SKU with:
   `az vm image list --publisher almalinux --offer almalinux-x86_64 --all -o table`

## Optional: run it without local installs (Cloud Shell / jumpbox)
The default above runs from your laptop. If you'd rather not install anything locally,
you don't have to. The `lab-vm/` and `nginx-tls/` folders
live in your repo; you just `git clone` the repo wherever you're working. Two
Azure-native ways to do that:

- **Azure Cloud Shell** (portal -> the `>_` icon): `az`, `terraform`, and `git` are
  already installed. `git clone` this repo, `cd lab-vm`, `make up`. One catch: Cloud
  Shell's public IP changes each session, so run `curl ifconfig.me` and set
  `allow_ssh_cidr` to it before `make up` (or front the VM with Azure Bastion instead
  of a public IP). Cloud Shell needs a small Azure Files share (a few cents/month).
- **A small jumpbox / management VM** in Azure (it can be AlmaLinux): install the
  tools once, get a stable IP, and run everything from there. This is closer to how a
  real engineer works — from a managed workstation, not a personal laptop. Deallocate
  it when idle so it costs almost nothing.

Either way, the build VM and everything you create stay in Azure; your laptop is just
a browser. Stage 2 (the `nginx-tls` site) already runs *on* the VM, so it's in Azure
regardless.

## The repetition loop
| You want to... | Command | Cost |
|---|---|---|
| Build the exact VM from code | `make up` (or `terraform apply`) | starts billing |
| Log in | `make ssh` | — |
| **Come back tomorrow** (keep data) | `make stop` then later `make start` | ~$0 compute, ~$few/mo disk |
| **Done / save money** (rebuild later) | `make down` (or `terraform destroy`) | ~$0 |

### Deallocate vs. destroy — the key idea
- **Deallocate (`make stop`)** = the VM still exists; you've just stopped paying for
  compute. `make start` brings the *identical* VM + data back in seconds.
- **Destroy (`make down`)** = the VM and disk are gone. `make up` rebuilds an
  *identical* VM — but as a **fresh OS**. That's fine here because the hardening lives
  in `cloud-init.yaml`, so the rebuilt box comes up already configured. The lesson:
  keep your setup in code (Terraform + cloud-init/Ansible), never hand-tuned.

### Keep data across a destroy?
Put it on a separate **data disk** you persist, use **Azure Backup**, or push artifacts
to **Storage/Key Vault**. The OS disk is disposable on purpose.

## Cost
`Standard_B2s` is ~a few cents/hour; **deallocate when idle** and you pay only ~$few/mo
for the disk. This module deliberately includes **no** Azure Firewall / AKS / Bastion —
those are the budget-killers; add them only for a specific drill, then destroy same day.

## The drill (do this 5 times, time yourself)
`make up` -> `make ssh` -> confirm SELinux (`getenforce`), firewall
(`firewall-cmd --list-all`), key-only login -> `make down`. The goal isn't speed; it's
doing the whole loop without looking at notes.
