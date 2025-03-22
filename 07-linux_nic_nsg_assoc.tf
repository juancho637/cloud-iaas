resource "azurerm_network_interface_security_group_association" "linux_nic_lb_assoc" {
  count                     = 2
  network_interface_id      = azurerm_network_interface.linux_nic_lb[count.index].id
  network_security_group_id = azurerm_network_security_group.linux_nsg.id
}
