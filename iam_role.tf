# IAM role will grant the necessary permissions to interact with KMS and DynamoDB

resource "aws_iam_role" "paymentledger_role" {
  name = "paymentledger-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "paymentledger_policy" {
  name = "paymentledger-policy"
  role = aws_iam_role.paymentledger_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Permissions for KMS
      {
        Effect = "Allow"
        Action = [
          "kms:Encrypt",
          "kms:Decrypt"
        ]
        Resource = "arn:aws:kms:${var.aws_region}:${data.aws_caller_identity.current.account_id}:key/${aws_kms_key.payment_key.id}"
      },
      # Permissions for DynamoDB
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:UpdateItem",
          "dynamodb:Scan"
        ]
        Resource = "arn:aws:dynamodb:${var.aws_region}:${data.aws_caller_identity.current.account_id}:table/${aws_dynamodb_table.payment_ledger.name}"
      },
      # Permissions for Logs
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*"
      },
      # Permissions to interact with EC2 network interfaces (needed for Lambda in VPC)
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ]
        Resource = "*"
      }
    ]
  })
}
