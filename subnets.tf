resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet_1"
  }
}

resource "aws_network_acl" "my_network_acl" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "My Network ACL"
  }
}

resource "aws_network_acl_rule" "allow_ssh" {
  network_acl_id = aws_network_acl.my_network_acl.id
  rule_number     = 100
  egress          = false
  protocol        = "tcp"
  rule_action     = "allow"
  cidr_block      = "0.0.0.0/0"
  from_port       = 22
  to_port         = 22
}

resource "aws_subnet_network_acl_association" "my_subnet_acl_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  network_acl_id = aws_network_acl.my_network_acl.id
}
