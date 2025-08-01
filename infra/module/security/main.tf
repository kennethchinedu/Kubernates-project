
#Security Group for Public Subnet
#Exposing these ports just for demo purposes, not recommended for production

provider "aws" {
  region = var.region_main
}

resource "aws_security_group" "sg" {
    name = "public_subnet_sg"
    description = "Allow TLS inbound traffic and all outbound traffic"
    vpc_id = var.vpc_id



  ingress {
    description = "SSH to VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    description = "expose frontend app on port 31080"
    from_port   = 31080
    to_port     = 31080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow worker nodes to receive traffic from control plane
  ingress {
  description = "Allow EKS control plane to communicate with worker nodes (HTTPS)"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  }



  ingress {
    description = "Http Acces"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

#Allow all traffic
  egress {
    description = "Allow all traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  } 
  tags = {
     Name = "pubclic_subnet_sg"
   }
}