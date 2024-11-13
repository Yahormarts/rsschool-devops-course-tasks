resource "aws_instance" "bastion" {
  ami                         = "ami-070fe338fb2265e00"  
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnet_1.id
  associate_public_ip_address = true 
  key_name                    = "deploy_key"
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "bastion"
  }
}

resource "aws_instance" "k3s_master" {
  depends_on = [aws_instance.bastion]
  ami                         = "ami-070fe338fb2265e00" 
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.private_subnet_1.id
  key_name                    = "deploy_key"
  vpc_security_group_ids      = [aws_security_group.k3s_sg.id]

  tags = {
    Name = "k3s-master"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    bastion_host = aws_instance.bastion.public_ip
    agent       = false
    private_key = var.aws_private_key
    host        = self.private_ip
    timeout = "2m"
  }
}

resource "null_resource" "bastion_ready" {
  depends_on = [aws_instance.bastion]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    bastion_host = aws_instance.bastion.public_ip
    agent       = false
    private_key = var.aws_private_key
    host        = aws_instance.bastion.private_ip
    timeout = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for Bastion to be ready...'",
      "until nc -zv ${aws_instance.bastion.public_ip} 22; do echo 'Waiting for SSH on Bastion...'; sleep 10; done",
      "echo 'Bastion is now ready for SSH.'"
    ]
  }
}