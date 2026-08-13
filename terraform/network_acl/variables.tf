variable "project_name" {
  type = string
}
variable "app_vpc_id" { type = string }
variable "obs_vpc_id" { type = string }
variable "router_vpc_id" { type = string }
variable "app_subnet_ids" { type = list(string) }
variable "obs_subnet_ids" { type = list(string) }
variable "router_subnet_ids" { type = list(string) }
variable "app_cidr" { type = string }
variable "obs_cidr" { type = string }
variable "router_cidr" { type = string }
