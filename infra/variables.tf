
variable "environment" {
  type    = string
  default = "development"
}

variable "region_main" {
  type = string
  # default = "us-east-1"
}

variable "vpc_cidr" {
  type = string
  # default = "172.16.0.0/16"
}


variable "private_subnet_cidr" {
  type = string
  # default = ["

}

variable "public_subnet_cidr" {
  type = string
  # default = ["

}
variable "availability_zone_a" {
  type = string
  # default = "us-east-1a" 
}

variable "availability_zone_b" {
  type = string
  # default = "us-east-1b" 
}

variable "ami" {
  type = string
  #  description = "ami-0a0e5d9c7acc336f1"
}

variable "instance_type" {
  type = string
  # default = "t2.micro"
}