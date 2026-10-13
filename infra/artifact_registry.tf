module "artifact_registry" {
  source = "./modules/artifact_registry"

  project_id        = var.project_id
  region            = var.region
  repository_id     = local.artifact_repository_id
  description       = "Artifact Registry for ${local.name_prefix}"
  labels            = local.common_labels
  keep_count        = var.artifact_keep_count
  delete_older_than = var.artifact_delete_older_than

  depends_on = [module.project_services]
}
