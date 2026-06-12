#!/usr/bin/env bash
# cost-guard setup — run once from your laptop (or Cloud Shell).
# Creates: an Automation account with a managed identity, imports the nightly
# teardown runbook, schedules it for 19:00 daily, and (optionally) creates
# per-resource-group $5 budgets that fire the same runbook early via an
# action group webhook.
#
# Honest note baked in: budgets ALERT (with 8-24h cost-data lag) — the nightly
# schedule is the hard guarantee; the budgets are the early-warning backstop.

set -euo pipefail

LOCATION="eastus"
RG="rg-costguard"
AA="aa-costguard"
RUNBOOK="nightly-teardown"
SCHEDULE_TIME="19:00"            # local-ish; adjust TIMEZONE below
TIMEZONE="America/New_York"
SUB_ID=$(az account show --query id -o tsv)

echo "== 1. Resource group + Automation account (free tier: 500 job-min/month) =="
az group create -n "$RG" -l "$LOCATION" -o none
az automation account create -n "$AA" -g "$RG" -l "$LOCATION" --sku Free -o none

echo "== 2. Enable system-assigned managed identity + grant it rights =="
PRINCIPAL_ID=$(az automation account update -n "$AA" -g "$RG" \
  --set identity.type=SystemAssigned --query identity.principalId -o tsv)
# Needs to stop/start/delete across the subscription:
az role assignment create --assignee "$PRINCIPAL_ID" \
  --role "Contributor" --scope "/subscriptions/$SUB_ID" -o none
echo "   identity: $PRINCIPAL_ID (Contributor on subscription)"

echo "== 3. Import + publish the runbook =="
az automation runbook create -n "$RUNBOOK" -g "$RG" --automation-account-name "$AA" \
  --type PowerShell -o none
az automation runbook replace-content -n "$RUNBOOK" -g "$RG" \
  --automation-account-name "$AA" --content @runbook-nightly-teardown.ps1 -o none
az automation runbook publish -n "$RUNBOOK" -g "$RG" --automation-account-name "$AA" -o none

echo "== 4. Nightly schedule ($SCHEDULE_TIME $TIMEZONE) =="
START=$(date -u -d "tomorrow $SCHEDULE_TIME" +%Y-%m-%dT%H:%M:%S 2>/dev/null || \
        date -u -v+1d +%Y-%m-%dT${SCHEDULE_TIME}:00)
az automation schedule create -n "nightly-1900" -g "$RG" --automation-account-name "$AA" \
  --frequency Day --interval 1 --start-time "$START" --time-zone "$TIMEZONE" -o none
az automation job-schedule create -g "$RG" --automation-account-name "$AA" \
  --runbook-name "$RUNBOOK" --schedule-name "nightly-1900" -o none
echo "   runbook will sweep every evening."

echo
echo "== 5. (OPTIONAL) per-RG \$5 budgets that fire the runbook early =="
echo "   Budgets alert with cost-data lag — early warning, not a hard cap."
echo "   For each expensive resource group (put Firewall/AGW/Bastion in their own RGs):"
cat <<'EOF'
   # one-time: an action group that emails you AND triggers the runbook webhook
   WEBHOOK_URL=$(az automation webhook create -g rg-costguard \
       --automation-account-name aa-costguard --runbook-name nightly-teardown \
       -n budget-trigger --expiry-time "2027-12-31T00:00:00Z" --query uri -o tsv)
   az monitor action-group create -n ag-costguard -g rg-costguard \
       --short-name costguard \
       --action email me you@example.com \
       --action webhook killswitch "$WEBHOOK_URL"

   # then a $5 budget per expensive RG (repeat per RG):
   az consumption budget create-with-rg --budget-name budget-rg-firewall \
       --resource-group rg-firewall --amount 5 --category Cost \
       --time-grain Monthly \
       --start-date $(date +%Y-%m-01) --end-date 2027-12-31
   # (add a notification at 80%/100% pointing at ag-costguard in the portal —
   #  the CLI for budget action-group notifications varies by extension version,
   #  and the portal takes 30 seconds: Budgets > budget > Alert conditions.)
EOF
echo
echo "cost-guard installed. Test it now with:"
echo "  az automation runbook start -n $RUNBOOK -g $RG --automation-account-name $AA"
