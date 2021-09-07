#setup provider variables
provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAXGGSM5QTZ3RWMGLX"
  secret_key = "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"
}
#Create Iam role which will be used for the lambda function
resource "aws_iam_role" "iam_for_nefos" {
  name = "iam_for_nefos"

  assume_role_policy = file("iam_assume_policy.json")
}

#Creating S3 bucket resources
resource "aws_s3_bucket" "nefos-s3bucket" {
  bucket = "nefos-s3bucket"
  acl    = "private"

  tags = {
    Name        = "nefos-bucket-terraform"
    Environment = "Dev-Env"
  }
  versioning {
    enabled = true

  }
}
#Create a lambda function and dumb the python executable file into it
resource "aws_lambda_function" "nefos-lambda" {
  filename      = "nefos_lambda_function.zip"
  function_name = "nefos-lambda_function"
  role          = aws_iam_role.iam_for_nefos.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
}

resource "aws_apigatewayv2_api" "nefos-api" {
  name          = "v2-hhtp-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "nefos-lambad-stage" {
  api_id      = aws_apigatewayv2_api.nefos-api.id
  name        = "default"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "nefos-lambda-integration" {
  api_id               = aws_apigatewayv2_api.nefos-api.id
  integration_type     = "AWS_PROXY"
  integration_method   = "POST"
  integration_uri      = aws_lambda_function.nefos-lambda.invoke_arn
  passthrough_behavior = "WHEN_NO_MATCH"
}
resource "aws_apigatewayv2_route" "nefos-lambda-route" {
  api_id    = aws_apigatewayv2_api.nefos-api.id
  route_key = "GET /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.nefos-lambda-integration.id}"
}

resource "aws_lambda_permission" "api-gw" {
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.nefos-lambda.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.nefos-api.execution_arn}/*/*/*"

}

resource "aws_instance" "us-east-1" {
  ami           = "ami-0c2b8ca1dad447f8a"
  instance_type = "t3.micro"
  tags = {
    Name = "aws-instance-testing-terraform"
  }
}
