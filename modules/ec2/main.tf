data "aws_ssm_parameter" "amazon_linux_2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "image-id"
    values = [data.aws_ssm_parameter.amazon_linux_2023.value]
  }
}


resource "aws_instance" "kind_server" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = aws_key_pair.ec2_key_pair.key_name
  vpc_security_group_ids      = [var.sg_id]
  associate_public_ip_address = true

  user_data = file("modules/ec2/user_data.sh")
  user_data_replace_on_change = true

  tags = {
    Name = "kind-nginx-server"
  }
  depends_on = [aws_key_pair.ec2_key_pair]
}

resource "tls_private_key" "tls_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "ec2-key"
  public_key = tls_private_key.tls_key.public_key_openssh
}

resource "local_file" "server_key" {
  content         = tls_private_key.tls_key.private_key_pem
  filename        = "${path.module}/server-key.pem"
  file_permission = "0600"
}



