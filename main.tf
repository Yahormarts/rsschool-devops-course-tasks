resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "main_vpc"
  }
}

resource "aws_network_acl" "main_acl" {
  vpc_id = aws_vpc.main_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All traffic
    rule_no     = 100
    action      = "allow"
  }

  ingress {
    from_port   = 22         # SSH
    to_port     = 22
    protocol    = "tcp"
    rule_no     = 100
    action      = "allow"
  }

  ingress {
    from_port   = 80         # HTTP
    to_port     = 80
    protocol    = "tcp"
    rule_no     = 101
    action      = "allow"
  }

  ingress {
    from_port   = 443        # HTTPS
    to_port     = 443
    protocol    = "tcp"
    rule_no     = 102
    action      = "allow"
  }
}

resource "aws_security_group" "k3s_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # или укажите ваш IP
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


  tags = {
    Name = "allow_ssh"
  }
}
