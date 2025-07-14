
variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-west-2"
}

variable "backend_server_name" {
  description = "Name for the backend EC2 instance."
  type        = string
  default     = "BackendServer"
}

variable "game_server_name" {
  description = "Name for the game EC2 instance."
  type        = string
  default     = "GameServer"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances."
  type        = string
  default     = "ami-05ee755be0cd7555c"
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}


