output "lb_public_ip" {
  value       = azurerm_public_ip.lb_public_ip.ip_address
  description = "IP pública del Load Balancer."
}

output "linux_disk_vm_public_ip" {
  value       = azurerm_public_ip.linux_disk_public_ip.ip_address
  description = "IP pública de la VM Linux con disco."
}

output "windows_vm_public_ip" {
  value       = azurerm_public_ip.windows_public_ip.ip_address
  description = "IP pública de la VM Windows."
}

output "ssh_private_key" {
  value       = tls_private_key.ssh_key.private_key_pem
  description = "Llave privada SSH para las VMs Linux (sensible)."
  sensitive   = true
}
