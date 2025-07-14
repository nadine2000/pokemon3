
output "backend_server_public_ip" {
  description = "The public IP address of the backend server."
  value       = aws_instance.backend_server.public_ip
}

output "game_server_public_ip" {
  description = "The public IP address of the game server."
  value       = aws_instance.game_server.public_ip
}

output "backend_server_private_ip" {
  description = "The private IP address of the backend server."
  value       = aws_instance.backend_server.private_ip
}

output "game_server_private_ip" {
  description = "The private IP address of the game server."
  value       = aws_instance.game_server.private_ip
}


