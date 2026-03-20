data "aws_availability_zones" "available" {
    state = "available"
}

# == Subnets ==

resource "aws_subnet" "Private_1" {
    vpc_id = aws_vpc.Lab7_VPC.id
    cidr_block = var.Private_Subnet_1_Cidr_Block
    availability_zone = data.aws_availability_zones.available.names[0]
    map_public_ip_on_launch = false 
    tags = {
        Name = "Private-Subnet-1"
    }
}
resource "aws_subnet" "Private_2" {
    vpc_id = aws_vpc.Lab7_VPC.id
    cidr_block = var.Private_Subnet_2_Cidr_Block
    availability_zone = data.aws_availability_zones.available.names[1]
    map_public_ip_on_launch = false 
    tags = {
        Name = "Private-Subnet-2"
    }
}
resource "aws_subnet" "Public_1" {
    vpc_id = aws_vpc.Lab7_VPC.id
    cidr_block = var.Public_Subnet_1_Cidr_Block
    availability_zone = data.aws_availability_zones.available.names[0]
    map_public_ip_on_launch = true 
    tags = {
        Name = "Public-Subnet-1"
    }
}
resource "aws_subnet" "Public_2" {
    vpc_id = aws_vpc.Lab7_VPC.id
    cidr_block = var.Public_Subnet_2_Cidr_Block
    availability_zone = data.aws_availability_zones.available.names[1]
    map_public_ip_on_launch = true 
    tags = {
        Name = "Public-Subnet-2"
    }
}

# == Internet and NAT Gateways == 

resource "aws_internet_gateway" "Lab7_IGW" {
    vpc_id = aws_vpc.Lab7_VPC.id
    tags = {
        Name = "Lab7-IGW"
    }
}
resource "aws_eip" "Lab7_EIP_1" {
    domain = "vpc"
    tags = {
        Name = "Lab7-EIP-1"
    }
}
resource "aws_eip" "Lab7_EIP_2" {
    domain = "vpc"
    tags = {
        Name = "Lab7-EIP-2"
    }
}
resource "aws_nat_gateway" "Lab7_NAT_GW_1" {
    allocation_id = aws_eip.Lab7_EIP_1.id
    subnet_id = aws_subnet.Public_1.id
    depends_on = [aws_internet_gateway.Lab7_IGW]
    tags = {
        Name = "Lab7-NAT-GW-1"
    }
}
resource "aws_nat_gateway" "Lab7_NAT_GW_2" {
    allocation_id = aws_eip.Lab7_EIP_2.id
    subnet_id = aws_subnet.Public_2.id
    depends_on = [aws_internet_gateway.Lab7_IGW]
    tags = {
        Name = "Lab7-NAT-GW-2"
    }
}

# == Public Route Table + Associations ==

resource "aws_route_table" "Public_RT" {
    vpc_id = aws_vpc.Lab7_VPC.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.Lab7_IGW.id
    }
    tags = {
        Name = "Public-RT"
    }
}
resource "aws_route_table_association" "Public_1" {
    subnet_id = aws_subnet.Public_1.id
    route_table_id = aws_route_table.Public_RT.id
}
resource "aws_route_table_association" "Public_2" {
    subnet_id = aws_subnet.Public_2.id
    route_table_id = aws_route_table.Public_RT.id
}

# == Private Route Table + Associations ==

resource "aws_route_table" "Private_RT_1" {
    vpc_id = aws_vpc.Lab7_VPC.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.Lab7_NAT_GW_1.id
    }
    tags = {
        Name = "Lab-Private-RT-1"
    }
}
resource "aws_route_table" "Private_RT_2" {
    vpc_id = aws_vpc.Lab7_VPC.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.Lab7_NAT_GW_2.id
    }
    tags = {
        Name = "Lab-Private-RT-2"
    }
}
resource "aws_route_table_association" "Private_1" {
    subnet_id = aws_subnet.Private_1.id
    route_table_id = aws_route_table.Private_RT_1.id
}
resource "aws_route_table_association" "Private_2" {
    subnet_id = aws_subnet.Private_2.id
    route_table_id = aws_route_table.Private_RT_2.id
}