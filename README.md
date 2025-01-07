# Infrastructure Deployment with Terraform

## Overview
This project uses Terraform to deploy and manage AWS-based infrastructure, including a lightweight Kubernetes cluster (K3s). It provides a scalable and maintainable setup, adhering to Infrastructure as Code (IaC) best practices. Key components include bastion hosts, Kubernetes master and worker nodes, and networking configurations.

(SCREENSHOTS ARE BELOW)

---

## Getting Started

### Prerequisites
Before beginning, ensure you have the following tools installed:

1. **AWS CLI**: Install and configure the AWS CLI with your credentials:
   ```bash
   export AWS_ACCESS_KEY_ID=<your_access_key>
   export AWS_SECRET_ACCESS_KEY=<your_secret_key>
   ```
   
2. **Terraform**: Install the latest version from [terraform.io](https://www.terraform.io/).

3. **Git**: Install Git for version control.

4. **SSH Key**: Ensure you have an SSH private key file configured for accessing EC2 instances.

---

### Clone the Repository
```bash
git clone https://github.com/Yahormarts/rsschool-devops-course-tasks.git
cd rsschool-devops-course-tasks
```

### Configuration
Customize variables in `variables.tf` as needed:
- **region**: AWS region for resource deployment (default: `eu-north-1`).
- **bucket_name**: S3 bucket for Terraform state storage (default: `my-bucket-task-rs`).

---

## Terraform Configuration Files

### Key Files
- **`backend.tf`**: Configures remote state storage with S3 and state locking with DynamoDB.
- **`main.tf`**: Defines core infrastructure components like EC2 instances and S3 buckets.
- **`gateway.tf`**: Configures networking gateways (API Gateway or VPC Gateway).
- **`routes.tf`**: Sets routing rules for networking.
- **`subnets.tf`**: Defines public and private subnet configurations within a VPC.
- **`variables.tf`**: Declares variables for reuse and flexibility.
- **`outputs.tf`**: Defines outputs such as resource IDs and IP addresses for visibility after deployment.

---

## Kubernetes Cluster Deployment

### Bastion Host
The bastion host is deployed in a public subnet and serves as a secure SSH gateway to private resources.

#### Configuration Highlights:
- AMI: `ami-070fe338fb2265e00`
- Instance Type: `t3.micro`
- Subnet: Public

---

### K3s Master Node
The master node runs the Kubernetes control plane in a private subnet and is accessible via the bastion host.

#### Configuration Highlights:
- AMI: `ami-070fe338fb2265e00`
- Instance Type: `t3.micro`
- Subnet: Private

#### Setup Process:
1. Internet connectivity check.
2. K3s installation using the official script.
3. Validation of K3s installation.
4. Exporting `node-token` for worker nodes to join the cluster.

---

### K3s Worker Nodes
Worker nodes join the Kubernetes cluster and run workloads. Two nodes are provisioned by default (adjustable).

#### Configuration Highlights:
- AMI: `ami-070fe338fb2265e00`
- Instance Type: `t3.micro`
- Count: `2`
- Subnet: Private

#### Setup Process:
1. Fetch the `node-token` from the master node through the bastion host.
2. Join the cluster using the master node's private IP and `node-token`.
3. Install the K3s agent.

#### Sample Worker Configuration Code:
```hcl
resource "aws_instance" "k3s_worker" {
  count = 2
  ami = "ami-070fe338fb2265e00"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.private_subnet_1.id
  key_name = "deploy_key"
  vpc_security_group_ids = [aws_security_group.k3s_sg.id]

  tags = {
    Name = "k3s-worker-${count.index}"
  }

  connection {
    type = "ssh"
    user = "ec2-user"
    bastion_host = aws_instance.bastion.public_ip
    agent = false
    private_key = var.aws_private_key
    host = self.private_ip
    timeout = "10m"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for K3s Master to provide token...'",
      "for i in {1..10}; do ssh -i <(echo \"${var.aws_private_key}\") -o StrictHostKeyChecking=no ec2-user@${aws_instance.k3s_master.private_ip} 'test -f /var/lib/rancher/k3s/server/node-token' && break || sleep 10; done",
      "K3S_TOKEN=$(ssh -i <(echo \"${var.aws_private_key}\") -o StrictHostKeyChecking=no ec2-user@${aws_instance.k3s_master.private_ip} 'cat /var/lib/rancher/k3s/server/node-token')",
      "curl -sfL https://get.k3s.io | K3S_URL=https://${aws_instance.k3s_master.private_ip}:6443 K3S_TOKEN=$K3S_TOKEN sh -"
    ]
  }
}
```

---

## Deployment Steps

1. **Initialize Terraform**
   ```bash
   terraform init
   ```

2. **Format the Code (Optional)**
   ```bash
   terraform fmt
   ```

3. **Validate the Configuration**
   ```bash
   terraform validate
   ```

4. **Plan the Deployment**
   ```bash
   terraform plan
   ```

5. **Apply the Configuration**
   ```bash
   terraform apply -auto-approve
   ```

---
Outputs
After successful deployment, key outputs such as resource IDs, IP addresses, and URLs will be displayed. Example:
 ```bash
Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:
master_instance_ip = "12.34.56.78"
worker_instance_ips = [
  "12.34.56.79",
  "12.34.56.80"
]
  ```
---
## State Management

This project uses an S3 bucket for remote state storage. Ensure the specified bucket exists in your AWS account or update the `bucket_name` variable in `backend.tf` to match an existing bucket.

**State Locking**: DynamoDB is configured to prevent concurrent operations.

---

## Contributing
Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create your feature branch.
3. Commit your changes.
4. Push to the branch.
5. Open a Pull Request.

---

## Screenshots

*(Add relevant screenshots to showcase the infrastructure, outputs, and usage.)*

