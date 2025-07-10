module "instance" {
  source        = "../modules/compute_instance"
  instance_name = "my-vm"
  machine_type  = "e2-medium"
  zone          = var.zone
  image         = "debian-cloud/debian-12"
  tags          = ["web", "dev"]
}

module "bucket1" {
  source   = "../modules/gcs_bucket"
  name     = "aish-bucket-1-${var.project}"
  location = "US"
}

module "bucket2" {
  source   = "../modules/gcs_bucket"
  name     = "aish-bucket-2-${var.project}"
  location = "US"
}

module "redis_monitoring" {
  source            = "../modules/redis_monitoring"
  project_id        = var.project
  redis_instance_id = module.redis_instance.instance_id
  environment       = "dev"
  region            = "us-central1"

}

module "redis_instance" {
  source         = "../modules/redis_instance"
  name           = "dev-redis-instance"
  region         = "us-central1"
  tier           = "STANDARD_HA"
  memory_size_gb = 1
  display_name   = "Dev Redis"
}
