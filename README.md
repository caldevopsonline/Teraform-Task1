
# Creating a s3 bucket and lambda function with terraform

# Overview

1. The task aim at using terraform ton create. When Terraform is applied, an s3 bucket is created and a lambda function is also created with IAM role and assume_policy
2. The lambda function is then packaged as a zip file, which will be dumbed into the created lambda function.

# Setup
1. The terraform script is executed first by initializing it with the command terraform init
2. This is followed by the command terraform apply. This setup the key resources that will be created on the aws console
3. Then finally the command terraform apply is executed which starts the the process of creating the intended resources. 


# Lambda_function
1. The lambda function is created with a python and with a python 3.8 runtime
2. The function makes use of boto3. To install boto3 simply run pip install boto3
3. When the function is triggered or executed, a textfile with a written content is created in the s3 which was initially created using terraform. 
