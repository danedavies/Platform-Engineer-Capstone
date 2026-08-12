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


variable "app_cidr" {
  description = "CIDR block for the App VPC"
  type        = string
}

variable "obs_cidr" {
  description = "CIDR block for the Observability VPC"
  type = string
}

variable "router_cidr" {
  description = "CIDR block for the Router VPC"
  type = string
}
