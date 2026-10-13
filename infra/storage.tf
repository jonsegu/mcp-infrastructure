module "documentation_bucket" {
  source = "./modules/storage_bucket"

  project_id    = var.project_id
  bucket_name   = local.documentation_bucket_id
  location      = var.region
  labels        = local.common_labels
  force_destroy = var.documentation_bucket_force_destroy

  depends_on = [module.project_services]
}
