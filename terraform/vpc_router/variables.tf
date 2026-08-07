variable "project_name" {
  type        = string
  default     = "platform-capstone"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.2.0.0/16"
}

variable "public_subnet_cidr" {
  type        = string
  default     = "10.2.1.0/24"
}
