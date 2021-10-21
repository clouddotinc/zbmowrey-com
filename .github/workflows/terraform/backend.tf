terraform {
  backend "remote" {
    organization = "zbmowrey-aws"

    workspaces {
      prefix = "zbmowrey-com-web-"
    }
  }
}