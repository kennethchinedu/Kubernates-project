provider "aws" {
  region = var.region_main
}

module "networking" {
  source              = "./module/networking"
  region_main         = var.region_main
  vpc_cidr                = var.vpc_cidr
  availability_zone_a = var.availability_zone_a
  availability_zone_b = var.availability_zone_b
  public_subnet_cidr = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  instance_type = var.instance_type
  ami = var.ami
  environment =  var.environment
 
}


module "eks" {
  source              = "./module/eks"
  region_main         = var.region_main
  vpc_id                = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids
  instance_type = var.instance_type
  ami = var.ami
  environment =  var.environment
  # ssh_key_name = var.ssh_key_name 
  security_group_id = module.security.security_group_id
 
}


module "security" {
  source              = "./module/security"
  region_main         = var.region_main
  vpc_id                = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids
  environment =  var.environment
 
}

# Use module outputs instead of direct resource references
# output "ec2_public_ip" {
#   value = module.networking.vpc_id
# }

# # output "ec2_private_ip" {
# #   value = module.app-deployment.ec2_private_ip
# # }

# output "dns_name" {
#   description = "The DNS name of the load balancer"
#   value       = module.app-deployment.dns_name
# }

# # output "ssh_private_key" {
# #   description = "private key for seriver"
# #   value       = module.app-deployment.ssh_private_key
# #   sensitive   = true
# # }

# output "user_name" {
#   description = "user name for server"
#   value       = module.app-deployment.user_name
# }
