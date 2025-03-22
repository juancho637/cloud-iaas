resource "azurerm_network_security_group" "linux_nsg" {
  name                = "linuxNSG"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    destination_port_range     = "22"
    source_port_range          = "*"
  }
  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 1010
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    destination_port_range     = "80"
    source_port_range          = "*"
  }
}
