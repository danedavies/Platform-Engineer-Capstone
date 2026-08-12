variable "project_name" {
  type        = string
  default     = "platform-capstone"
}

variable "ami" {
  type        = string
  description = "AMI ID for all EC2 instances"
}

############################################
# VPC IDs
############################################
variable "app_vpc_id" {
  type        = string
  description = "VPC ID for APP VPC"
}

variable "obs_vpc_id" {
  type        = string
  description = "VPC ID for OBSERVABILITY VPC"
}

variable "router_vpc_id" {
  type        = string
  description = "VPC ID for ROUTER VPC"
}

############################################
# APP VPC Subnets
############################################
variable "app_public_subnet" {
  type        = string
  description = "Public subnet for bastion"
}

variable "app_private_1" {
  type        = string
  description = "Private subnet for app instance 1"
}

variable "app_private_2" {
  type        = string
  description = "Private subnet for app instance 2"
}

############################################
# OBSERVABILITY VPC Subnets
############################################
variable "obs_public_subnet" {
  type        = string
  description = "Public subnet for Grafana"
}

variable "obs_private_subnet" {
  type        = string
  description = "Private subnet for Prometheus"
}

############################################
# ROUTER VPC Subnets
############################################
variable "router_public_subnet" {
  type        = string
  description = "Public subnet for router placeholder"
}
