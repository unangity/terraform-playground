resource "google_compute_health_check" "health_checker" {
  name = "health-checker"

  timeout_sec         = 5
  check_interval_sec  = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10

  http_health_check {
    port         = local.port.number
    request_path = "/health"
    response     = "ok"
  }
}

resource "google_compute_firewall" "default_allow_alt_http" {
  name    = "default-allow-${local.port.name}"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", local.port.number]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${local.port.name}-server"]
}