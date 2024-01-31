terraform {
  backend "local" {
    workspace_dir = "/home/meshcloud/states"
  }


  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = "3.27.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  # tenant_id, client_id and client_secret must be set via env variables
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
}

variable "subscription_id" {
  description = "Subscription ID of the subscription the resource group shall be created in."
  type        = string
}

variable "rg_name" {
  description = "Name of the resource group to be created."
  type        = string
}

variable "location" {
  description = "Location of the resource group"
  type        = string
  default     = "WestEurope"
}

resource "azurerm_resource_group" "test-rg" {
  name     = "${local.rg-name}"
  location = var.location

  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, as tags are managed by meshStack and policies
      tags
    ]
  }
}
