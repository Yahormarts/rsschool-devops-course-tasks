resource "null_resource" "bastion_ready2" {
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

  provisioner "local-exec" {
    command = <<EOT
      set -x
      sleep 60
      echo 'Checking internet connectivity'
      curl -I https://www.google.com || { echo 'No internet connectivity'; exit 1; }
      echo 'Starting K3s installation'
      sleep 60
    EOT
  }
}

resource "null_resource" "k3s_master_ready" {
  depends_on = [aws_instance.k3s_master]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    bastion_host = aws_instance.bastion.public_ip
    agent       = false
    private_key = var.aws_private_key
    host        = aws_instance.k3s_master.private_ip
    timeout = "2m"
  }

  provisioner "local-exec" {
    command = <<EOT
      set -x
      sleep 60
      echo 'Checking internet connectivity'
      curl -I https://www.google.com || { echo 'No internet connectivity'; exit 1; }
      echo 'Starting K3s installation'
      sleep 60
      curl -sfL https://get.k3s.io | sh - || { echo 'K3s installation failed'; exit 1; }
      echo 'K3s installed'
      sleep 60
      echo 'Checking K3s installation'
      /usr/local/bin/k3s --version || { echo 'K3s not found'; exit 1; }
      sleep 120
      /usr/local/bin/k3s check-config || { echo 'K3s configuration check failed'; exit 1; }
      cat /var/lib/rancher/k3s/server/node-token > /tmp/k3s_token
      echo 'K3s installation complete'
    EOT
  }
}