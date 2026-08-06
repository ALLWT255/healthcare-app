resource "aws_vpc" "healthcare_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "healthcare-vpc"
  }
}
resource "aws_internet_gateway" "healthcare_igw" {
  vpc_id = aws_vpc.healthcare_vpc.id

  tags = {
    Name = "healthcare-igw"
  }
}
resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.healthcare_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-A"
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.healthcare_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-B"
  }
}
resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.healthcare_vpc.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Private-Subnet-A"
  }
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id            = aws_vpc.healthcare_vpc.id
  cidr_block        = "10.0.12.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Private-Subnet-B"
  }
}
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.healthcare_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.healthcare_igw.id
  }

  tags = {
    Name = "Public-Route-Table"
  }
}
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "Healthcare-NAT-EIP"
  }
}
resource "aws_nat_gateway" "healthcare_nat" {
  allocation_id = aws_eip.nat_eip.id

  subnet_id = aws_subnet.public_subnet_a.id

  tags = {
    Name = "Healthcare-NAT-Gateway"
  }

  depends_on = [
    aws_internet_gateway.healthcare_igw
  ]
}
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.healthcare_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.healthcare_nat.id
  }

  tags = {
    Name = "Private-Route-Table"
  }
}
resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.private_rt.id
}