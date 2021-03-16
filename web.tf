provider "aws" {
  region     = "us-east-1"
}
data "aws_vpc" "webservervpc" {
    filter {
        name = "tag:Name"
        values = ["myjenkinsvpc"]
    }
}

data "aws_subnet" "jensub" {
  filter {
    name   = "tag:Name"
    values = ["myjenkinsubnet"]
  }
}
resource "aws_subnet" "web" {
  vpc_id     = data.aws_vpc.webservervpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
      Name = "mywebsubnet"
  }
}

data "aws_internet_gateway" "webigwd" {
  filter {
    name   = "tag:Name"
    values = ["myigw"]
  }
}


data "aws_route_table" "rtidata" {
  filter {
    name   = "tag:Name"
    values = ["myjenkinsroutetable"]
  }
}

resource "aws_route_table" "rti" {
  vpc_id = data.aws_vpc.webservervpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.webigwd.id
  }
  depends_on = [data.aws_internet_gateway.webigwd, data.aws_vpc.webservervpc]
}
data "aws_security_group" "sgd" {
  filter {
    name   = "tag:Name"
    values = ["myjenkinssg"]
  }
}

resource "aws_network_interface" "mynetworkint" {
  subnet_id       = aws_subnet.web.id
  security_groups = [data.aws_security_group.sgd.id]

}
#data "aws_ami" "amid" {
#    executable_users = ["self"]
#    most_recent      = true
#    name_regex       = "^ami-\\d{3}"
#    owners           = ["self"]

#  filter {
#    name   = "name"
#    values = ["ami-042e8287309f5df03"]
#  }
#}

data "aws_ec2_instance_type" "instyd" {
  instance_type = "t2.micro"
}


resource "aws_instance" "myec2" {
  subnet_id     = aws_subnet.web.id
  ami           = "ami-042e8287309f5df03"
  instance_type = data.aws_ec2_instance_type.instyd.id

  # using terraform list interpolation 
  availability_zone = "us-east-1b"
  key_name          = "feb24key"
  private_ip        = "10.0.2.50"
  security_groups = [data.aws_security_group.sgd.id]
  associate_public_ip_address = true

  # To provide different names to devices use count.index
  tags = {
    Name = "mynewserver"
  }
  depends_on = [aws_subnet.web]
}
resource "aws_route_table_association" "routetableass" {
  subnet_id      = aws_subnet.web.id
  route_table_id = data.aws_route_table.rtidata.id
  
}

