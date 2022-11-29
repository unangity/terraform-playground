resource "google_compute_instance_template" "paas_template" {
  name_prefix  = "paas-monitor-"
  description  = "This template is used to create paas-monitor VM instances."
  machine_type = "g1-small"
  tags         = google_compute_firewall.default_allow_alt_http.target_tags

  disk {
    source_image = "cos-cloud/cos-101-lts"
    auto_delete  = true
    boot         = true
  }
  network_interface {
    network = "default"
    access_config {
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  metadata = {
    user-data = data.cloudinit_config.conf.rendered
  }
}

resource "google_compute_region_instance_group_manager" "paas_group_manager" {
  name = "paas-group-manager"
  version {
    instance_template = google_compute_instance_template.paas_template.id
  }
  base_instance_name = "paas-group-manager"
  target_size        = "3"

  for_each = local.regions
  region   = each.key

  named_port {
    name = local.port.name
    port = local.port.number
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.health_checker.id
    initial_delay_sec = 60
  }
}

moved {
  to   = google_compute_region_instance_group_manager.paas_group_manager[local.defaults.region]
  from = google_compute_region_instance_group_manager.paas_group_manager
}