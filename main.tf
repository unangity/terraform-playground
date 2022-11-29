provider "google" {
  credentials = file(local.service-key)

  project = local.defaults.project
  region  = local.defaults.region
  zone    = local.defaults.zone
}