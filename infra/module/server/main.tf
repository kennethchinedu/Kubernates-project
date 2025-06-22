provider "aws" {
  region = "us-east-1"
}

#creating vpc
resource "aws_vpc" "myvpc" {
  cidr_block = "172.16.0.0/16"
  

  tags = {
    Name = "myvpc"
  }
}

#This subnet automatically assigns public ip to any Ec2 launched into it 
resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.myvpc.id  
  cidr_block = "172.16.0.0/24"
  availability_zone = var.availability_zone_a
  map_public_ip_on_launch = true
}


#This subnet is private
resource "aws_subnet" "subnet2" {
  vpc_id = aws_vpc.myvpc.id  
  cidr_block = "172.16.1.0/24"
  availability_zone = var.availability_zone_b
  map_public_ip_on_launch = true
}

#internet gateway for vpc
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.myvpc.id
}

# #Route table for our vpc
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.myvpc.id  
    #This internet gateway allows all network access to our vpc
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }

  tags = {
    Name = "recipe_app_project_rt"
  }
}


# Associating this route table with our subnet
resource "aws_route_table_association" "rt_association1" {  
  subnet_id      = aws_subnet.subnet1.id  
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "rt_association2" {
  subnet_id      = aws_subnet.subnet2.id  
  route_table_id = aws_route_table.rt.id
}



# #route table for private subnet
# resource "aws_route_table" "private_subnet_rt" {
#   vpc_id = aws_vpc.myvpc.id
  
#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat_gateway.id
#   }

#   tags = {
#     Name = "private_subnet_rt"
#   }
# }

# Creating security group with multiple ingress rules

# Create private key
# resource "tls_private_key" "pri_key" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
  
# }

# #Create key pair
# resource "aws_key_pair" "keypair" {
#   key_name   = "keypair"
#   public_key = tls_private_key.pri_key.public_key_openssh

#   provisioner "local-exec" {
#     command = "echo '${tls_private_key.pri_key.private_key_pem}' > ./my-keypair.pem && chmod 400 ./my-keypair.pem"
#   }
# }



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

resource "aws_instance" "server1" {
  vpc_security_group_ids = [aws_security_group.sg.id]
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name      = "_testdev_keypair"
  subnet_id             = aws_subnet.subnet1.id  
  user_data = base64encode(file("setup.sh"))

  tags = {
    Name = "dev-server1"
  }

}


# resource "aws_instance" "server2" {
#   vpc_security_group_ids = [aws_security_group.sg.id]
#   ami                    = var.ami
#   instance_type          = var.instance_type
#   key_name               = aws_key_pair.deployer.key_name
#   subnet_id             = aws_subnet.subnet2.id  
#   user_data = base64encode(file("setup.sh"))

#    tags = {
#     Name = "dev-server2"
#   }
# }

#creating load balancer (removed second ec2)
resource "aws_lb" "lb" {
  name = "recipelb"
  internal = false 
  load_balancer_type = "application" 
  security_groups = [aws_security_group.sg.id]
  subnets = [ aws_subnet.subnet1.id, aws_subnet.subnet2.id ]
  
  tags = {
    name = "recipe-load-balancer"
  }
}

#creating target groups
resource "aws_lb_target_group" "tg" {
  name = "mytg"  # no underscores
  port = 80  
  protocol = "HTTP"
  vpc_id = aws_vpc.myvpc.id  

  # Including health check
  health_check {
    path = "/"
    port = "traffic-port"
  }
}

#Target group attachement to ec2
resource "aws_lb_target_group_attachment" "attach_server1" {
  target_group_arn = aws_lb_target_group.tg.arn 
  target_id = aws_instance.server1.id 
  port = 80
}

# resource "aws_lb_target_group_attachment" "attach_server2" {
#   target_group_arn = aws_lb_target_group.tg.arn 
#   target_id = aws_instance.server2.id 
#   port = 5173
# }

#creating load balancer lister
resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.lb.arn  
  port = 80 
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.tg.arn 
    type = "forward"
  }
}

output "loadbancerip" {
  value = aws_lb.lb.dns_name
}
