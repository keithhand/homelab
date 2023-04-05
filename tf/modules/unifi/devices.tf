data "unifi_port_profile" "all" {}

data "unifi_port_profile" "disabled" {
  name = "Disabled"
}

data "unifi_port_profile" "lan" {
  name = unifi_network.lan.name
}

data "unifi_port_profile" "iot" {
  name = unifi_network.iot.name
}

data "unifi_port_profile" "gaming" {
  name = unifi_network.gaming.name
}

resource "unifi_port_profile" "kubernetes" {
  name = "Kubernetes"
  forward = "customize"
  native_networkconf_id = unifi_network.kubernetes_nodes.id
  tagged_networkconf_ids = [unifi_network.kubernetes_pods.id]
  poe_mode = "off"
}

locals {
  ports = {
    defaults = {
      name = ""
      port_profile_id = data.unifi_port_profile.disabled.id
    }
    udm_pro = {
      5 = {
        name = "odroid"
        port_profile_id = unifi_port_profile.kubernetes.id
      }
      6 = {
        name = "desktop"
        port_profile_id = data.unifi_port_profile.lan.id
      }
      7 = {
        name = "rpi"
        port_profile_id = unifi_port_profile.kubernetes.id
      }
      8 = {
        name = "usw_48_poe"
        port_profile_id = data.unifi_port_profile.all.id
      }
      9 = {
        port_profile_id = data.unifi_port_profile.all.id
      }
    }
    usw_48_poe = {
      1 = {
        name = "u6_pro"
        port_profile_id = data.unifi_port_profile.all.id
      }
      3 = {
        name = "u6_iw"
        port_profile_id = data.unifi_port_profile.all.id
      }
      41 = {
        name = "sonos office"
        port_profile_id = data.unifi_port_profile.iot.id
      }
      43 = {
        name = "udm_pro"
        port_profile_id = data.unifi_port_profile.all.id
      }
    }
    u6_iw = {
      4 = {
        name = "steamdeck"
        port_profile_id = data.unifi_port_profile.gaming.id
      }
    }
  }
}

# UDM
resource "unifi_device" "udm_pro" {
  name = "UDM-Pro"
  forget_on_destroy = false
  # allow_adoption = true

  dynamic "port_override" {
    for_each = [ for port_number in range(1, 12) : lookup(local.ports.udm_pro, port_number, null) != null ? local.ports.udm_pro[port_number] : null ]
    content {
      number = port_override.key + 1
      name = port_override.value != null ? lookup(port_override.value, "name", local.ports.defaults.name) : local.ports.defaults.name
      port_profile_id = port_override.value != null ? lookup(port_override.value, "port_profile_id", local.ports.defaults.port_profile_id) : local.ports.defaults.port_profile_id
    }
  }
}

# Switch
resource "unifi_device" "usw_48_poe" {
  name = "usw-48-poe"
  forget_on_destroy = false
  # allow_adoption = true

  dynamic "port_override" {
    for_each = [ for port_number in range(1, 53) : lookup(local.ports.usw_48_poe, port_number, null) != null ? local.ports.usw_48_poe[port_number] : null ]
    content {
      number = port_override.key + 1
      name = port_override.value != null ? lookup(port_override.value, "name", local.ports.defaults.name) : local.ports.defaults.name
      port_profile_id = port_override.value != null ? lookup(port_override.value, "port_profile_id", local.ports.defaults.port_profile_id) : local.ports.defaults.port_profile_id
    }
  }
}

# APs
resource "unifi_device" "u6_iw" {
  name = "U6-IW"
  forget_on_destroy = false
  # allow_adoption = true

  dynamic "port_override" {
    for_each = [ for port_number in range(1, 5) : lookup(local.ports.u6_iw, port_number, null) != null ? local.ports.u6_iw[port_number] : null ]
    content {
      number = port_override.key + 1
      name = port_override.value != null ? lookup(port_override.value, "name", local.ports.defaults.name) : local.ports.defaults.name
      port_profile_id = port_override.value != null ? lookup(port_override.value, "port_profile_id", local.ports.defaults.port_profile_id) : local.ports.defaults.port_profile_id
    }
  }
}

resource "unifi_device" "u6_pro" {
  name = "U6-Pro"
  forget_on_destroy = false
  # allow_adoption = true
}
