variable "app_name" {
  type    = string
  default = "zbmowrey-com"
}
variable "owner_name" {
  type = string
  default = "zbmowrey"
}
variable "root_domain" {
  type    = string
  default = "zbmowrey.com"
}
variable "primary_region" {
  type    = string
  default = "us-east-2"
}
variable "secondary_region" {
  type    = string
  default = "us-east-1"
}
variable "web_primary_bucket" {
  type    = string
  default = "web-primary"
}
variable "web_secondary_bucket" {
  type    = string
  default = "web-secondary"
}
variable "web_log_bucket" {
  type    = string
  default = "web-log"
}
variable "aaaa_records" {
  type = map(string)
  default = {}
}
variable "mx_records" {
  type = map(list(string))
  default = {}
}
variable "cname_records" {
  type = map(string)
  default = {}
}
variable "txt_records" {
  type = map(list(string))
  default = {}
}
variable "ns_records" {
  type = map(list(string))
  default = {}
}
variable "create_api_domain_name" {
  type    = bool
  default = true
}

variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/8"
}
variable "vpc_availability_zones" {
  type = list(string)
  default = []
}
variable "vpc_private_subnets" {
  type = list(string)
  default = []
}
variable "vpc_public_subnets" {
  type = list(string)
  default = []
}

