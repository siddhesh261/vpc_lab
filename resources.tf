
// Provisioned a VPC 

resource "aws_vpc" "private_network" {
cidr_block = var.vpc_ci-dr
tags = {
    name = "private_vpc"
   }
}


// Created a public subnet inside VPC

resource "aws_subnet" "public_subnet" {
    vpc_id            = aws_vpc.private_network.id
    cidr_block        = var.public_ci-dr
    availability_zone = var.public_region
    tags= {
          name = "public_sub"
    }
}

// Created a private subnet inside VPC

resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.private_network.id
  cidr_block = var.private_ci-dr
  availability_zone = var.private_region
 tags= {
          name = "private_sub"
    }
}


// Internet Gateway for VPC access to internet 

resource "aws_internet_gateway" "iag" {

    vpc_id= aws_vpc.private_network.id
  
}

// Public route table

resource "aws_route_table" "main_route_table" {
        vpc_id = aws_vpc.private_network.id
}

// Public route for access to internet

resource "aws_route" "public_route" {
    route_table_id = aws_route_table.main_route_table.id
    destination_cidr_block = var.ci_dr
    gateway_id = aws_internet_gateway.iag.id
}

// associating route table with public subnet

resource "aws_route_table_association" "public_routing" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.main_route_table.id
}

// creating elastic ip
 
resource "aws_eip" "my_eip" {
  vpc = true
}

// creating nat gateway for private subnet access to internet

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = aws_subnet.public_subnet.id
}

// route table for private subnet

resource "aws_route_table" "private_route" {
    vpc_id = aws_vpc.private_network.id
}

// routing for private subnet to nat gateway

resource "aws_route" "private_route" {
    route_table_id = aws_route_table.private_route.id
    destination_cidr_block = var.ci_dr
    nat_gateway_id   = aws_nat_gateway.nat.id
}


// associating route table to private subnet

resource "aws_route_table_association" "private_routing"{
    subnet_id = aws_subnet.private_subnet_1.id
    route_table_id = aws_route_table.private_route.id
}
