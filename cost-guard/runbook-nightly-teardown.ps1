<#
cost-guard runbook — the nightly dead-man's switch.
Runs in Azure Automation (cloud-side, so it fires even if your laptop is off).

Every evening it walks the subscription and:
  1. DEALLOCATES every VM            (stops compute billing; disks/IPs still bill pennies)
  2. DEALLOCATES every Azure Firewall (config is kept; billing stops — restart when needed)
  3. STOPS every Application Gateway  (billing stops while stopped)
  4. DELETES every Bastion host + its public IP (Standard Bastion can't be "stopped";
     it's one apply away in Terraform, so deletion is the cap)

Opt-out: tag any resource you want left alone with  keepalive = true
(e.g. a VM you deliberately want running overnight).

Uses the Automation account's system-assigned Managed Identity — no stored credentials.
#>

param()

$ErrorActionPreference = "Continue"
Disable-AzContextAutosave -Scope Process | Out-Null
Connect-AzAccount -Identity | Out-Null

function Skip-IfKeepAlive($tags, $name, $type) {
    if ($tags -and $tags["keepalive"] -eq "true") {
        Write-Output "SKIP  $type '$name' (keepalive=true)"
        return $true
    }
    return $false
}

# ---- 1. Deallocate all VMs ---------------------------------------------------
foreach ($vm in Get-AzVM -Status) {
    if (Skip-IfKeepAlive $vm.Tags $vm.Name "VM") { continue }
    $state = ($vm.Statuses | Where-Object Code -like "PowerState/*").Code
    if ($state -ne "PowerState/deallocated") {
        Write-Output "DEALLOCATE VM '$($vm.Name)' (was $state)"
        Stop-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -Force -NoWait | Out-Null
    }
}

# ---- 2. Deallocate all Azure Firewalls ---------------------------------------
foreach ($fw in Get-AzFirewall) {
    if (Skip-IfKeepAlive $fw.Tag $fw.Name "Firewall") { continue }
    if ($fw.IpConfigurations.Count -gt 0) {
        Write-Output "DEALLOCATE Firewall '$($fw.Name)' (config preserved)"
        $fw.Deallocate()
        Set-AzFirewall -AzureFirewall $fw | Out-Null
    }
}

# ---- 3. Stop all Application Gateways ----------------------------------------
foreach ($agw in Get-AzApplicationGateway) {
    if (Skip-IfKeepAlive $agw.Tag $agw.Name "AppGateway") { continue }
    if ($agw.OperationalState -eq "Running") {
        Write-Output "STOP AppGateway '$($agw.Name)'"
        Stop-AzApplicationGateway -ApplicationGateway $agw | Out-Null
    }
}

# ---- 4. Delete all Bastion hosts (+ their public IPs) ------------------------
foreach ($bas in Get-AzBastion) {
    if (Skip-IfKeepAlive $bas.Tag $bas.Name "Bastion") { continue }
    Write-Output "DELETE Bastion '$($bas.Name)' (one terraform apply recreates it)"
    $pipIds = @($bas.IpConfigurations | ForEach-Object { $_.PublicIpAddress.Id })
    Remove-AzBastion -InputObject $bas -Force
    foreach ($id in $pipIds) {
        if ($id) {
            Write-Output "DELETE Bastion public IP $($id.Split('/')[-1])"
            Remove-AzResource -ResourceId $id -Force | Out-Null
        }
    }
}

Write-Output "cost-guard sweep complete: $(Get-Date -Format u)"
