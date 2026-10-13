output "bucket_name" {
  description = "Bucket name."
  value       = google_storage_bucket.this.name
}

output "bucket_url" {
  description = "Bucket URL."
  value       = google_storage_bucket.this.url
}
