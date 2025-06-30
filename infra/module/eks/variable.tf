
variable "environment" {
  type        = string

}


locals {
  common_tags = {
    Project     = "Kubernetes Project"
    Environment = var.environment
    Owner       = "Cloud Team"
  }
}
 

 