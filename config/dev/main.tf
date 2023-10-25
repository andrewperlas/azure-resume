terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
  /*backend "azurerm" {
    resource_group_name  = "crcdev-rg"
    storage_account_name = "apcrcdevstorage1"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }*/
}

provider "azurerm" {
  features {}
}

data "azurerm_subscription" "subscription" {
  subscription_id = var.subscription
}

resource "azurerm_resource_group" "resource_group" {
  name     = var.rg_name
  location = var.location
  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_name
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = azurerm_resource_group.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  static_website {
    index_document     = "index.html"
    error_404_document = "404.html"
  }
  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_storage_container" "storage_container" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

resource "azurerm_cdn_profile" "cdn_profile" {
  name                = var.cdnprofile_name
  location            = "West US"
  resource_group_name = var.rg_name
  sku                 = "Standard_Microsoft"
  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_cdn_endpoint" "cdn_endpoint" {
  name                = var.cdnendpoint_name
  profile_name        = azurerm_cdn_profile.cdn_profile.name
  location            = azurerm_cdn_profile.cdn_profile.location
  resource_group_name = var.rg_name
  origin_host_header  = "apcrcdevstorage1.z5.web.core.windows.net"
  origin {
    name      = "devresume"
    host_name = "apcrcdevstorage1.z5.web.core.windows.net"
  }
  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_cdn_endpoint_custom_domain" "endpoint_custom_domain" {
  name            = var.cdncustomdomain_name
  cdn_endpoint_id = azurerm_cdn_endpoint.cdn_endpoint.id
  host_name       = var.cdncustomdomain_hostname
  cdn_managed_https {
    certificate_type = "Dedicated"
    protocol_type    = "ServerNameIndication"
    tls_version      = "TLS12"
  }
}