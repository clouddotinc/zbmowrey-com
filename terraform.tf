# This stays so I can call terraform plan/apply from the site root.

terraform {
  backend "remote" {
    organization = "zbmowrey"

    workspaces {
      prefix = "zbmowrey-com-"
    }
  }
}