# resource "azurerm_virtual_network" "vnet" {
#   name                = "miVnet"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   address_space       = ["10.0.0.0/16"]
# }

# resource "azurerm_subnet" "subnet" {
#   name                 = "miSubnet"
#   resource_group_name  = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = ["10.0.1.0/24"]
# }

# resource "azurerm_network_security_group" "vm_nsg" {
#   name                = "vmNSG"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location

#   security_rule {
#     name                       = "Allow-SSH"
#     priority                   = 1000
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#     destination_port_range     = "22"
#     source_port_range          = "*"
#   }

#   security_rule {
#     name                       = "Allow-HTTP"
#     priority                   = 1010
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#     destination_port_range     = "80"
#     source_port_range          = "*"
#   }
# }

# resource "azurerm_network_interface" "nic" {
#   count               = 2
#   name                = "vmNIC-${count.index}"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location

#   ip_configuration {
#     name                          = "ipconfig1"
#     subnet_id                     = azurerm_subnet.subnet.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.vm_public_ip[count.index].id
#   }
# }

# resource "azurerm_network_interface_security_group_association" "nic_nsg_assoc" {
#   count                     = 2
#   network_interface_id      = azurerm_network_interface.nic[count.index].id
#   network_security_group_id = azurerm_network_security_group.vm_nsg.id
# }

resource "azurerm_virtual_network" "vnet" {
  name                = "miVnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "linux_subnet" {
  name                 = "linuxSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
