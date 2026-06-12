output "public_ip" {
  value = azurerm_public_ip.pip.ip_address
}

output "ssh" {
  description = "Copy-paste this to connect."
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.pip.ip_address}"
}
