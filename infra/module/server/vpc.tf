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

#This subnet automatically assigns public ip to resources  launched into it 
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