module "web_service_account" {
  source = "./modules/service_account"

  project_id   = var.project_id
  account_id   = local.web_service_account_id
  display_name = "${local.name_prefix} WEB service account"
  description  = "Service account used by WEB Cloud Run service"
}

module "mcp_service_account" {
  source = "./modules/service_account"

  project_id   = var.project_id
  account_id   = local.mcp_service_account_id
  display_name = "${local.name_prefix} MCP service account"
  description  = "Service account used by MCP Cloud Run service"
}
