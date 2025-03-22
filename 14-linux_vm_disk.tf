resource "azurerm_linux_virtual_machine" "linux_vm_disk" {
  name                = "miUbuntuVM-Disk"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_Ds1_v2"
  admin_username      = "azureuser"
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.linux_nic_disk.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.ssh_key.public_key_openssh
  }

  custom_data = base64encode(file("20-cloud-init-disk.txt"))
}
