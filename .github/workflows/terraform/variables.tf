variable "app_name" {
  type    = string
  default = "zbmowrey-com"
}
variable "owner_name" {
  type = string
}
variable "environment" {
  type    = string
  default = "develop"
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
  default = "zbmowrey-com-web-primary"
}
variable "web_secondary_bucket" {
  type    = string
  default = "zbmowrey-com-web-secondary"
}
variable "web_log_bucket" {
  type    = string
  default = "zbmowrey-com-web-log"
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
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
variable "vpc_availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}
variable "vpc_private_subnets" {
  type    = list(string)
  default = ["10.0.0.0/18", "10.0.64.0/18"]
}
variable "vpc_public_subnets" {
  type    = list(string)
  default = ["10.0.128.0/18", "10.0.192.0/18"]
}
variable "create_api_domain_name" {
  type    = bool
  default = true
}