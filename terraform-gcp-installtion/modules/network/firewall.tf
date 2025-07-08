resource "google_compute_firewall" "allow_jenkins_docker_pg" {
  name    = "allow-custom-ports"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443", "8080", "5432"]
  }

  source_ranges = ["0.0.0.0/0"]  # Allow from anywhere (can restrict if needed)
  direction     = "INGRESS"
  target_tags   = ["allow-custom-ports"]
}
