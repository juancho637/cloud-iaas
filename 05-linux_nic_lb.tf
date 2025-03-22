resource "azurerm_network_interface" "linux_nic_lb" {
  count               = 2
  name                = "linuxNIC-LB-${count.index}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.linux_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
