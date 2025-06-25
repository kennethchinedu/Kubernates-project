# variable "region_main" {
#   default = "us-east-1"
# }

# variable "cidr" {
#   default = "172.16.0.0/16"
# }

# variable "availability_zone_a" {
#   default = "us-east-1a" 
# }

# variable "availability_zone_b" {
#   default = "us-east-1b" 
# }

# variable "ami" {
#   default =   "ami-0a0e5d9c7acc336f1"
# }

# variable "instance_type" {
#   default = "t2.micro"
# }

# variable "key_path" {
#   default = "/Users/kennethchinedu/Desktop/Projects/project4/infra/vpc/deployer_key.pub"
  
# }

# defining locals
#  variable "project_name" {
#   type        = string
#   default     = "my_project"
   
#  }

variable "environment" {
  type        = string
  default     = "development"
}
 # defining locals for common tags
locals {
  common_tags = {
    Project     = "Kubernetes Project"
    Environment = var.environment
    Owner       = "Cloud Team"
  }
}


#Defining locals for VPC and subnets
locals {
  vpc_cidr = var.vpc_cidr
  private_subnet_cidr = var.private_subnet_cidr
  public_subnet_cidr = var.public_subnet_cidr   
}  




resource "aws_s3_bucket" "logs" {
  bucket = "${var.project_name}-logs"
  tags   = local.common_tags
}


locals {
  vpc_cidr = var.vpc_cidr 
}

variable "region_main" {
  type        = string
  # default = "us-east-1"
}

variable "vpc_cidr" {
  type        = string
  # default = "172.16.0.0/16"
}

variable "private_subnet_cidr" {
  type        = string
  # default = ["
  
}

variable "public_subnet_cidr" {
  type        = string
  # default = ["
  
}

variable "availability_zone_a" {
  type        = string
  # default = "us-east-1a" 
}

variable "availability_zone_b" {
  type        = string
  # default = "us-east-1b" 
}

variable "ami" {
  type        = string
  #  description = "ami-0a0e5d9c7acc336f1"
}

variable "instance_type" {
  type        = string
  # default = "t2.micro"
}
