module "documentation_web" {
  source = "./modules/cloud_run"

  project_id            = var.project_id
  region                = var.region
  service_name          = local.web_service_full_name
  image                 = var.web_image
  service_account_email = module.web_service_account.email
  container_port        = var.web_container_port
  cpu                   = var.web_cpu
  memory                = var.web_memory
  min_instances         = var.web_min_instances
  max_instances         = var.web_max_instances
  labels                = local.common_labels
  allow_unauthenticated = true
  deletion_protection   = var.cloud_run_deletion_protection
  ingress               = var.web_ingress
  timeout_seconds       = var.web_timeout_seconds
  concurrency           = var.web_concurrency
  environment_variables = {
    MCP_SERVER_URL        = "${module.documentation_mcp.uri}/mcp"
    LLM_PROVIDER          = var.llm_provider
    GOOGLE_CLOUD_PROJECT  = var.project_id
    GOOGLE_CLOUD_LOCATION = var.google_cloud_location
    GEMINI_MODEL          = var.gemini_model
    MAX_TOOL_ITERATIONS   = tostring(var.max_tool_iterations)
    MCP_TIMEOUT_MS        = tostring(var.mcp_timeout_ms)
    ALLOWED_EMAILS        = join(",", var.allowed_emails)
  }

  depends_on = [module.project_services, module.documentation_mcp]
}
