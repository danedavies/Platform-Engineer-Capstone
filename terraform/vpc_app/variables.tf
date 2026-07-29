variable "project_name" {
  type        = string
  default     = "platform-capstone"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_1_subnet_cidr" {
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_2_subnet_cidr" {
  type        = string
  default     = "10.0.3.0/24"
}
