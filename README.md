Overview
This project is a Terraform-based infrastructure deployment for various cloud resources. It provides a robust framework for managing and deploying AWS resources using Infrastructure as Code (IaC) principles. The setup focuses on creating scalable and manageable infrastructure, promoting best practices in DevOps.

[![Terraform Deployment](https://github.com/Yahormarts/rsschool-devops-course-tasks/actions/workflows/deploy-terraform.yml/badge.svg)](https://github.com/Yahormarts/rsschool-devops-course-tasks/actions/workflows/deploy-terraform.yml)

(SCREENSHOTS ARE BELLOW)

\\\Getting Started\\\
-Prerequisites-
Before you begin, ensure you have met the following requirements:

--Configuration--
1) Clone the Repository:

git clone https://github.com/Yahormarts/rsschool-devops-course-tasks.git

cd rsschool-devops-course-tasks

2) Set Up AWS Credentials: Ensure your AWS credentials are configured in your environment. This can be done by setting environment variables or through the AWS credentials file:

export AWS_ACCESS_KEY_ID=<your_access_key>

export AWS_SECRET_ACCESS_KEY=<your_secret_key>

>Terraform: Install Terraform (version X.X.X or later). You can download it from terraform.io.

>AWS CLI: Install and configure the AWS CLI. Make sure you have valid AWS credentials set up. Instructions can be found here.

>Git: Install Git for version control.

--Variables--

The following variables can be customized in variables.tf:

>region: The AWS region where resources will be deployed (default: eu-north-1).

>bucket_name: The name of the S3 bucket used for storing the Terraform state (default: my-bucket-task-rs).

--Usage--

To deploy the infrastructure, follow these steps:

1) Initialize Terraform: This command will initialize your Terraform environment and download necessary providers

terraform init

2) Format the Code (Optional): It is recommended to format the code to follow best practices.

terraform fmt

3) Validate the Configuration: Validate the Terraform files to ensure syntax correctness.

terraform validate

4) Plan the Deployment: Create an execution plan to preview changes that will be made.

terraform plan

5) Apply the Configuration: Deploy the infrastructure as defined in the configuration files.

terraform apply -auto-approve

--State Management--

This project uses an S3 bucket for storing the Terraform state file. Ensure the specified bucket exists in your AWS account or modify the bucket_name variable to an existing bucket.

--Locking State--

DynamoDB is used to manage state locking to prevent concurrent operations. Ensure you have a DynamoDB table configured with the proper name and permissions.

--Additional Notes--

Always check for any required IAM permissions needed for the operations being performed.
Monitor AWS service limits to avoid service interruptions.

--Contributing--

Contributions are welcome! Please follow these steps:

>Fork the repository.

>Create your feature branch.

>Commit your changes.

>Push to the branch.

>Open a Pull Request.

\\\SCREENSHOTS\\\

>IAM User created:

![01_User_MFA](https://github.com/user-attachments/assets/e123704d-210d-4563-bdb6-d80c8053d288)

>S3 Bucket created:

![02_Terraform_States_Bucket](https://github.com/user-attachments/assets/0c244f6e-807f-4865-bc7a-0941a31b4323)

>GitHUB Actions Role created:

![02_Github_Action_Role](https://github.com/user-attachments/assets/0e34c7dd-abb5-4e74-a9d9-67bd10917ade)

>Successful completed teraform deployment jobs:

![IMG_20241001_133200_377](https://github.com/user-attachments/assets/10f3ab5d-8bab-48f0-a19b-a44e18382b44)

>Successful completed AWS deployment job:

![IMG_20241001_133716](https://github.com/user-attachments/assets/78165bb3-6cc0-41ea-b530-dbf001e166fc)

