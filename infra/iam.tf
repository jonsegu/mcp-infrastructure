resource "google_cloud_run_v2_service_iam_member" "web_can_invoke_mcp" {
  project  = var.project_id
  location = var.region
  name     = module.documentation_mcp.service_name
  role     = "roles/run.invoker"
  member   = module.web_service_account.member
}

resource "google_project_iam_member" "web_vertex_ai_user" {
  project = var.project_id
  role    = "roles/aiplatform.user"
  member  = module.web_service_account.member
}

resource "google_storage_bucket_iam_member" "mcp_bucket_object_viewer" {
  bucket = module.documentation_bucket.bucket_name
  role   = "roles/storage.objectViewer"
  member = module.mcp_service_account.member
}
