provider "aws" {
  region = "us-east-1"
}

resource "aws_dynamodb_table" "mi_tabla" {

  name         = "MiTablaDynamoDB"
  billing_mode = "PROVISIONED" #billing_mode = "PAY_PER_REQUEST"  # o "PROVISIONED"

  read_capacity  = 5
  write_capacity = 5

  hash_key     = "ID_Dron"

  attribute {
    name = "ID_Dron"
    type = "S"  # "S" = String, "N" = Number, "B" = Binary
  }

  tags = {
    Environment = "dev"
    Project     = "MiProyecto"
  }
}


resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "lambda_zip_get" {
  type        = "zip"
  source_dir  = "${path.module}/lambdaGet"
  output_path = "${path.module}/lambda_function_Get.zip"
}

resource "aws_lambda_function" "mi_lambda_get" {
  function_name = "MiLambdaGet"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "handler.handler"
  runtime       = "nodejs22.x"

  filename         = data.archive_file.lambda_zip_get.output_path
  source_code_hash = data.archive_file.lambda_zip_get.output_base64sha256
}

data "archive_file" "lambda_zip_post" {
  type        = "zip"
  source_dir  = "${path.module}/lambdaPost"
  output_path = "${path.module}/lambda_function_Post.zip"
}

resource "aws_lambda_function" "mi_lambda_post" {
  function_name = "MiLambdaPost"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "handler.handler"
  runtime       = "nodejs22.x"

  filename         = data.archive_file.lambda_zip_post.output_path
  source_code_hash = data.archive_file.lambda_zip_post.output_base64sha256
}


