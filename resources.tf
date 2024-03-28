resource "aws_vpc" "private_network" {
cidr_block = var.vpc_ci-dr
tags = {
    name = "private_vpc"
   }
}



resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.private_network.id
    cidr_block = var.public_ci-dr
    availability_zone = var.public_region
    tags= {
          name = "public_sub"
    }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.private_network.id
  cidr_block = var.private_ci-dr
  availability_zone = var.private_region
 tags= {
          name = "private_sub"
    }
}





resource "aws_internet_gateway" "iag" {

    vpc_id= aws_vpc.private_network.id
  
}





resource "aws_route_table" "main_route_table" {
        vpc_id = aws_vpc.private_network.id
}

resource "aws_route" "public_route" {
    route_table_id = aws_route_table.main_route_table.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.iag.id
}

resource "aws_route_table_association" "public_routing" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.main_route_table.id
}


resource "aws_eip" "my_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = aws_subnet.public_subnet.id
}

resource "aws_route_table" "private_route" {
    vpc_id = aws_vpc.private_network.id
}

resource "aws_route" "private_route" {
    route_table_id = aws_route_table.private_route.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id   = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private_routing"{
    subnet_id = aws_subnet.private_subnet_1.id
    route_table_id = aws_route_table.private_route.id
}
