resource "azurerm_network_interface_security_group_association" "linux_disk_nic_assoc" {
  network_interface_id      = azurerm_network_interface.linux_nic_disk.id
  network_security_group_id = azurerm_network_security_group.linux_disk_nsg.id
}
