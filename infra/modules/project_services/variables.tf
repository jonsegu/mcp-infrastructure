variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "services" {
  description = "List of services/APIs to enable."
  type        = list(string)
}

variable "disable_on_destroy" {
  description = "Disable API when Terraform resource is destroyed."
  type        = bool
  default     = false
}

variable "disable_dependent_services" {
  description = "Disable dependent services when disabling this API."
  type        = bool
  default     = false
}
