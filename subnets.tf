resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet_1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = "eu-north-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet_2"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = "eu-north-1a"
  tags = {
    Name = "private_subnet_1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = "eu-north-1b"
  tags = {
    Name = "private_subnet_2"
  }
}

resource "aws_network_acl_association" "public_acl_association_1" {
  subnet_id     = aws_subnet.public_subnet_1.id
  network_acl_id = aws_network_acl.main_acl.id
}

resource "aws_network_acl_association" "public_acl_association_2" {
  subnet_id     = aws_subnet.public_subnet_2.id
  network_acl_id = aws_network_acl.main_acl.id
}

resource "aws_network_acl_association" "private_acl_association_1" {
  subnet_id     = aws_subnet.private_subnet_1.id
  network_acl_id = aws_network_acl.main_acl.id
}

resource "aws_network_acl_association" "private_acl_association_2" {
  subnet_id     = aws_subnet.private_subnet_2.id
  network_acl_id = aws_network_acl.main_acl.id
}
