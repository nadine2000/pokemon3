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

