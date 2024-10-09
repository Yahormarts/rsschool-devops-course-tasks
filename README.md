# Overview
This project is a Terraform-based infrastructure deployment for various cloud resources. It provides a robust framework for managing and deploying AWS resources using Infrastructure as Code (IaC) principles. The setup focuses on creating scalable and manageable infrastructure, promoting best practices in DevOps.

[![Terraform Deployment](https://github.com/Yahormarts/rsschool-devops-course-tasks/actions/workflows/deploy-terraform.yml/badge.svg)](https://github.com/Yahormarts/rsschool-devops-course-tasks/actions/workflows/deploy-terraform.yml)

[![Deploy to AWS](https://github.com/Yahormarts/rsschool-devops-course-tasks/actions/workflows/deploy-aws.yml/badge.svg)](https://github.com/Yahormarts/rsschool-devops-course-tasks/actions/workflows/deploy-aws.yml)

_(SCREENSHOTS ARE BELLOW)_

## Getting Started
### Prerequisites
Before you begin, ensure you have met the following requirements:

**Configuration**
1) Clone the Repository:
```
git clone https://github.com/Yahormarts/rsschool-devops-course-tasks.git

cd rsschool-devops-course-tasks
```
2) Set Up AWS Credentials: Ensure your AWS credentials are configured in your environment. This can be done by setting environment variables or through the AWS credentials file:
```
export AWS_ACCESS_KEY_ID=<your_access_key>

export AWS_SECRET_ACCESS_KEY=<your_secret_key>
```
**Terraform**: Install Terraform (lastest version). You can download it from terraform.io.

**AWS CLI**: Install and configure the AWS CLI. Make sure you have valid AWS credentials set up. Instructions can be found here.

**Git**: Install Git for version control.

**Variables**

The following variables can be customized in variables.tf:

1) region: The AWS region where resources will be deployed (default: eu-north-1).

2) bucket_name: The name of the S3 bucket used for storing the Terraform state (default: my-bucket-task-rs).

## Terraform Configuration Files

 `backend.tf`
This file configures the backend for managing Terraform's state. It specifies remote storage options, allowing for safe collaboration among team members. The configuration may include settings for state locking, ensuring that multiple users cannot make changes simultaneously. This is essential for maintaining the integrity of the infrastructure state.

 `main.tf`
The main configuration file that defines the core infrastructure components, including AWS resources such as EC2 instances and S3 buckets.

 `gateway.tf`
This file defines the configuration for the gateway resource used in our infrastructure. It includes specifications for the type of gateway (such as API Gateway or VPC Gateway), along with necessary parameters and integrations with other resources. The gateway's permissions and policies are also outlined here, ensuring secure access to related services. This is critical for enabling connectivity and managing traffic within our architecture.

 `routes.tf`
This file configures the routing rules for our infrastructure, defining how incoming requests are processed and directed to various backend services. It includes specific route definitions, integrations with other resources, and security measures to control access. Additionally, fallback routes are specified to ensure robust error handling and a smooth user experience. This configuration is vital for managing traffic flow and optimizing resource utilization within our architecture.

 `subnets.tf`
This file defines the subnet configurations for our cloud infrastructure, specifying individual subnets with their respective CIDR blocks, availability zones, and association with the Virtual Private Cloud (VPC). It distinguishes between public and private subnets to enhance security by controlling internet access for sensitive resources. Additionally, route table associations are defined to manage traffic flow between subnets and other networks. This configuration is fundamental for structuring our network architecture effectively.

 `variables.tf`
Declares variables used throughout the Terraform configurations, allowing for more flexible and maintainable code.

 `outputs.tf`
Specifies outputs from the Terraform configuration, providing important information such as resource IDs and IP addresses after deployment.

# Usage

To deploy the infrastructure, follow these steps:

1) Initialize Terraform: This command will initialize your Terraform environment and download necessary providers
```
terraform init
```
2) Format the Code (Optional): It is recommended to format the code to follow best practices.
```
terraform fmt
```
3) Validate the Configuration: Validate the Terraform files to ensure syntax correctness.
```
terraform validate
```
4) Plan the Deployment: Create an execution plan to preview changes that will be made.
```
terraform plan
```
5) Apply the Configuration: Deploy the infrastructure as defined in the configuration files.
```
terraform apply -auto-approve
```
**State Management**

This project uses an S3 bucket for storing the Terraform state file. Ensure the specified bucket exists in your AWS account or modify the bucket_name variable to an existing bucket.

**Locking State**

DynamoDB is used to manage state locking to prevent concurrent operations. Ensure you have a DynamoDB table configured with the proper name and permissions.

### Additional Notes

Always check for any required IAM permissions needed for the operations being performed.
Monitor AWS service limits to avoid service interruptions.

### Contributing

Contributions are welcome! Please follow these steps:

- Fork the repository.

- Create your feature branch.

- Commit your changes.

- Push to the branch.

- Open a Pull Request.

## SCREENSHOTS

>IAM User created:

![01_User_MFA](https://github.com/user-attachments/assets/e123704d-210d-4563-bdb6-d80c8053d288)

>S3 Bucket created:

![02_Terraform_States_Bucket](https://github.com/user-attachments/assets/0c244f6e-807f-4865-bc7a-0941a31b4323)

>GitHUB Actions Role created:

![02_Github_Action_Role](https://github.com/user-attachments/assets/0e34c7dd-abb5-4e74-a9d9-67bd10917ade)


