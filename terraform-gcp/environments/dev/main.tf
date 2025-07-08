module "network" {
  source        = "../../modules/network"
  network_name  = "test"
  subnet_name   = "demo-subnet"
  subnet_range  = "10.0.1.0/24"
  region        = var.region
}

module "compute" {
  source        = "../../modules/compute"
  name          = "testdev"
  machine_type  = "e2-standard-4"
  zone          = var.zone
  image = "ubuntu-os-cloud/ubuntu-minimal-2404-lts"
  network       = module.network.network_self_link
  subnetwork    = module.network.network_self_link
}