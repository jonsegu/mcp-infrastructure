variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "bucket_name" {
  description = "Storage bucket name."
  type        = string
}

variable "location" {
  description = "Bucket location."
  type        = string
}

variable "labels" {
  description = "Labels for the bucket."
  type        = map(string)
}

variable "force_destroy" {
  description = "Whether to force destroy bucket with objects."
  type        = bool
  default     = false
}

variable "storage_class" {
  description = "Bucket storage class."
  type        = string
  default     = "STANDARD"
}
