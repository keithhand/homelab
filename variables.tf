variable "unifi-creds" {
  type = object({
    username = string
    password = string
    api_url  = string
  })
  sensitive = true
}

variable "unifi" {
  type = object({
    network = object({
      base_subnet = string
      networks = map(object({
        vlan_id       = number
        purpose       = optional(string)
        igmp_snooping = optional(bool)
        multicast_dns = optional(bool)
      }))
    })
  })
  default = {
    network = {
      base_subnet = "10.0.X.1"
      networks = {
        home = {
          vlan_id = 39
          purpose = "corporate"
        }
        guest = {
          vlan_id = 69
          purpose = "guest"
        }
        iot = {
          purpose = "corporate"
          vlan_id = 10
        }
        sonos = {
          purpose       = "corporate"
          vlan_id       = 11
          igmp_snooping = true
          multicast_dns = true
        }
      }
    }
  }
}
