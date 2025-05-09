resource "azurerm_public_ip" "linux_disk_public_ip" {
  name                = "linuxDiskPublicIP"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}
