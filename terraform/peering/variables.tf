variable "app_vpc_id" {
  description = "VPC ID for the App VPC"
  type        = string
}

variable "obs_vpc_id" {
  description = "VPC ID for the Observability VPC"
  type        = string
}

variable "router_vpc_id" {
  description = "VPC ID for the Router VPC"
  type        = string
}

variable "app_private_rt_id" {
  type = string
}

variable "obs_private_rt_id" {
  type = string
}

variable "router_public_rt_id" {
  type = string
}

variable "app_cidr" {
  type = string
}

variable "obs_cidr" {
  type = string
}

variable "router_cidr" {
  type = string
}

variable "app_public_rt_id" {
  type = string
}