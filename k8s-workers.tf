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
      agent       = false
      private_key = var.aws_private_key
      host        = self.private_ip
      timeout     = "1m"
    }

  provisioner "remote-exec" {
  inline = [
    "sleep 60",
    "echo 'Connecting to master and retrieving token'",
    "K3S_TOKEN=$(curl -s http://${aws_instance.k3s_master.private_ip}/tmp/k3s_token)",
    "echo 'Installing K3s agent on worker'",
    "curl -sfL https://get.k3s.io | K3S_URL=https://${aws_instance.k3s_master.private_ip}:6443 K3S_TOKEN=$K3S_TOKEN sh -"
   ]
  }
}