variable "terraform_state_bucket" {
  type    = string
  default = "ccf-terraform-s3"
}

variable "default_region" {
  type    = string
  default = "ap-southeast-1"
}

variable "vpc_id" {
  type    = string
  default = "vpc-0443f170176b8d5c9"
}

variable "ami_id" {
  type    = string
  # changed to use GT_GCCS_StandardBuild_AML_2_on_2023-07-27_07.35.39	
  default   = "ami-091bf934ebedd746d"
  # changed to use AWS-ECS optomized AMI, which has Docker pre-installed
  # default = "ami-0d2ffabfbd38ccd28" 
  # default = "ami-006dcf34c09e50022" # Amazon Linux AMI 2. This changes based on your AWS region.
}

variable "instance_type" {
  type    = string
  default = "t2.medium"
}

variable "key_name" {
  type    = string
  default = "govtechccf"
}

variable "private_subnet_id" {
  type    = string
  default = "subnet-07e40329d59a19a19"
}

# If you have a security group that allows inbound traffic to connections coming from within a VPN
# variable "vpn_security_group_id" {
#   type    = string
#   default = "sg-0242af538df9912f3"
# }

variable "application" {
  type    = string
  default = "ccf-terraform"
}

variable "environment" {
  type    = string
  default = "prod"
}

# variable "dns_name" {
#   type    = string
#   default = "ccftest.net"
# }

# This might be useful if you wanna restrict traffic to private subnets
# variable "allowed_cidr_blocks" {
#   type    = list(string)
#   default = ["10.0.128.0/20", "10.0.144.0/20"]
# }
