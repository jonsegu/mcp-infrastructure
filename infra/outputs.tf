output "project_id" {
  description = "GCP project ID."
  value       = var.project_id
}

output "region" {
  description = "GCP region used by Cloud Run services."
  value       = var.region
}

output "web_service_name" {
  description = "Deployed WEB Cloud Run service name."
  value       = module.documentation_web.service_name
}

output "web_service_url" {
  description = "WEB Cloud Run URL."
  value       = module.documentation_web.uri
}

output "mcp_service_name" {
  description = "Deployed MCP Cloud Run service name."
  value       = module.documentation_mcp.service_name
}

output "mcp_service_url" {
  description = "MCP Cloud Run URL."
  value       = module.documentation_mcp.uri
}

output "documentation_bucket_name" {
  description = "Private documentation bucket name."
  value       = module.documentation_bucket.bucket_name
}

output "artifact_registry_repository" {
  description = "Artifact Registry repository URL."
  value       = module.artifact_registry.repository_url
}

output "web_service_account_email" {
  description = "WEB service account email."
  value       = module.web_service_account.email
}

output "mcp_service_account_email" {
  description = "MCP service account email."
  value       = module.mcp_service_account.email
}
