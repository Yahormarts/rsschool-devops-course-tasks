resource "aws_instance" "k3s_master" {
  ami           = "ami-005fc0f236362e99f"  # AMI for Ubuntu 
  instance_type = "t2.micro"      # Free tier
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "k3s-master"
  }

  provisioner "remote-exec" {
    inline = [
      "curl -sfL https://get.k3s.io | sh -",  # Install k3s
      "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml"  # Configure kubectl
    ]
  }
}

resource "aws_instance" "k3s_worker" {
  count         = 2 
  ami           = "ami-005fc0f236362e99f"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet_1.id

  tags = {
    Name = "k3s-worker-${count.index}"
  }

  provisioner "remote-exec" {
    inline = [
      "curl -sfL https://get.k3s.io | K3S_URL=https://k3s-master:6443 K3S_TOKEN=<your-token> sh -"
    ]
  }
}
