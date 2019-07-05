resource "azuread_application" "flow" {
  name       = "${var.name}-${var.environment}_flow_client"
  reply_urls = "${var.reply_urls}"
  type       = "webapp/api"

  required_resource_access {
    # Windows Azure Active Directory API
    resource_app_id = "00000002-0000-0000-c000-000000000000"

    resource_access {
      #  DELEGATED PERMISSIONS: "Sign in and read user profile":
      #  311a71cc-e848-46a1-bdf8-97ff7156d8e6
      id   = "311a71cc-e848-46a1-bdf8-97ff7156d8e6"
      type = "Scope"
    }
  }
}

resource "azuread_service_principal" "flow_client" {
  application_id = "${azuread_application.grafana.application_id}"
}

resource "azuread_service_principal_password" "flow_client_password" {
  service_principal_id = "${azuread_service_principal.grafana_client.id}"
  value                = "${random_string.application_client_password.result}"
  end_date             = "${timeadd(timestamp(), "87600h")}" # 10 years

  lifecycle {
    ignore_changes = ["end_date"]
  }
}

resource "random_string" "application_client_password" {
  length  = 16
  special = true

  keepers = {
    service_principal = "${azuread_service_principal.grafana_client.id}"
  }
}
