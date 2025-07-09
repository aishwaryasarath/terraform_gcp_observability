resource "google_storage_bucket" "default" {
  name          = var.name
  location      = var.location
  force_destroy = true
}
