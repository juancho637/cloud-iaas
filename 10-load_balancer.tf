# resource "azurerm_public_ip" "lb_public_ip" {
#   name                = "miLBPublicIP"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   allocation_method   = "Static"
#   sku                 = "Standard"
# }

# resource "azurerm_lb" "lb" {
#   name                = "miLoadBalancer"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   sku                 = "Standard"

#   frontend_ip_configuration {
#     name                 = "LoadBalancerFrontEnd"
#     public_ip_address_id = azurerm_public_ip.lb_public_ip.id
#   }
# }

# resource "azurerm_lb_backend_address_pool" "backendpool" {
#   name            = "miBackendPool"
#   loadbalancer_id = azurerm_lb.lb.id
# }

# resource "azurerm_lb_probe" "lb_probe" {
#   name                = "miHealthProbe"
#   loadbalancer_id     = azurerm_lb.lb.id
#   protocol            = "Http"
#   port                = 80
#   request_path        = "/"
#   interval_in_seconds = 5
#   number_of_probes    = 2
# }

# resource "azurerm_lb_rule" "lb_rule" {
#   name                           = "miLBRule"
#   loadbalancer_id                = azurerm_lb.lb.id
#   protocol                       = "Tcp"
#   frontend_port                  = 80
#   backend_port                   = 80
#   frontend_ip_configuration_name = "LoadBalancerFrontEnd"
#   backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backendpool.id]
#   probe_id                       = azurerm_lb_probe.lb_probe.id
# }

# resource "azurerm_network_interface_backend_address_pool_association" "nic_lb_association" {
#   count                   = 2
#   network_interface_id    = azurerm_network_interface.nic[count.index].id
#   ip_configuration_name   = "ipconfig1"
#   backend_address_pool_id = azurerm_lb_backend_address_pool.backendpool.id
# }

resource "azurerm_lb" "lb" {
  name                = "miLoadBalancer"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "LoadBalancerFrontEnd"
    public_ip_address_id = azurerm_public_ip.lb_public_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "lb_backend_pool" {
  name            = "miBackendPool"
  loadbalancer_id = azurerm_lb.lb.id
}

resource "azurerm_lb_probe" "lb_probe" {
  name                = "miHealthProbe"
  loadbalancer_id     = azurerm_lb.lb.id
  protocol            = "Http"
  port                = 80
  request_path        = "/"
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "lb_rule" {
  name                           = "miLBRule"
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "LoadBalancerFrontEnd"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb_backend_pool.id]
  probe_id                       = azurerm_lb_probe.lb_probe.id
}

resource "azurerm_network_interface_backend_address_pool_association" "linux_lb_association" {
  count                   = 2
  network_interface_id    = azurerm_network_interface.linux_nic_lb[count.index].id
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_backend_pool.id
}
