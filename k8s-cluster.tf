resource "aws_instance" "k3s_master" {
  ami           = "ami-089146c5626baa6bf" 
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_subnet_1.id
  key_name      = "deploy_key"
  vpc_security_group_ids = [aws_security_group.k3s_sg.id]

  tags = {
    Name = "k3s-master"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "curl -sfL https://get.k3s.io | sh -",
      "cat /var/lib/rancher/k3s/server/node-token > /tmp/k3s_token"
    ]
  }
}

resource "aws_instance" "k3s_worker" {
  count         = 2
  ami           = "ami-089146c5626baa6bf"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private_subnet_1.id
  key_name      = "deploy_key"
  vpc_security_group_ids = [aws_security_group.k3s_sg.id]

  tags = {
    Name = "k3s-worker-${count.index}"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = self.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "K3S_TOKEN=$(curl -s ${aws_instance.k3s_master.public_ip}/tmp/k3s_token) curl -sfL https://get.k3s.io | K3S_URL=https://${aws_instance.k3s_master.private_ip}:6443 K3S_TOKEN=$K3S_TOKEN sh -"
    ]
  }
}
