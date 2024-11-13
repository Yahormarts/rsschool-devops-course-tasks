resource "aws_instance" "k3s_worker" {
  depends_on = [aws_instance.k3s_master]
  count                       = 1
  ami                         = "ami-070fe338fb2265e00"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.private_subnet_1.id
  key_name                    = "deploy_key"
  vpc_security_group_ids      = [aws_security_group.k3s_sg.id]

  tags = {
    Name = "k3s-worker-${count.index}"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    bastion_host = aws_instance.bastion.public_ip
    private_key = var.aws_private_key
    host        = self.private_ip 
  }
}