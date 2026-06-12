# cost-guard — plain-English version

## The problem, in one sentence

The cloud is like a taxi: **the meter runs while the engine is on**, and Azure has
no button that says "stop everything when I've spent $5" — so the only real way to
cap the money is to cap the **time** things are left running.

## The fix, in one sentence

We install a **robot in Azure** (an "Automation runbook") that wakes up **every
night at 7 PM** and turns off the expensive stuff for you — so even if you forget
everything and close your laptop, the worst a mistake can cost is **one afternoon,
never a whole month**.

## What does the robot actually do each night?

Think of it as a janitor doing rounds with three different moves, because Azure
resources have three different kinds of "off":

| Move | Plain English | Used on |
|---|---|---|
| **Deallocate** | "Park the car and stop the meter." The machine is OFF and NOT billing, but its disk and settings are saved — turn it back on tomorrow and it's exactly as you left it. | VMs, Azure Firewall |
| **Stop** | Same idea, App Gateway's version of it. Config saved, billing stopped. | App Gateway |
| **Delete** | "Return the rental entirely." Bastion has no off switch — you can only delete it. That's fine: your Terraform rebuilds it in one command tomorrow. | Bastion (Standard) |

⚠️ One trap worth understanding: **shutting down a VM from inside Windows/Linux does
NOT stop the bill.** Azure keeps charging because the hardware is still reserved for
you. Only **deallocate** stops the meter. (The robot always deallocates.)

Want the robot to leave something running overnight? Tag it `keepalive = true`
and it gets skipped.

## "Turn it off NOW" — the manual commands (your cheat sheet)

These are the same moves the robot makes, for when you finish a session and want
the meter stopped immediately instead of waiting for 7 PM.

**See what's running (and burning money) right now:**
```bash
az vm list -d -o table        # the PowerState column: "running" = billing
```

**VMs — stop the meter / start again:**
```bash
az vm deallocate -g <resource-group> -n <vm-name>     # OFF (meter stopped)
az vm start      -g <resource-group> -n <vm-name>     # back ON

# nuclear option — deallocate EVERY VM in the subscription:
az vm deallocate --ids $(az vm list --query "[].id" -o tsv)
```

**Azure Firewall — stop the meter / start again** (this one needs PowerShell —
`pwsh`, or the portal's Cloud Shell in PowerShell mode):
```powershell
$fw = Get-AzFirewall -Name <fw-name> -ResourceGroupName <rg>
$fw.Deallocate()
Set-AzFirewall -AzureFirewall $fw          # OFF — rules are saved

# back ON later (needs its vnet + public IP handed back):
$vnet = Get-AzVirtualNetwork -Name <vnet> -ResourceGroupName <rg>
$pip  = Get-AzPublicIpAddress -Name <fw-pip> -ResourceGroupName <rg>
$fw.Allocate($vnet, $pip)
Set-AzFirewall -AzureFirewall $fw
```
(Honestly? For the firewall, `terraform destroy` / `terraform apply` is often the
simpler off/on switch — same result, one command each way.)

**Application Gateway — stop / start:**
```bash
az network application-gateway stop  -g <rg> -n <agw-name>   # OFF
az network application-gateway start -g <rg> -n <agw-name>   # ON
```

**Bastion — delete it (it has no off switch), and its public IP too:**
```bash
az network bastion delete   -g <rg> -n <bastion-name>
az network public-ip delete -g <rg> -n <bastion-pip-name>
# tomorrow: terraform apply brings it right back
```

**The true zero — end of session, nothing left billing at all:**
```bash
terraform destroy        # in the folder you built from
```

## Why $5 works out

These things bill **by the hour**, so dollars = hours × rate. With the robot
guaranteeing nothing runs past the evening:

- One 3–4 hour lab session costs roughly: **Firewall Basic ~$1.50 · Bastion
  Standard ~$0.75 · App Gateway ~$1 · small VMs pennies.**
- So one or two sessions per month per resource = **each stays under $5**, automatically.
- Daily access tip: use Bastion's **Developer SKU — it's free**. Only deploy
  Standard for the rare tunneling session, then it gets deleted that night anyway.

## What the robot does NOT catch (the leftovers)

Two things keep billing pennies even when everything is "off":
**disks** (~$2–5/month each) and **static public IPs** (~$3.65/month each).
That's the small standing cost of keeping your machines' saved state around.
`terraform destroy` is the only true $0.

## Install it (once, ~2 minutes)

```bash
cd cost-guard
az login
bash setup-costguard.sh
```
That creates the robot (free tier — 500 minutes/month, the sweep uses ~2), gives it
permission via a managed identity (no passwords stored anywhere), and schedules it
for 7 PM nightly. Test it right now with:
```bash
az automation runbook start -n nightly-teardown -g rg-costguard \
  --automation-account-name aa-costguard
```

## And the $5 "budgets"?

Azure Budgets can **email you** at $5 and even trigger the robot early — set them
up per resource group (the setup script prints the commands). But know their
honest limit: Azure's cost data runs **8–24 hours behind**, so a budget is a smoke
alarm, not a sprinkler. The 7 PM robot is the sprinkler. Use both.
