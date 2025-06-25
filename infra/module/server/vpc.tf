module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.0.1"


  name = "k8s-vpc"
  cidr = var.cidr

    
  azs = [
        var.availability_zone_a,
        var.availability_zone_b
    ]
    


}

