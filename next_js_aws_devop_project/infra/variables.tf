
variable "region_main" {
  type = string
  # default = "us-east-1"
}

variable "cidr" {
  type = string
  # default = "172.16.0.0/16"
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
