resource "aws_key_pair" "terraform-mentoring" {
  key_name   = "terraform-mentoring"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC9IOJ15PY2JesXRp4xvYcfS5mLJYQCYGpd4d2WaLsXA"
}

resource "aws_instance" "public-instance" {
  # ami                         = "ami-0c00453583aaf434e" # ubuntu 22.04 ARM for gravitron instances
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t4g.micro"
  associate_public_ip_address = true
  key_name                    = aws_key_pair.terraform-mentoring.key_name
  subnet_id                   = aws_subnet.public[0].id
  user_data                   = file("./user-data.sh")
  user_data_replace_on_change = true
  vpc_security_group_ids = [
    aws_security_group.public-sg.id,
  ]

  tags = {
    Name = "${var.env_code}-public-ec2"
  }
}

resource "aws_security_group" "public-sg" {
  name        = "${var.env_code}-public-sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.main.id
  ingress {
    description      = "Allow all from my public ip"
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["${data.http.ip.response_body}/32"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "HTTP to anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    description      = "Allow all to any ip"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.env_code}-public-sg"
  }
}

resource "aws_instance" "private-instance" {
  # ami           = "ami-0c00453583aaf434e" # ubuntu 22.04 ARM for gravitron instances
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t4g.micro"
  key_name      = aws_key_pair.terraform-mentoring.key_name
  subnet_id     = aws_subnet.private[0].id
  vpc_security_group_ids = [
    aws_security_group.private-sg.id,
  ]

  tags = {
    Name = "${var.env_code}-private-ec2"
  }
}

resource "aws_security_group" "private-sg" {
  name        = "${var.env_code}-private-sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.main.id
  ingress {
    description      = "Allow all from my private ip"
    from_port        = 0
    to_port          = 0
    protocol         = -1
    security_groups  = [aws_security_group.public-sg.id]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    description      = "Allow all to any ip"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.env_code}-private-sg"
  }
}
