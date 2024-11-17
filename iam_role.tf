# IAM Role for payment ledger processing
resource "aws_iam_role" "paymentledger_role" {
  name = "${var.dynamodb_table_name}-role"

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

# IAM Role Policy for permissions related to KMS, DynamoDB, CloudWatch Logs, EC2 network interfaces, and Backup operations
resource "aws_iam_role_policy" "paymentledger_policy" {
  name = "${var.dynamodb_table_name}-policy"
  role = aws_iam_role.paymentledger_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Permissions for KMS: Encrypt and Decrypt with the specified KMS key
      {
        Effect = "Allow"
        Action = [
          "kms:Encrypt",
          "kms:Decrypt"
        ]
        Resource = "arn:aws:kms:${var.aws_region}:${data.aws_caller_identity.current.account_id}:key/${aws_kms_key.payment_ledger_key.id}"
      },

      # Permissions for DynamoDB: Put, Get, Query, Update, and Scan the specified table
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
      
      # Permissions for CloudWatch Logs: Create log group, stream, and put log events
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*"
      },

      # Permissions to interact with EC2 network interfaces (required if Lambda function is inside a VPC)
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ]
        Resource = "*"
      },

      # Backup Permissions for DynamoDB: List, Describe, Create, and Delete backups
      {
        Effect = "Allow"
        Action = [
          "dynamodb:ListTables",
          "dynamodb:DescribeTable",
          "dynamodb:ListStreams",
          "dynamodb:DescribeStream"
        ]
        Resource = "*"
      },

      {
        Effect = "Allow"
        Action = [
          "dynamodb:CreateBackup",
          "dynamodb:DeleteBackup",
          "dynamodb:DescribeBackup",
          "dynamodb:ListBackups"
        ]
        Resource = "arn:aws:dynamodb:${var.aws_region}:${data.aws_caller_identity.current.account_id}:table/${aws_dynamodb_table.payment_ledger.name}"
      }
    ]
  })
}
