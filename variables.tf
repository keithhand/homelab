variable "credentials" {
  type = object({
    unifi = object({
      username = string
      password = string
      api_url  = string
    })
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
}
