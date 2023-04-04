variable "username" {
  type = string
}

variable "password" {
  type = string
}

variable "api_url" {
  type = string
}

variable "insecure" {
  type = bool
}

variable "wifi_credentials" {
  type = object({
    lan = string
    iot = string
    gaming = string
    guest = string
  })
}
