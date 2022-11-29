resource "google_compute_global_address" "paas-monitor" {
  name = "paas-monitor"
}

resource "google_compute_global_forwarding_rule" "paas-monitor" {
  name       = "paas-monitor-port-${local.port.number}"
  ip_address = google_compute_global_address.paas-monitor.address
  port_range = local.port.number
  target     = google_compute_target_http_proxy.paas-monitor.self_link
}

resource "google_compute_target_http_proxy" "paas-monitor" {
  name    = "paas-monitor"
  url_map = google_compute_url_map.paas-monitor.self_link
}

resource "google_compute_url_map" "paas-monitor" {
  name            = "paas-monitor"
  default_service = google_compute_backend_service.paas-monitor.self_link
}

resource "google_compute_backend_service" "paas-monitor" {
  name             = "paas-monitor-backend"
  protocol         = "HTTP"
  port_name        = local.port.name
  timeout_sec      = 10
  session_affinity = "NONE"

  dynamic "backend" {
    for_each = local.regions
    content {
      group = google_compute_region_instance_group_manager.paas_group_manager[backend.key].instance_group
    }
  }

  health_checks = [google_compute_health_check.health_checker.id]
}

