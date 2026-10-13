locals {
  name_prefix             = "${var.project_name}-${var.environment}"
  common_labels           = merge(var.labels, { project_name = var.project_name, environment = var.environment })
  web_service_full_name   = "${local.name_prefix}-${var.web_service_name}"
  mcp_service_full_name   = "${local.name_prefix}-${var.mcp_service_name}"
  web_service_account_id  = "${local.name_prefix}-${var.web_service_account_name}"
  mcp_service_account_id  = "${local.name_prefix}-${var.mcp_service_account_name}"
  artifact_repository_id  = "${local.name_prefix}-${var.artifact_registry_repository_name}"
  documentation_bucket_id = "${local.name_prefix}-${var.documentation_bucket_name}"
}
