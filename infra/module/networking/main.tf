provider "aws" {
  region = var.region_main
}

#creating vpc
resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc_cidr
  

  tags  = local.common_tags
  
}

#This subnet automatically assigns public ip to resources  launched into it 
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.myvpc.id  
  cidr_block = local.public_subnet_cidr
  availability_zone =var.availability_zone_a
  map_public_ip_on_launch = true
  
   
  tags = merge(
  local.common_tags,
  { Name = "public-subnet" } )

}



#This subnet is private 
resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.myvpc.id  
  cidr_block = local.private_subnet_cidr
  availability_zone = var.availability_zone_b


  tags = merge(
  local.common_tags,
  { Name = "pivate-subnet" } )

}


#internet gateway for vpc
resource "aws_internet_gateway" "i-gateway" {
  vpc_id = aws_vpc.myvpc.id

  tags = merge(
  local.common_tags,
  { Name = "k8s-igw" } )
  
}  

# #Route table for our subnets using the internet gateway
resource "aws_route_table" "public_subnet_rt" {
  vpc_id = aws_vpc.myvpc.id  
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.i-gateway.id
  }

  tags = local.common_tags
}


# Associating public route table with our public subnet
resource "aws_route_table_association" "rt_association1" {  
  subnet_id      = aws_subnet.public_subnet.id   
  route_table_id = aws_route_table.public_subnet_rt.id
}


#Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {


  tags = merge(
    local.common_tags,
    { Name = "nat-eip" }
  )
}


# NAT Gateway for private subnet to access the internet
resource "aws_nat_gateway" "n_gateway" {
  subnet_id     = aws_subnet.public_subnet.id
  allocation_id = aws_eip.nat_eip.id  

  tags = local.common_tags
}


# Route table for private subnet using NAT gateway
resource "aws_route_table" "private_subnet_rt" {
  vpc_id = aws_vpc.myvpc.id
  
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.n_gateway.id
  }

  tags = local.common_tags
}



resource "aws_route_table_association" "rt_association2" {
  subnet_id      = aws_subnet.private_subnet.id   
  route_table_id = aws_route_table.private_subnet_rt.id
}


############################## LOAD BALANCERS #################################
############################## LOAD BALANCERS #################################
############################## LOAD BALANCERS #################################
############################## LOAD BALANCERS #################################


# #creating load balancer (removed second ec2)
# resource "aws_lb" "lb" {
#   name = "recipelb"
#   internal = false 
#   load_balancer_type = "application" 
#   security_groups = [aws_security_group.sg.id]
#   subnets = [ aws_subnet.subnet1.id, aws_subnet.subnet2.id ]
  
#   tags = {
#     name = "recipe-load-balancer"
#   }
# }

# #creating target groups
# resource "aws_lb_target_group" "tg" {
#   name = "mytg"  # no underscores
#   port = 80  
#   protocol = "HTTP"
#   vpc_id = aws_vpc.myvpc.id  

#   # Including health check
#   health_check {
#     path = "/"
#     port = "traffic-port"
#   }
# }

# #Target group attachement to ec2
# resource "aws_lb_target_group_attachment" "attach_server1" {
#   target_group_arn = aws_lb_target_group.tg.arn 
#   target_id = aws_instance.server1.id 
#   port = 80
# }

# # resource "aws_lb_target_group_attachment" "attach_server2" {
# #   target_group_arn = aws_lb_target_group.tg.arn 
# #   target_id = aws_instance.server2.id 
# #   port = 5173
# # }

# #creating load balancer lister
# resource "aws_lb_listener" "lb_listener" {
#   load_balancer_arn = aws_lb.lb.arn  
#   port = 80 
#   protocol = "HTTP"

#   default_action {
#     target_group_arn = aws_lb_target_group.tg.arn 
#     type = "forward"
#   }
# }

# output "loadbancerip" {
#   value = aws_lb.lb.dns_name
# }
