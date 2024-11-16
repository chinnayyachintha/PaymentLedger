resource "aws_lambda_function" "persist_payment_ledger" {
  function_name = "Persist-${var.dynamodb_table_name}" # Update to match the actual function name

  role    = aws_iam_role.paymentledger_role.arn
  handler = "paymentledger.persist_payment_ledger" # Update to match the actual function name
  runtime = "python3.8"

  filename         = "paymentledger.zip"
  source_code_hash = filebase64sha256("paymentledger.zip")

  environment {
    variables = {
      PAYMENT_KMS_KEY_ARN = aws_kms_key.payment_key.arn
      DYNAMODB_TABLE_NAME = aws_dynamodb_table.payment_ledger.name
    }
  }

  vpc_config {
    subnet_ids         = [data.aws_subnet.private_subnet.id]     # Reference the private subnet
    security_group_ids = [data.aws_security_group.private_sg.id] # Reference the security group
  }

  timeout = 60
}


