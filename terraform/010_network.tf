# Create a VPC to launch our instances into
resource "aws_vpc" "xeasgnmnt-vpc" {
  cidr_block = "10.10.0.0/16"
  tags = {
    Name = "xeasgnmnt-vpc"
  }
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "xeasgnmnt-gateway" {
  vpc_id = aws_vpc.xeasgnmnt-vpc.id
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.xeasgnmnt-vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.xeasgnmnt-gateway.id
}

# Create a subnet to launch our instances into
resource "aws_subnet" "xeasgnmnt-subnet-v1a" {
  vpc_id                  = aws_vpc.xeasgnmnt-vpc.id
  availability_zone       = "us-east-1a"
  cidr_block              = "10.10.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "xeasgnmnt-subnet-v1a"
  }
}

