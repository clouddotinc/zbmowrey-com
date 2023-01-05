app_name               = "zbmowrey-com"
owner_name             = "zbmowrey"
root_domain            = "zbmowrey.com"
primary_region         = "us-east-2"
secondary_region       = "us-east-1"
web_primary_bucket     = "web-primary"
web_secondary_bucket   = "web-secondary"
web_log_bucket         = "web-log"
create_api_domain_name = false

vpc_cidr               = "10.0.0.0/16"
vpc_availability_zones = ["us-east-2a", "us-east-2b"]
vpc_private_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
vpc_public_subnets     = ["10.0.3.0/24", "10.0.4.0/24"]

