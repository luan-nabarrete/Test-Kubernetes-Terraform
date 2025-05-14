resource "aws_security_group" "ec2_sg" {
  name        = "${var.name}-sg"
  description = "Security Group allowing access on port 8080"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 31289
    to_port     = 31289
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.meu_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-sg"
  }
}
