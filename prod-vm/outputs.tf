output "resource_group" {
  value = azurerm_resource_group.rg.name
}

output "vm_private_ip" {
  description = "The VM has no public IP — this is reachable only via Bastion."
  value       = azurerm_network_interface.nic.private_ip_address
}

output "vm_identity_principal_id" {
  description = "System-assigned identity — grant it Key Vault access for keyless secrets."
  value       = azurerm_linux_virtual_machine.vm.identity[0].principal_id
}

output "connect_hint" {
  description = "Run this to SSH in over Bastion (needs the Standard SKU + tunneling, both set)."
  value = join(" ", [
    "az network bastion ssh",
    "--name", azurerm_bastion_host.bastion.name,
    "--resource-group", azurerm_resource_group.rg.name,
    "--target-resource-id", azurerm_linux_virtual_machine.vm.id,
    "--auth-type ssh-key",
    "--username", var.admin_username,
    "--ssh-key", replace(var.ssh_public_key_path, ".pub", "")
  ])
}
