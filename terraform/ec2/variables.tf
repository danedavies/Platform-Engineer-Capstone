variable "project_name" {
  type        = string
  default     = "platform-capstone"
}

variable "ami" {
  type        = string
  description = "AMI ID for all EC2 instances"
}

# VPC1 – APP
variable "app_public_subnet" {
  type        = string
  description = "Public subnet for bastion"
}

variable "vpc_id" {
  description = "VPC ID for EC2 resources"
  type        = string
}

variable "app_private_1" {
  type        = string
  description = "Private subnet for app instance 1"
}

variable "app_private_2" {
  type        = string
  description = "Private subnet for app instance 2"
}

# VPC2 – OBSERVABILITY
variable "obs_public_subnet" {
  type        = string
  description = "Public subnet for Grafana"
}

variable "obs_private_subnet" {
  type        = string
  description = "Private subnet for Prometheus"
}

# VPC3 – ROUTER
variable "router_public_subnet" {
  type        = string
  description = "Public subnet for router placeholder"
}
