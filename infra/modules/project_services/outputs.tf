output "enabled_services" {
  description = "Enabled project services."
  value       = [for service in google_project_service.this : service.service]
}
