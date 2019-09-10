module "aks_rbac" {
  source      = "../../modules/az_aks_rbac"
  name        = "${var.name}"
  environment = "${var.environment}"
}

module "service-principle" {
  source = "../../modules/az_service-principle"
  name   = "${var.name}-${var.environment}-k8s"
}

resource "azurerm_subnet" "kubesubnet" {
  name                 = "${var.name}-${var.environment}-k8s"
  resource_group_name  = "${var.resource_group.name}"
  address_prefix       = "${var.subnet_address_prefix}"
  virtual_network_name = "${var.vnet.name}"

  service_endpoints    = "${var.service_endpoints}"
}

locals {
  backend_address_pool_name      = "${var.vnet.name}-beap"
  frontend_port_name             = "${var.vnet.name}-feport"
  frontend_ip_configuration_name = "${var.vnet.name}-feip"
  http_setting_name              = "${var.vnet.name}-be-htst"
  listener_name                  = "${var.vnet.name}-httplstn"
  request_routing_rule_name      = "${var.vnet.name}-rqrt"
  redirect_configuration_name    = "${var.vnet.name}-rdrcfg"
}

resource "azurerm_kubernetes_cluster" "kubernetes" {
  name                = "${var.name}-${var.environment}-k8s"
  location            = "${var.resource_group.location}"
  resource_group_name = "${var.resource_group.name}"
  dns_prefix          = "${var.name}-${var.environment}"
  kubernetes_version  = "${var.kubernetes_version}"

  agent_pool_profile {
    name            = "default"
    vm_size         = "${var.node_type}"
    os_type         = "Linux"
    os_disk_size_gb = "${var.os_disk_size_gb}"
    max_pods        = "${var.max_pods}"

    enable_auto_scaling = "${var.agent_pool_profile_enable_auto_scaling}"
    min_count           = "${var.agent_pool_profile_min_count}"
    max_count           = "${var.agent_pool_profile_max_count}"
    type                = "${var.agent_pool_profile_type}"

    vnet_subnet_id = "${azurerm_subnet.kubesubnet.id}"
  }

  service_principal {
    client_id     = "${module.service-principle.client_id}"
    client_secret = "${module.service-principle.client_secret}"
  }

  role_based_access_control {
    enabled = true
    azure_active_directory {
      server_app_id     = "${module.aks_rbac.server_id}"
      server_app_secret = "${module.aks_rbac.server_secret}"
      client_app_id     = "${module.aks_rbac.client_id}"
    }
  }

  network_profile {
    network_plugin = "azure"
  }

  tags = {
    environment = "${var.environment}"
  }

  depends_on = ["azurerm_subnet.kubesubnet"]
}
