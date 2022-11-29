provider "google" {
  credentials = file(local.servicekey-file)

  project = local.defaults.project
  region  = local.defaults.region
  zone    = local.defaults.zone
}