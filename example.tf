resource "azurerm_log_analytics_workspace" "main" {
  name                = "my_log_analytics_workspace"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}


module "workbook" {
  source = "./module"
  resource_group_name = azurerm_resource_group.main.name

  // Copy the notebook from the azure portal: Edit -> Advancecd Editor (Icon in Menu) -> Gallery Template.
  workbook_content = <<-EOT
{
    "version": "Notebook/1.0",
    "items": [
        {
            "type": 1,
            "content": {
                "json": "## test Workbook"
            },
            "name": "text - 2"
        }
    ],
    "isLocked": false,
    "fallbackResourceIds": []
}
  EOT
  workbook_name      = "Test Workbook"
  workbook_source_id = azurerm_log_analytics_workspace.main.id
  azure_tags         = var.tags
  location           = var.location
}

