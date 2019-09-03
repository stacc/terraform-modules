module "aks_rbac" {
  source      = "../../modules/az_aks_rbac"
  name        = "${var.name}"
  environment = "${var.environment}"
}

module "service-principle" {
  source  = "../../modules/az_service-principle"
  name = "${var.name}-${var.environment}-k8s"
}

resource "azurerm_subnet" "kubesubnet" {
  name                 = "${var.name}-${var.environment}-k8s"
  resource_group_name  = "${var.resource_group.name}"
  # (number of nodes + 1) + ((number of nodes + 1) * maximum pods per node that you configure)
  address_prefix       = "10.1.0.0/17"
  virtual_network_name = "${var.vnet.name}"
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
    name                = "default"
    count               = "${var.node_count}"
    vm_size             = "${var.node_type}"
    os_type             = "Linux"
    os_disk_size_gb     = "${var.os_disk_size_gb}"
    max_pods            = "${var.max_pods}"

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
data "azurerm_client_config" "client_config" {}

resource "azurerm_role_assignment" "public_ip" {
  principal_id         = "${module.service-principle.object_id}"
  role_definition_name = "Network Contributor"
  scope                = "${var.public_ip_rg.id}"
}

resource "azurerm_role_assignment" "aks" {
  principal_id         = "${module.service-principle.object_id}"
  role_definition_name = "Network Contributor"
  scope                = "${var.resource_group.id}"
}

resource "azuread_group" "cluster_admins" {
  name = "s_${var.name}-${var.environment}_cluster_admins"
}

resource "azuread_group" "cluster_developers" {
  name = "s_${var.name}-${var.environment}_cluster_developers"
}

provider "kubernetes" {
  version                = "1.7"
  load_config_file       = false
  host                   = "${azurerm_kubernetes_cluster.kubernetes.kube_admin_config.0.host}"
  client_certificate     = "${base64decode(azurerm_kubernetes_cluster.kubernetes.kube_admin_config.0.client_certificate)}"
  client_key             = "${base64decode(azurerm_kubernetes_cluster.kubernetes.kube_admin_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.kubernetes.kube_admin_config.0.cluster_ca_certificate)}"
}

resource "kubernetes_cluster_role_binding" "example" {
  metadata {
    name = "stacc-cluster-admins"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "Group"
    name      = "${azuread_group.cluster_admins.id}"
    api_group = "rbac.authorization.k8s.io"
  }
}
