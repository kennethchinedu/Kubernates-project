provider "aws" {
  region = "us-east-1"
}

module "app-deployment" {
  source              = "./module/server"
  region_main         = var.region_main
  cidr                = var.cidr
  availability_zone_a = var.availability_zone_a
  availability_zone_b = var.availability_zone_b
  ami                 = var.ami
  instance_type       = var.instance_type
}


# Use module outputs instead of direct resource references
output "ec2_public_ip" {
  value = module.app-deployment.ec2_public_ip
}

# output "ec2_private_ip" {
#   value = module.app-deployment.ec2_private_ip
# }

output "dns_name" {
  description = "The DNS name of the load balancer"
  value       = module.app-deployment.dns_name
}

# output "ssh_private_key" {
#   description = "private key for seriver"
#   value       = module.app-deployment.ssh_private_key
#   sensitive   = true
# }

output "user_name" {
  description = "user name for server"
  value       = module.app-deployment.user_name
}
