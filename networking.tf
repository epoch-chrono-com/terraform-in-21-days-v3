resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name"        = "epoch-vpc",
    "Terraformed" = "true"
  }
}

resource "aws_subnet" "public1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "sa-east-1a"
  tags = {
    "Name"        = "epoch-subnet-pub1",
    "Terraformed" = "true"
  }
}

resource "aws_subnet" "public2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "sa-east-1b"
  tags = {
    "Name"        = "epoch-subnet-pub2",
    "Terraformed" = "true"
  }
}

resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "sa-east-1a"
  tags = {
    "Name"        = "epoch-subnet-priv1",
    "Terraformed" = "true"
  }
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "sa-east-1b"
  tags = {
    "Name"        = "epoch-subnet-priv2",
    "Terraformed" = "true"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name"        = "epoch-igw",
    "Terraformed" = "true"
  }

}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name          = "epoch-rtb-main",
    "Terraformed" = "true"
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.main.id
}

resource "aws_eip" "nat1" {
  vpc = true
  tags = {
    Name          = "epoch-eip-nat1",
    "Terraformed" = "true"
  }
}

resource "aws_eip" "nat2" {
  vpc = true
  tags = {
    Name          = "epoch-eip-nat2",
    "Terraformed" = "true"
  }
}

resource "aws_nat_gateway" "g1" {
  allocation_id = aws_eip.nat1.id
  subnet_id     = aws_subnet.public1.id
  tags = {
    Name          = "epoch-ngw1",
    "Terraformed" = "true"
  }
  depends_on = [
    aws_internet_gateway.igw
  ]
}

resource "aws_nat_gateway" "g2" {
  allocation_id = aws_eip.nat2.id
  subnet_id     = aws_subnet.public2.id
  tags = {
    Name          = "epoch-ngw2",
    "Terraformed" = "true"
  }
  depends_on = [
    aws_internet_gateway.igw
  ]
}

resource "aws_route_table" "private1" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.g1.id
  }
  tags = {
    Name          = "epoch-rtb-priv1",
    "Terraformed" = "true"
  }
}

resource "aws_route_table" "private2" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.g2.id
  }
  tags = {
    Name          = "epoch-rtb-priv2",
    "Terraformed" = "true"
  }
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private1.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private2.id
}
