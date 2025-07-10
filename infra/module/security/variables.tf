
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







