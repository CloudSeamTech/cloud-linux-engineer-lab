# prod-vm — production-hardened reference VM

The hardened sibling of [`../lab-vm`](../lab-vm). `lab-vm` is the simple teaching
version (public IP, SSH from your home IP). **`prod-vm` is what a real environment
expects.** Building both and being able to explain the difference is a strong
portfolio talking point.

## What this adds over `lab-vm`

| Control | lab-vm | prod-vm |
|---|---|---|
| Public IP on the VM | Yes (SSH from your /32) | **None** — reach it only via Azure Bastion |
| Admin access path | Direct SSH | **Bastion** (brokered, logged, no exposed port 22) |
| Trusted Launch (secure boot + vTPM) | No | **Yes** |
| Encryption at host | No | **Yes** |
| Managed identity | No | **System-assigned** (keyless Key Vault access) |
| Auto-shutdown | Manual deallocate | **Scheduled** (default 19:00) |
| Boot diagnostics | No | **Managed** |
| Remote state backend | No | **Wired (commented), ready to enable** |
| cloud-init hardening | firewalld, sshd, SELinux | + chrony (time sync) + auditd |

## ⚠️ Cost warning — this is NOT a leave-it-running lab

Azure **Bastion (Standard)** and its Standard public IP **bill by the hour** whether
or not you're connected (roughly a couple of dollars a day, plus data). Run
`make down` when you're finished for the day. `make stop` only deallocates the VM —
Bastion keeps charging until you `down`.

## One-time prerequisites

1. **SSH key** (if you don't have one): `ssh-keygen -t ed25519`
2. **Encryption at host** needs a one-time subscription feature registration:
   ```bash
   az feature register --namespace Microsoft.Compute --name EncryptionAtHost
   # wait until "Registered", then:
   az provider register -n Microsoft.Compute
   ```
   If you'd rather skip it, set `-var enable_encryption_at_host=false`.
3. **Trusted Launch** needs a gen2, TL-capable image (the default AlmaLinux 9-gen2
   qualifies). If an image ever rejects it, set `-var enable_trusted_launch=false`.
4. **First use of the AlmaLinux image** may require accepting marketplace terms:
   ```bash
   az vm image terms accept --publisher almalinux --offer almalinux-x86_64 --plan 9-gen2
   ```
   ...then uncomment the `plan { }` block in `main.tf` and re-apply.

## Deploy

```bash
az login
make init
make plan          # read it like a receipt before applying
make up
```

## Connect (over Bastion, from your laptop)

```bash
make connect       # runs the `az network bastion ssh` command for you
```
This works because the Bastion is **Standard SKU with tunneling enabled**. (On the
Basic SKU you'd connect through the portal instead.)

## Remote state (recommended for anything real)

Create the backend storage once, then uncomment the `backend "azurerm"` block in
`main.tf` and re-run `terraform init`:

```bash
az group create -n rg-tfstate -l eastus
az storage account create -n sttfstate$RANDOM -g rg-tfstate -l eastus --sku Standard_LRS
az storage container create -n tfstate --account-name <that-name>
```

## Teardown

```bash
make down          # destroys the VM, the Bastion, and the public IP
```

## Interview talking points

- *"The VM has no public IP — admin access is brokered through Azure Bastion, so
  there's no port 22 exposed to the internet to attack."*
- *"Trusted Launch gives me secure boot and a vTPM, so the boot chain is verified
  and I have hardware-rooted attestation."*
- *"The VM runs as a system-assigned managed identity, so it pulls secrets from Key
  Vault with no stored credentials."*
- *"Encryption at host, auto-shutdown for cost, managed boot diagnostics, remote
  state with locking — and the whole thing rebuilds identically from one apply."*

## Files

| File | Purpose |
|---|---|
| `main.tf` | Network, Bastion, NSG, hardened VM, auto-shutdown |
| `variables.tf` | Inputs + hardening toggles |
| `outputs.tf` | Private IP, identity principal ID, Bastion connect command |
| `cloud-init.yaml` | First-boot hardening (firewalld, sshd, chrony, auditd, SELinux) |
| `Makefile` | `init` / `plan` / `up` / `connect` / `stop` / `start` / `down` |
