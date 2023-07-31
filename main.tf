terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.67.0"
    }
  }
}

provider "azurerm" {
    skip_provider_registration = "true"
    features {}
}

resource "azurerm_resource_group" "tf_test" {
    name = "tfmainrg"
    location = "West Europe"
}

resource "azurerm_container_group" "tfcg_test" {
    name                = "weatherapi"
    location            = azurerm_resource_group.tf_test.location
    resource_group_name = azurerm_resource_group.tf_test.name

    ip_address_type = "Public"
    dns_name_label  = "mjurenicwa"
    os_type         = "Linux"

    container {
        name   = "weatherapi"
        image  = "mjurenic/weatherapi"
        cpu    = "1"
        memory = "1"

        ports {
            port     = 80
            protocol = "TCP"
        }
    }
}