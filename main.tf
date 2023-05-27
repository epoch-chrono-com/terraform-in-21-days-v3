resource "aws_instance" "app_server" {
  ami           = "ami-0c00453583aaf434e" # ubuntu 22.04 ARM for gravitron instances
  instance_type = "t4g.micro"

  tags = {
    Name = "${var.env_code}-ExampleAppServerInstance"
  }
}
