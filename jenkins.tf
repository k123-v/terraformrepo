provider "aws" {
  region     = var.aws_region
}

resource "aws_vpc" "first_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_tags
  }
  enable_dns_support = var.dnssupport
  enable_dns_hostnames = var.dnshostname
   
}
resource "aws_subnet" "mainsubnet" {
  vpc_id     = aws_vpc.first_vpc.id
  cidr_block = var.vpc_subnet
  tags = {
    Name = var.subnet_tags

  }
  availability_zone = var.availzone
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.first_vpc.id

  tags = {
    Name = var.igw_tags
  }
}
resource "aws_route_table" "rti" {
  vpc_id = aws_vpc.first_vpc.id

  route {
    cidr_block = var.cidrgeneral
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = var.route_table_tags
  }
  depends_on = [aws_internet_gateway.igw, aws_vpc.first_vpc]
}
resource "aws_security_group" "allow" {
  name        = "Allow_traffic"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.first_vpc.id

  ingress {
    description = " SSH Traffic from VPC"
    from_port   = var.from_port
    to_port     = var.to_port
    protocol    = var.proto
   
    #cidr_blocks = [aws_vpc.first_vpc.cidr_block]
    cidr_blocks = [var.cidrgeneral,]
  }
  ingress {
    description = " HTTP Traffic from VPC"
    from_port   = var.http_port
    to_port     = var.httpto_port
    protocol    = var.proto
   
    #cidr_blocks = [aws_vpc.first_vpc.cidr_block]
    cidr_blocks = [var.cidrgeneral,]
  }

  egress {
    from_port   = var.egressfport
    to_port     = var.egresstport
    protocol    = var.egressproto
    cidr_blocks = [var.cidrgeneral,]
  }

  tags = {
    Name = var.securitygr
  }
}
resource "aws_network_interface" "mynetworkint" {
  subnet_id       = aws_subnet.mainsubnet.id
  security_groups = [aws_security_group.allow.id]

}
resource "aws_instance" "myec2" {
  count         = var.countinst
  subnet_id     = aws_subnet.mainsubnet.id
  ami           = var.amiID
  instance_type = var.instype
  # using terraform list interpolation 
  availability_zone = var.availzone
  key_name          = var.keydetail
  private_ip        = var.privateip
  security_groups = [aws_security_group.allow.id]
  associate_public_ip_address = true

  # To provide different names to devices use count.index
  tags = {
    Name = var.ec2name
  }
}
resource "aws_route_table_association" "routetableass" {
  subnet_id      = aws_subnet.mainsubnet.id
  route_table_id = aws_route_table.rti.id
  
}
