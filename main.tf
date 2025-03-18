resource "aws_vpc" "raj" {
    cidr_block = "10.0.0.0/16"
    tags = {
        name = "rajesh"
    }
  
}

resource "aws_subnet" "public" {
    vpc_id = aws_vpc.raj.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "ap-south-1a"
    
  
}


resource "aws_subnet" "private" {
    vpc_id = aws_vpc.raj.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = true
  
}

resource "aws_internet_gateway" "raj" {
    vpc_id = aws_vpc.raj.id
  
}

resource "aws_eip" "natgatway" {
    domain = "vpc"

  
}


resource "aws_nat_gateway" "natgatway" {
        allocation_id = aws_eip.natgatway.id
        subnet_id = aws_subnet.public.id

}


resource "aws_route_table" "public" {
    vpc_id = aws_vpc.raj.id
        route  {
            gateway_id = aws_internet_gateway.raj.id
            cidr_block = "0.0.0.0/0"

        }
}

resource "aws_route_table_association" "public" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.public.id
  
}


resource "aws_route_table" "private" {
    vpc_id = aws_vpc.raj.id
    route {
        nat_gateway_id = aws_nat_gateway.natgatway.id
        cidr_block = "0.0.0.0/0"
    }
  
}

resource "aws_route_table_association" "private" {
    subnet_id = aws_subnet.private.id
    route_table_id = aws_route_table.public.id

}

resource "aws_security_group" "raj" {
    vpc_id = aws_vpc.raj.id
    tags = {
      Name = "my-sg"
    }
    ingress{
        description = "TCL from VPC"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
  ingress{
        description = "TCL from VPC"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
     egress{
        description = "TCL from VPC"
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = [ "0.0.0.0/0" ]
     }
}



resource "aws_instance" "public" {
    ami = "ami-05c179eced2eb9b5b"
    instance_type = "t2.micro"
    key_name = "sss"
    subnet_id = aws_subnet.public.id
    availability_zone = "ap-south-1a"
    associate_public_ip_address = true
    vpc_security_group_ids = [ aws_security_group.raj.id ]
  
}


resource "aws_instance" "private" {
    ami = "ami-05c179eced2eb9b5b"
    instance_type = "t2.micro"
    key_name = "sss"
    subnet_id = aws_subnet.private.id
    availability_zone = "ap-south-1a"
    associate_public_ip_address = false
    vpc_security_group_ids = [ aws_security_group.raj.id ]
  
}