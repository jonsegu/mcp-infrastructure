module "documentation_mcp" {
  source = "./modules/cloud_run"

  project_id            = var.project_id
  region                = var.region
  service_name          = local.mcp_service_full_name
  image                 = var.mcp_image
  service_account_email = module.mcp_service_account.email
  container_port        = var.mcp_container_port
  cpu                   = var.mcp_cpu
  memory                = var.mcp_memory
  min_instances         = var.mcp_min_instances
  max_instances         = var.mcp_max_instances
  labels                = local.common_labels
  allow_unauthenticated = false
  deletion_protection   = var.cloud_run_deletion_protection
  ingress               = var.mcp_ingress
  timeout_seconds       = var.mcp_timeout_seconds
  concurrency           = var.mcp_concurrency
  environment_variables = {
    DOCUMENTATION_BUCKET  = module.documentation_bucket.bucket_name
    DOCUMENTATION_PREFIX  = var.documentation_prefix
    GOOGLE_CLOUD_PROJECT  = var.project_id
    GOOGLE_CLOUD_LOCATION = var.google_cloud_location
  }

  depends_on = [module.project_services]
}
