provider "aws" {
  region = var.region_main
}

#creating vpc
resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc_cidr
  

  tags = merge(
  local.common_tags,
  { Name = "k8s-vpc" } )
  
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



# #Data for eks node group
data "aws_instances" "eks_nodes" {
  filter {
    name   = "tag:eks:eks-node-group"
    values = [var.eks_node_group_id]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }


  depends_on = [var.eks_node_group_name]
  
}


#Load balancer
resource "aws_lb" "frontend_lb" {
  name               = "frontend-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = [aws_subnet.public_subnet.id, aws_subnet.private_subnet.id]
} 

# #creating target group for load balancer
resource "aws_lb_target_group" "frontend_tg" {
  name     = "frontend-target-group"
  port     = 31080
  protocol = "HTTP"
  vpc_id   = aws_vpc.myvpc.id

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

#getting the auto scaling group from eks node group and attaching to alb
data "aws_autoscaling_groups" "eks_node_asgs" {
  filter {
    name   = "tag:ekseks-node-group"
    values = [var.eks_node_group_name]  # Or the string directly
  }
}


# ## Target group attachment to the EC2 instance
resource "aws_lb_target_group_attachment" "frontend_tg_attach" {
  for_each         = toset(data.aws_autoscaling_groups.eks_node_asgs.names)
  target_group_arn = aws_lb_target_group.frontend_tg.arn
  target_id        = each.value
  port             = 31080
}

# 4. Listener (forward from ALB port 80 to target group)
resource "aws_lb_listener" "frontend_listener" {
  load_balancer_arn = aws_lb.frontend_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }
}



