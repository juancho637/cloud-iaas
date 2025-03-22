provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

provider "tls" {
  # No requiere configuración adicional
}
