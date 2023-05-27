resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "${var.env_code}-epoch-vpc"
  }
}

resource "aws_subnet" "public" {
  count             = length(local.public_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.public_cidr[count.index]
  availability_zone = local.availability_zones[count.index]
  tags = {
    "Name" = "${var.env_code}-epoch-subnet-pub${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count             = length(local.private_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.private_cidr[count.index]
  availability_zone = local.availability_zones[count.index]
  tags = {
    "Name" = "${var.env_code}-epoch-subnet-priv${count.index + 1}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = "${var.env_code}-epoch-igw"
  }

}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.env_code}-epoch-rtb-main"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(local.public_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  count = length(local.public_cidr)
  vpc   = true
  tags = {
    Name = "${var.env_code}-epoch-eip-nat${count.index}"
  }
}

resource "aws_nat_gateway" "g" {
  count         = length(local.public_cidr)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  tags = {
    Name = "${var.env_code}-epoch-ngw${count.index}"
  }
  depends_on = [
    aws_internet_gateway.igw
  ]
}

resource "aws_route_table" "private" {
  count  = length(local.private_cidr)
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.g[count.index].id
  }
  tags = {
    Name = "${var.env_code}-epoch-rtb-priv${count.index}"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(local.private_cidr)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
