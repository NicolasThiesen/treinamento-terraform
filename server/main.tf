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
