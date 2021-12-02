terraform {
  required_version = ">= 1.0.3"

  required_providers {
    aws = {
      version = "~> 3.6"
    }
    random = ">= 2"
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = var.environment
  default_tags {
    tags = {
      CostCenter  = var.app_name
      Owner       = var.owner_name
      Environment = var.environment
      Source      = "https://github.com/zbmowrey/zbmowrey-com/tree/develop/terraform"
      Terraform   = true
    }
  }
}

provider "aws" {
  alias   = "primary"
  region  = var.primary_region
  profile = var.environment
  default_tags {
    tags = {
      CostCenter  = var.app_name
      Owner       = var.owner_name
      Environment = var.environment
      Terraform   = true
    }
  }
}

provider "aws" {
  alias   = "secondary"
  region  = var.secondary_region
  profile = var.environment
  default_tags {
    tags = {
      CostCenter  = var.app_name
      Owner       = var.owner_name
      Environment = var.environment
      Terraform   = true
    }
  }
}