resource "google_compute_instance" "vm_instance" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  metadata_startup_script = file("${path.module}/../../scripts/startup.sh")

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    access_config {}
  }
}
