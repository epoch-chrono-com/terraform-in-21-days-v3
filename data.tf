data "http" "ip" {
  url = "https://ifconfig.me/ip"
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.20230307.0*-arm64-gp2"]
  }
}
