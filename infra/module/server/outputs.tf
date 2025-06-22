output "ec2_public_ip" {
  value = aws_instance.server1.public_ip
}

# output "ec2_private_ip" {
#   value = aws_instance.server1.private_ip
# }

output "dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.lb.dns_name
}

# output "ssh_private_key" {
#   description = "The private key for SSH access"
#   value       = tls_private_key.pri_key.private_key_pem
#   # sensitive   = true
# }

output "user_name" {
  description = "The username for SSH access"
  value       = "ubuntu"  
}


