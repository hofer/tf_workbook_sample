variable "resource_group_name" {
  description = "The resource group name from which we will create another RG."
  type        = string
}

variable "workbook_source_id" {
  type        = string
  description = "Workbook source id"
}

variable "workbook_content" {
  type        = string
  description = "Workbook content as json"
}

variable "workbook_name" {
  type        = string
  description = "Workbook name as displayed in the azure portal"
}

variable "location" {
  type        = string
  default     = "West Europe"
  description = "Location where we store this workbook."
}

variable "azure_tags" {
  type        = map
  description = "Azure tags to be set on this workbook."
}
