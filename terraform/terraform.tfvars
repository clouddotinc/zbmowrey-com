# App Environment

app_name    = "zbmowrey-com"
owner_name  = "zbmowrey"
environment = "local-zach"
root_domain = "zbmowrey.com"

# AWS Region

primary_region   = "us-east-2"
secondary_region = "us-east-1"

# Web Buckets

web_primary_bucket   = "web-primary"
web_secondary_bucket = "web-secondary"
web_log_bucket       = "web-log"

# 2 availability zones. A public & private subnet for each.
# All subnets offer 1022 hosts.

vpc_cidr               = "10.0.0.0/20"
vpc_availability_zones = ["us-east-1a", "us-east-1b"]
vpc_private_subnets    = ["10.0.0.0/22", "10.0.4.0/22"]
vpc_public_subnets     = ["10.0.8.0/22", "10.0.12.0/22"]

