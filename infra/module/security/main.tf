provider "aws" {
  region = var.region_main
}

resource "aws_security_group" "sg" {
    name = "recipe_app_sec_group"
    description = "Allow TLS inbound traffic and all outbound traffic"
    vpc_id = aws_vpc.myvpc.id  


  ingress {
    description = "HTTP TLS to VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP TLS to VPC"
    from_port   = 5173
    to_port     = 5173
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH to VPC"
    from_port   = 22
    to_port     = 22
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
     Name = "allow inboud 5173"
   }
}