# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80.0"
    }
  }
  required_version = ">= 0.14.9"
}
provider "azurerm" {
  features {}
  skip_provider_registration = true
}

# Resource Group

resource "azurerm_resource_group" "rg" {
  name     = "task-rg"
  location = "centralus"
}

resource "azurerm_service_plan" "task_plan" {
  name                = "task-service-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}


resource "azurerm_linux_web_app" "task_app" {
  name                = "task-app"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.task_plan.id

  site_config {
    application_stack {
      node_version = "18-lts"
    }
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }
}
