# Unfortunately a workbook needs to be deployed in its own resource group.
resource "azurerm_resource_group" "main" {
  name     = "${var.resource_group_name}-wb"
  location = var.location
  tags     = var.azure_tags
}

resource "random_uuid" "workbook_id" {}

resource "azurerm_template_deployment" "workbook_template" {
  name                = "wb-${random_uuid.workbook_id.result}"
  resource_group_name = azurerm_resource_group.main.name
  template_body       = <<DEPLOY
{
  "contentVersion": "1.0.0.0",
  "parameters": {
    "workbookDisplayName": {
      "type": "string",
      "defaultValue": "Runner Overview",
      "metadata": {
        "description": "The friendly name for the workbook that is used in the Gallery or Saved List.  This name must be unique within a resource group."
      }
    },
    "workbookType": {
      "type": "string",
      "defaultValue": "workbook",
      "metadata": {
        "description": "The gallery that the workbook will been shown under. Supported values include workbook, tsg, etc. Usually, this is 'workbook'"
      }
    },
    "workbookSourceId": {
      "type": "string",
      "defaultValue": "",
      "metadata": {
        "description": "The id of resource instance to which the workbook will be associated"
      }
    },
    "workbookId": {
      "type": "string",
      "defaultValue": "[newGuid()]",
      "metadata": {
        "description": "The unique guid for this workbook instance"
      }
    },
    "workbookContent": {
      "type": "string",
      "defaultValue": "",
      "metadata": {
        "description": "The unique guid for this workbook instance"
      }
    }
  },
  "resources": [
    {
      "name": "[parameters('workbookId')]",
      "type": "microsoft.insights/workbooks",
      "location": "[resourceGroup().location]",
      "apiVersion": "2018-06-17-preview",
      "dependsOn": [],
      "kind": "shared",
      "properties": {
        "displayName": "[parameters('workbookDisplayName')]",
        "serializedData": "[parameters('workbookContent')]",
        "version": "1.0",
        "sourceId": "[parameters('workbookSourceId')]",
        "category": "[parameters('workbookType')]"
      }
    }
  ],
  "outputs": {
    "workbookId": {
      "type": "string",
      "value": "[resourceId( 'microsoft.insights/workbooks', parameters('workbookId'))]"
    }
  },
  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#"
}
DEPLOY

  parameters = {
    "workbookDisplayName" = var.workbook_name
    "workbookId"          = random_uuid.workbook_id.result
    "workbookContent"     = var.workbook_content
    "workbookSourceId"    = var.workbook_source_id
  }

  deployment_mode = "Incremental"
}
