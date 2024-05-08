data "archive_file" "lambda_function_zip" {
  type        = "zip"
  output_path = "/tmp/lambda_function.zip"
  source_file = "${path.module}/../python/lambda/lambda_function.py"
}

resource "aws_lambda_function" "lambda" {
  function_name    = "db-connection-check"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.main"
  runtime          = "python3.12"
  filename         = "/tmp/lambda_function.zip"
  source_code_hash = data.archive_file.lambda_function_zip.output_base64sha256

  vpc_config {
    subnet_ids         = local.lambda_subnet_ids
    security_group_ids = [aws_security_group.lambda_security_group.id]
  }

  environment {
    variables     = {
      DB_HOST     = aws_db_instance.rds.address
      DB_PORT     = aws_db_instance.rds.port
      DB_NAME     = aws_db_instance.rds.db_name
      DB_USER     = var.db_admin_user
      DB_PASSWORD = var.db_admin_pass
    }
  }
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"
}
