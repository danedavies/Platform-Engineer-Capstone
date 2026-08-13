variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "platform-capstone"
}

variable "ami" {
  type    = string
  default = data.aws_ami.al2023.id
}
