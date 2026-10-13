variable "project_id" {
  description = "GCP project ID."
  type        = string
  validation {
    condition     = trimspace(var.project_id) != ""
    error_message = "project_id no puede estar vacío."
  }
}

variable "project_name" {
  description = "Logical project name used in naming convention."
  type        = string
  validation {
    condition     = trimspace(var.project_name) != ""
    error_message = "project_name no puede estar vacío."
  }
}

variable "environment" {
  description = "Deployment environment, e.g. prod."
  type        = string
  validation {
    condition     = trimspace(var.environment) != ""
    error_message = "environment no puede estar vacío."
  }
}

variable "region" {
  description = "GCP region for regional resources."
  type        = string
  validation {
    condition     = trimspace(var.region) != ""
    error_message = "region no puede estar vacío."
  }
}

variable "labels" {
  description = "Common labels for resources."
  type        = map(string)
}

variable "allowed_emails" {
  description = "Allowed user emails for app-level access control."
  type        = list(string)
  validation {
    condition = alltrue([
      for email in var.allowed_emails : can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", email))
    ])
    error_message = "allowed_emails debe contener correos con formato básico válido."
  }
}

variable "domain_name" {
  description = "Custom domain reserved for future use."
  type        = string
}

variable "web_service_name" {
  description = "Suffix for WEB Cloud Run service name."
  type        = string
}

variable "mcp_service_name" {
  description = "Suffix for MCP Cloud Run service name."
  type        = string
}

variable "web_service_account_name" {
  description = "Suffix for WEB service account ID."
  type        = string
}

variable "mcp_service_account_name" {
  description = "Suffix for MCP service account ID."
  type        = string
}

variable "artifact_registry_repository_name" {
  description = "Suffix for Artifact Registry repository ID."
  type        = string
}

variable "documentation_bucket_name" {
  description = "Suffix for private documentation bucket name."
  type        = string
}

variable "web_image" {
  description = "Container image reference for WEB service."
  type        = string
}

variable "mcp_image" {
  description = "Container image reference for MCP service."
  type        = string
}

variable "web_cpu" {
  description = "CPU limit for WEB container."
  type        = string
}

variable "web_memory" {
  description = "Memory limit for WEB container."
  type        = string
}

variable "web_min_instances" {
  description = "Minimum number of WEB instances."
  type        = number
  validation {
    condition     = var.web_min_instances >= 0
    error_message = "web_min_instances debe ser >= 0."
  }
}

variable "web_max_instances" {
  description = "Maximum number of WEB instances."
  type        = number
  validation {
    condition     = var.web_max_instances >= var.web_min_instances
    error_message = "web_max_instances debe ser >= web_min_instances."
  }
}

variable "mcp_cpu" {
  description = "CPU limit for MCP container."
  type        = string
}

variable "mcp_memory" {
  description = "Memory limit for MCP container."
  type        = string
}

variable "mcp_min_instances" {
  description = "Minimum number of MCP instances."
  type        = number
  validation {
    condition     = var.mcp_min_instances >= 0
    error_message = "mcp_min_instances debe ser >= 0."
  }
}

variable "mcp_max_instances" {
  description = "Maximum number of MCP instances."
  type        = number
  validation {
    condition     = var.mcp_max_instances >= var.mcp_min_instances
    error_message = "mcp_max_instances debe ser >= mcp_min_instances."
  }
}

variable "web_container_port" {
  description = "Container port for WEB service."
  type        = number
}

variable "mcp_container_port" {
  description = "Container port for MCP service."
  type        = number
}

variable "gemini_model" {
  description = "Vertex AI Gemini model to use from WEB service."
  type        = string
}

variable "google_cloud_location" {
  description = "Google Cloud location for Vertex AI requests."
  type        = string
}

variable "llm_provider" {
  description = "LLM provider identifier used by WEB application."
  type        = string
}

variable "project_services" {
  description = "List of GCP APIs/services to enable."
  type        = list(string)
}

variable "documentation_prefix" {
  description = "Optional prefix path consumed by MCP in bucket."
  type        = string
  default     = "documentation/"
}

variable "mcp_timeout_ms" {
  description = "Timeout in milliseconds for MCP requests from WEB."
  type        = number
  default     = 30000
}

variable "max_tool_iterations" {
  description = "Max MCP tool call iterations from WEB service."
  type        = number
  default     = 10
}

variable "web_ingress" {
  description = "Ingress setting for WEB Cloud Run service."
  type        = string
  default     = "INGRESS_TRAFFIC_ALL"
}

variable "mcp_ingress" {
  description = "Ingress setting for MCP Cloud Run service."
  type        = string
  default     = "INGRESS_TRAFFIC_ALL"
}

variable "web_timeout_seconds" {
  description = "Request timeout in seconds for WEB service."
  type        = number
  default     = 300
}

variable "mcp_timeout_seconds" {
  description = "Request timeout in seconds for MCP service."
  type        = number
  default     = 300
}

variable "web_concurrency" {
  description = "Max request concurrency for WEB service."
  type        = number
  default     = 80
}

variable "mcp_concurrency" {
  description = "Max request concurrency for MCP service."
  type        = number
  default     = 80
}

variable "artifact_keep_count" {
  description = "How many recent images to keep in Artifact Registry cleanup policy."
  type        = number
  default     = 10
}

variable "artifact_delete_older_than" {
  description = "Delete images older than this duration (e.g., 2592000s for 30 days)."
  type        = string
  default     = "2592000s"
}

variable "cloud_run_deletion_protection" {
  description = "Enable/disable Cloud Run deletion protection."
  type        = bool
  default     = false
}

variable "documentation_bucket_force_destroy" {
  description = "Whether to force destroy bucket even if it contains objects."
  type        = bool
  default     = false
}
