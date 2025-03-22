resource "azurerm_network_interface" "linux_nic_disk" {
  name                = "linuxNIC-Disk"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.disk_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.linux_disk_public_ip.id
  }
}
