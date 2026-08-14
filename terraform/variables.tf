variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "platform-capstone"
}
variable "router_public_subnet" {
  description = "Public subnet for the router VPC"
  type        = string
}