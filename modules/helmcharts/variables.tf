variable "name" {
  type = string
}

variable "namespace" {
  type = object({
    management = string
    target = string
  })
}

variable "chart" {
  type = object({
    name = string
    repo = string
  })
}

variable "values" {
  default = {}
}
