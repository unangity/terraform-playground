provider "google" {
  credentials = file("servce-key.json")

  project = "iunang-xccelerated-cicd"
  region  = "europe-west4"
  zone    = "europe-west4-a"
}