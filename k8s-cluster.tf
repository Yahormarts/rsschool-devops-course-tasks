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

resource "null_resource" "bastion_ready" {
  depends_on = [aws_instance.bastion]

  provisioner "local-exec" {
    command = <<EOT
      echo "Waiting for Bastion to be ready..."
      for i in {1..10}; do
        ssh -i ${var.aws_private_key} -o ConnectTimeout=10 -o StrictHostKeyChecking=no ec2-user@${aws_instance.bastion.public_ip} "exit" && break || sleep 10
      done
      echo "Bastion is ready."
    EOT
  }
}

resource "aws_instance" "k3s_master" {
  depends_on = [null_resource.bastion_ready]
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
    timeout     = "10m"
  }

  provisioner "local-exec" {
    command = <<EOT
      set -x
      echo "Waiting for K3s Master to be ready..."
      sleep 60
      echo 'Checking internet connectivity'
      curl -I https://www.google.com || { echo 'No internet connectivity'; exit 1; }
      echo 'Starting K3s installation'
      curl -sfL https://get.k3s.io | sh - || { echo 'K3s installation failed'; exit 1; }
      echo 'K3s installed'
      sleep 60
      echo 'Checking K3s installation'
      /usr/local/bin/k3s --version || { echo 'K3s not found'; exit 1; }
      /usr/local/bin/k3s check-config || { echo 'K3s configuration check failed'; exit 1; }
      cat /var/lib/rancher/k3s/server/node-token > /tmp/k3s_token
      echo 'K3s installation complete'
    EOT
  }
}

resource "aws_instance" "k3s_worker" {
  depends_on = [aws_instance.k3s_master]
  count                       = 2
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
    timeout     = "10m"
  }

 provisioner "local-exec" {
    command = <<EOT
      echo "Waiting for K3s Master to provide token..."
      for i in {1..10}; do
        ssh -i ${var.aws_private_key} -o StrictHostKeyChecking=no ec2-user@${aws_instance.k3s_master.private_ip} "test -f /var/lib/rancher/k3s/server/node-token" && break || sleep 10
      done

      echo "Fetching K3S Token from Master..."
      K3S_TOKEN=$(ssh -i ${var.aws_private_key} -o StrictHostKeyChecking=no ec2-user@${aws_instance.k3s_master.private_ip} "cat /var/lib/rancher/k3s/server/node-token")

      echo "Installing K3s Worker..."
      curl -sfL https://get.k3s.io | K3S_URL=https://${aws_instance.k3s_master.private_ip}:6443 K3S_TOKEN=$K3S_TOKEN sh -
    EOT
  }
}
