variable "name" {
  type = string
}

variable "purpose" {
  type    = string
  default = "corporate"
}

variable "vlan_id" {
  type = number
}

variable "subnet" {
  type = string
}

variable "igmp_snooping" {
  type    = bool
  default = false
}

variable "multicast_dns" {
  type    = bool
  default = false
}
