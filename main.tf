terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.67.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tf_rg_blobstore"
    storage_account_name = "tfblobstore"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
    skip_provider_registration = "true"
    features {}
}

variable "imagebuild" {
    type        = string
    description = "Latest Image Build"
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
        image  = "mjurenic/weatherapi:${var.imagebuild}}"
        cpu    = "1"
        memory = "1"

        ports {
            port     = 80
            protocol = "TCP"
        }
    }
}