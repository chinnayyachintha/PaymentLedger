# Payment Ledger Implementation

## Objective

This project implements a payment ledger system using AWS services to securely record payment transaction details. The transaction data is stored in the `PaymentLedger` DynamoDB table, with sensitive fields encrypted using AWS KMS.

## Architecture Overview

- **Lambda Function**: The Lambda function `persist_payment_ledger` processes and stores payment transaction data in DynamoDB after receiving the response from the payment processor.
- **DynamoDB**: The `PaymentLedger` table stores the payment transaction details with attributes like `TransactionID`, `SecureToken`, `Amount`, `ProcessorID`, `Status`, and `Timestamp`.
- **AWS KMS**: AWS Key Management Service (KMS) is used to encrypt sensitive fields, such as the `SecureToken`.
- **IAM Roles and Policies**: IAM roles and policies are configured to allow the Lambda function to access DynamoDB and KMS securely.

## DynamoDB Schema

The `PaymentLedger` DynamoDB table contains the following attributes:

- `TransactionID` (Primary Key): Unique transaction identifier.
- `SecureToken`: Encrypted token provided by the payment processor.
- `Amount`: Payment amount.
- `ProcessorID`: Payment processor used for the transaction.
- `Status`: Payment status (Success/Failure).
- `Timestamp`: Date and time of the transaction.

## Secure Connection to DynamoDB with AWS PrivateLink

This setup ensures a secure connection between your Lambda function and DynamoDB by using AWS PrivateLink. PrivateLink allows you to establish a private connection to the DynamoDB service, keeping traffic within the AWS network and ensuring that no data is exposed to the public internet.

- **VPC Configuration**: DynamoDB is accessed through a private subnet, and the Lambda function is configured to run within this VPC to ensure secure communication.
- **Security Groups**: A security group is used to control access to DynamoDB, allowing only authorized Lambda functions to interact with it securely.

## IAM Role and Permissions

The IAM role `paymentledger-role` grants the Lambda function the necessary permissions to interact with KMS for encryption and DynamoDB for data storage. The policy attached to the role allows the following actions:

- **KMS**: `kms:Encrypt`, `kms:Decrypt` for encrypting and decrypting sensitive data.
- **DynamoDB**: Permissions for operations like `PutItem`, `GetItem`, `Query`, `UpdateItem`, and `Scan`.
- **Logs**: Permissions for logging to CloudWatch.

## How to Deploy

1. Clone this repository.
2. Make sure your AWS credentials are set up correctly (using AWS CLI or environment variables).
3. Run `terraform init` to initialize the Terraform environment.
4. Run `terraform apply` to deploy the infrastructure.
