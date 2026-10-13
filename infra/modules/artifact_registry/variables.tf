variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "region" {
  description = "GCP region for Artifact Registry repository."
  type        = string
}

variable "repository_id" {
  description = "Artifact Registry repository ID."
  type        = string
}

variable "description" {
  description = "Repository description."
  type        = string
}

variable "labels" {
  description = "Labels for repository."
  type        = map(string)
}

variable "keep_count" {
  description = "How many recent images to keep."
  type        = number
  default     = 10
}

variable "delete_older_than" {
  description = "Delete images older than this duration, e.g. 2592000s."
  type        = string
  default     = "2592000s"
}
