resource "azurerm_managed_disk" "linux_disk_data" {
  name                 = "linuxDataDisk-Disk"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  storage_account_type = "Standard_LRS"
  disk_size_gb         = 10
  create_option        = "Empty"
}

resource "azurerm_virtual_machine_data_disk_attachment" "linux_disk_data_attachment" {
  managed_disk_id    = azurerm_managed_disk.linux_disk_data.id
  virtual_machine_id = azurerm_linux_virtual_machine.linux_vm_disk.id
  lun                = 0
  caching            = "ReadWrite"
}
