resource "aws_instance" "bastion" {
  ami                         = "ami-089146c5626baa6bf"  
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnet_1.id
  associate_public_ip_address = true 
  key_name                    = "deploy_key"
  vpc_security_group_ids      = [aws_security_group.k3s_sg.id]

  tags = {
    Name = "bastion"
  }
}

resource "aws_instance" "k3s_master" {
  ami                         = "ami-089146c5626baa6bf" 
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.private_subnet_1.id
  key_name                    = "deploy_key"
  vpc_security_group_ids      = [aws_security_group.k3s_sg.id]

  tags = {
    Name = "k3s-master"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    bastion_host = aws_instance.bastion.public_ip
    private_key = var.aws_private_key
    host        = self.private_ip 
  }

  provisioner "remote-exec" {
    inline = [
      "set -x",
      "sleep 60",
      "echo 'Checking internet connectivity'",
      "curl -I https://www.google.com || { echo 'No internet connectivity'; exit 1; }",
      "echo 'Starting K3s installation'",
      "sleep 60",
      "curl -sfL https://get.k3s.io | sh - || { echo 'K3s installation failed'; exit 1; }",
      "echo 'K3s installed'",
      "sleep 60",
      "echo 'Checking K3s installation'",
      "/usr/local/bin/k3s --version || { echo 'K3s not found'; exit 1; }",
      "sleep 120", 
      "/usr/local/bin/k3s check-config || { echo 'K3s configuration check failed'; exit 1; }",
      "cat /var/lib/rancher/k3s/server/node-token > /tmp/k3s_token",
      "echo 'K3s installation complete'"
    ]
  }
}

resource "aws_instance" "k3s_worker" {
  count                       = 2
  ami                         = "ami-089146c5626baa6bf"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.private_subnet_1.id
  key_name                    = "deploy_key"
  vpc_security_group_ids      = [aws_security_group.k3s_sg.id]

  tags = {
    Name = "k3s-worker-${count.index}"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    bastion_host = aws_instance.bastion.public_ip
    private_key = var.aws_private_key
    host        = self.private_ip 
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 60",
      "K3S_TOKEN=$(curl -s http://${aws_instance.k3s_master.public_ip}/tmp/k3s_token) curl -sfL https://get.k3s.io | K3S_URL=https://${aws_instance.k3s_master.private_ip}:6443 K3S_TOKEN=$K3S_TOKEN sh -"
    ]
  }
}
