variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "platform-capstone"
}

variable "ami" { type = string }

variable "app_vpc_id" { type = string }
variable "obs_vpc_id" { type = string }
variable "router_vpc_id" { type = string }

variable "app_public_subnet" { type = string }
variable "app_private_1" { type = string }
variable "app_private_2" { type = string }

variable "obs_public_subnet" { type = string }
variable "obs_private_subnet" { type = string }

variable "router_public_subnet" { type = string }
