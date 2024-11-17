output "kms_key_arn" {
  description = "ARN of the KMS Key for encryption"
  value       = aws_kms_key.payment_ledger_key.arn
}

output "dynamodb_table_name" {
  description = "Name of the PaymentLedger DynamoDB table"
  value       = aws_dynamodb_table.payment_ledger.name
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function for persisting payment ledger"
  value       = aws_lambda_function.persist_payment_ledger.arn
}

output "iam_role_arn" {
  description = "ARN of the IAM Role used by the Lambda function"
  value       = aws_iam_role.paymentledger_role.arn
}


# Backup outputs
# Output the ARN of the Backup Vault
output "payment_ledger_backup_vault_arn" {
  value = aws_backup_vault.payment_ledger_vault.arn
  description = "The ARN of the payment ledger backup vault"
}

# Output the name of the Backup Vault
output "payment_ledger_backup_vault_name" {
  value = aws_backup_vault.payment_ledger_vault.name
  description = "The name of the payment ledger backup vault"
}

# Output the Backup Plan ID
output "payment_ledger_backup_plan_id" {
  value = aws_backup_plan.payment_ledger_backup_plan.id
  description = "The ID of the payment ledger backup plan"
}

# Output the ARN of the IAM Role used by AWS Backup
output "payment_ledger_backup_role_arn" {
  value = aws_iam_role.backup_role.arn
  description = "The ARN of the IAM role used for AWS Backup"
}

# Output the Backup Selection ID (not ARN as the ARN is not supported)
output "payment_ledger_backup_selection_id" {
  value = aws_backup_selection.payment_ledger_backup_selection.id
  description = "The ID of the backup selection"
}

# Output the DynamoDB Table ARN
output "payment_ledger_dynamodb_table_arn" {
  value = aws_dynamodb_table.payment_ledger.arn
  description = "The ARN of the DynamoDB payment ledger table"
}
