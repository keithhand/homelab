variable "username" {
  type      = string
  sensitive = true
}

variable "password" {
  type      = string
  sensitive = true
}

variable "api_url" {
  type = string
}

variable "insecure" {
  type = bool
}

variable "network" {
  type = object({
    base_subnet = string
    networks = map(object({
      vlan_id       = number
      purpose       = string
      igmp_snooping = bool
      multicast_dns = bool
    }))
  })
}
