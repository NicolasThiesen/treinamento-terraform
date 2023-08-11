data "aws_ssm_parameter" "amz_linux" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-ebs"
}

data "aws_availability_zones" "azs" {
  state = "available"
}

resource "aws_vpc" "lab_vpc" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "lab_subnet" {
  vpc_id                  = aws_vpc.lab_vpc.id
  cidr_block              = var.cidr_sb
  availability_zone       = data.aws_availability_zones.azs.names[0]
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "lab_igw" {
  vpc_id = aws_vpc.lab_vpc.id
}

resource "aws_route_table" "lab_rt" {
  vpc_id = aws_vpc.lab_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab_igw.id
  }
}

resource "aws_route_table_association" "lb_rt_association" {
  subnet_id      = aws_subnet.lab_subnet.id
  route_table_id = aws_route_table.lab_rt.id
}

resource "aws_security_group" "lab_sg" {
  name   = "sg_teste"
  vpc_id = aws_vpc.lab_vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "instance" {
  ami             = data.aws_ssm_parameter.amz_linux.value
  instance_type   = "t3.micro"
  subnet_id       = aws_subnet.lab_subnet.id
  security_groups = [aws_security_group.lab_sg.id]

  user_data = templatefile("${path.module}/scripts/user_data.sh", {
    MENSAGEM = var.mensagem
  })
  key_name = aws_key_pair.kp_lab.key_name
  # subnet_id = aws_vpc.lab_vpc.subnet_id
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ec2-user"
      private_key = tls_private_key.teste.private_key_pem
    }
    inline = [
      "echo 'Olá mundo'"      
      ]
  }
}
resource "tls_private_key" "teste" {
  algorithm = "RSA"
  # rsa_bits  = 2048
}
resource "aws_key_pair" "kp_lab" {
  key_name   = "kp-nicolas"
  public_key = tls_private_key.teste.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.teste.private_key_pem
  filename = "teste.pem"
}
