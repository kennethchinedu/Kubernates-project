
variable "environment" {
  type        = string
}

# =========== LOCALS ===========

 # defining locals for common tags
locals {
  common_tags = {
    Project     = "Kubernetes Project"
    Environment = var.environment
    Owner       = "Cloud Team"
  }
}
 


#Defining LOCALS for VPC and subnets
locals {
  vpc_id = var.vpc_id
  private_subnet_ids = var.public_subnet_ids
  public_subnet_cidr = var.private_subnet_ids
#   availability_zone_a = var.availability_zone_a
#   availability_zone_b = var.availability_zone_b
}  






variable "region_main" {
  type        = string
  # default = "us-east-1"
}

variable "vpc_id" {
  type        = string

}

variable "private_subnet_ids" {
  type        = string
  
  
}

variable "public_subnet_ids" {
  type        = string
  # default = ["
  
}

# variable "availability_zone_a" {
#   type        = string
#   # default = "us-east-1a" 
# }

# variable "availability_zone_b" {
#   type        = string
#   # default = "us-east-1b" 
# }

variable "ami" {
  type        = string
  #  description = "ami-0a0e5d9c7acc336f1"
}

variable "instance_type" {
  type        = string
  # default = "t2.micro"
}
