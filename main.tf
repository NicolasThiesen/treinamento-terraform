data "aws_ssm_parameter" "amz_linux" {
    name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-ebs"
}

data "aws_availability_zones" "azs"{
    state = "available"
}

resource "aws_vpc" "lab_vpc" {
  cidr_block = var.cidr
  enable_dns_hostnames = true

}

resource "aws_subnet" "lab_subnet" {
    vpc_id = aws_vpc.lab_vpc.id
    cidr_block = var.cidr_sb
    availability_zone = data.aws_availability_zones.azs.names[0]
    map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "lab_igw" {
    vpc_id = aws_vpc.lab_vpc.id
}

resource "aws_route_table" "lab_rt" {
  vpc_id = aws_vpc.lab_vpc.id
  route {
    cidr_block="0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab_igw.id
  }
}

resource "aws_route_table_association" "lb_rt_association" {
  subnet_id = aws_subnet.lab_subnet.id
  route_table_id = aws_route_table.lab_rt.id
}

resource "aws_security_group" "lab_sg" {
    name = "sg_teste"
  vpc_id = aws_vpc.lab_vpc.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  egress  {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0" ]
  }
}

resource "aws_instance" "instance" {
    ami = data.aws_ssm_parameter.amz_linux.value
    instance_type = "t3.micro"
    subnet_id = aws_subnet.lab_subnet.id
    security_groups = [aws_security_group.lab_sg.id]
    # subnet_id = aws_vpc.lab_vpc.subnet_id
}
