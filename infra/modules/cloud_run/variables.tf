variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "region" {
  description = "GCP region for Cloud Run service."
  type        = string
}

variable "service_name" {
  description = "Cloud Run service name."
  type        = string
}

variable "image" {
  description = "Container image reference."
  type        = string
}

variable "container_port" {
  description = "Container listening port."
  type        = number
}

variable "service_account_email" {
  description = "Service account email attached to Cloud Run revision."
  type        = string
}

variable "cpu" {
  description = "Container CPU limit."
  type        = string
}

variable "memory" {
  description = "Container memory limit."
  type        = string
}

variable "min_instances" {
  description = "Minimum running instances."
  type        = number
  validation {
    condition     = var.min_instances >= 0
    error_message = "min_instances debe ser >= 0."
  }
}

variable "max_instances" {
  description = "Maximum running instances."
  type        = number
  validation {
    condition     = var.max_instances >= var.min_instances
    error_message = "max_instances debe ser >= min_instances."
  }
}

variable "environment_variables" {
  description = "Environment variables for the container."
  type        = map(string)
  default     = {}
}

variable "labels" {
  description = "Labels for service resources."
  type        = map(string)
}

variable "allow_unauthenticated" {
  description = "If true, grants run.invoker to allUsers."
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Enable/disable Cloud Run deletion protection."
  type        = bool
  default     = false
}

variable "ingress" {
  description = "Cloud Run ingress setting."
  type        = string
  default     = "INGRESS_TRAFFIC_ALL"
}

variable "timeout_seconds" {
  description = "Request timeout in seconds."
  type        = number
  default     = 300
}

variable "concurrency" {
  description = "Max concurrent requests per instance."
  type        = number
  default     = 80
}
