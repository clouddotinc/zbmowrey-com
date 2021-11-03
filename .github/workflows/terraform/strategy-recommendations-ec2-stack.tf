# Lesson learned here is that we use Modules when they can offer some extended
# functionality. For example, providing a standard template for some set of
# resources, or adding more logic. Modules that act as resource wrappers with
# no extra goodies? We avoid those.

#module "vpc" {
#  providers = {
#    aws = aws.secondary
#  }
#
#  source = "terraform-aws-modules/vpc/aws"
#
#  name = "${var.app_name}-vpc"
#  cidr = var.vpc_cidr
#
#  azs             = var.vpc_availability_zones
#  private_subnets = var.vpc_private_subnets
#  public_subnets  = var.vpc_public_subnets
#
#  enable_nat_gateway = false
#  enable_vpn_gateway = false
#
#  tags = {
#    Environment = terraform.workspace
#    CostCenter = var.app_name
#  }
#}
#
#module "ec2_instance" {
#  providers = {
#    aws = aws.secondary
#  }
#  source  = "terraform-aws-modules/ec2-instance/aws"
#  version = "~> 3.2"
#
#  for_each = toset(["one", "two", "three"])
#
#  name = "instance-${each.key}"
#
#  ami                    = "ami-07238f13cc6b12f3b"
#  instance_type          = "t3.medium"
#  key_name               = terraform.workspace
#  monitoring             = true
#  vpc_security_group_ids = [aws_security_group.allow_tls.id]
#  subnet_id              = element(module.vpc.private_subnets, 0)
#
#  user_data = <<EOF
#		#! /bin/bash
#        sudo echo "Zbec213!" | passwd --stdin ec2-user
#	EOF
#
#  tags = {
#    Terraform   = "true"
#    Environment = "dev"
#  }
#}
#resource "aws_security_group" "allow_tls" {
#  provider = aws.secondary
#  name        = "allow_tls"
#  description = "Allow TLS inbound traffic"
#  vpc_id      = module.vpc.vpc_id
#
#  ingress = [
#    {
#      description      = "TLS from VPC"
#      from_port        = 443
#      to_port          = 443
#      protocol         = "tcp"
#      cidr_blocks      = [module.vpc.vpc_cidr_block]
#      ipv6_cidr_blocks = ["::/0"]
#      prefix_list_ids  = []
#      security_groups  = []
#      self             = false
#    }
#  ]
#
#  egress = [
#    {
#      description      = "Allow anything out"
#      from_port        = 0
#      to_port          = 0
#      protocol         = "-1"
#      cidr_blocks      = ["0.0.0.0/0"]
#      ipv6_cidr_blocks = ["::/0"]
#      prefix_list_ids  = []
#      security_groups  = []
#      self             = false
#    }
#  ]
#
#  tags = {
#    Name = "allow_tls"
#  }
#}