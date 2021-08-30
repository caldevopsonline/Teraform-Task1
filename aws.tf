#setup provider variables
provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}
#Create Iam role which will be used for the lambda function
resource "aws_iam_role" "iam_for_eghan" {
  name = "iam_for_eghan"

 assume_role_policy ="${file("iam_assume_policy.json")}"
}

#Creating S3 bucket resources
  resource "aws_s3_bucket" "mybuckettest-eghan" {
  bucket = "my-terraform-eghan-bucket"
  acl    = "private"

  tags = {
    Name        = "My bucket-test-eghan-terraform"
    Environment = "Dev-Env"
  }
  versioning{
  enabled = true

}
}
#Create a lambda function and dumb the python executable file into it
resource "aws_lambda_function" "eghan-lambda" {
  filename      = "lambda_file_function.zip"
  function_name = "eghan-lambda_function"
  role          = aws_iam_role.iam_for_eghan.arn
  handler       = "lambda_function.lambda_handler"
  runtime = "python3.8"
}

resource "aws_instance" "us-east-1" {
  ami           = "ami-0c2b8ca1dad447f8a"
  instance_type = "t3.micro"
  tags = {
    Name = "aws-instance-testing-terraform"
  }
  }

