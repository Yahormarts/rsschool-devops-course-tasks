resource "aws_instance" "k3s_master" {
  ami           = "ami-089146c5626baa6bf"  # AMI for Ubuntu 
  instance_type = "t3.micro"      # Free tier
  subnet_id     = aws_subnet.public_subnet_1.id
  key_name      = "deploy_key"    # SSH key name

  tags = {
    Name = "k3s-master"
  }

  # Подключение по SSH
  connection {
    type        = "ssh"
    user        = "ubuntu"        # default user Ubuntu
    private_key = file("~/.ssh/id_rsa")  # private key patch GitHub Actions runner
    host        = self.public_ip  # public IP of created instance
  }

  provisioner "remote-exec" {
    inline = [
      "curl -sfL https://get.k3s.io | sh -",  # Install k3s
      "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml"  # Setting kubectl
    ]
  }
}

resource "aws_instance" "k3s_worker" {
  count         = 2 
  ami           = "ami-089146c5626baa6bf"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private_subnet_1.id
  key_name      = "deploy_key"  # SSH key name

  tags = {
    Name = "k3s-worker-${count.index}"
  }

  # Подключение по SSH
  connection {
    type        = "ssh"
    user        = "ubuntu"        # default user Ubuntu
    private_key = file("~/.ssh/id_rsa")  # private key patch GitHub Actions runner
    host        = self.public_ip  # public IP of created instance
  }

  provisioner "remote-exec" {
    inline = [
      "curl -sfL https://get.k3s.io | K3S_URL=https://k3s-master:6443 K3S_TOKEN=<your-token> sh -"
    ]
  }
}
