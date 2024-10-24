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
    protocol    = "-1"  
    rule_no     = 100
    action      = "allow"
    cidr_block  = "0.0.0.0/0"
  }

  ingress {
    from_port   = 22        
    to_port     = 22
    protocol    = "tcp"
    rule_no     = 100
    action      = "allow"
    cidr_block  = "0.0.0.0/0"
  }

  ingress {
    from_port   = 80         
    to_port     = 80
    protocol    = "tcp"
    rule_no     = 101
    action      = "allow"
    cidr_block  = "0.0.0.0/0"
  }

  ingress {
    from_port   = 443       
    to_port     = 443
    protocol    = "tcp"
    rule_no     = 102
    action      = "allow"
    cidr_block  = "0.0.0.0/0"
  }
}

resource "aws_security_group" "k3s_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id] 
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main_vpc.cidr_block]  
  }

  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main_vpc.cidr_block]  
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "k3s_sg"
  }
}

resource "aws_security_group" "bastion_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion_sg"
  }
}
