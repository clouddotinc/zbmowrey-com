terraform {
  backend "remote" {
    organization = "zbmowrey"

    workspaces {
      prefix = "zbmowrey-com-"
    }
  }
}

# Testing trigger