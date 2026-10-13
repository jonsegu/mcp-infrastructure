module "project_services" {
  source = "./modules/project_services"

  project_id                 = var.project_id
  services                   = var.project_services
  disable_on_destroy         = false
  disable_dependent_services = false
}
