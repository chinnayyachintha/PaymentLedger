# Tokenizes payment data securely using AWS KMS.
# Stores the tokenized SecureToken in the DynamoDB table (PaymentLedger).

import boto3
import json
import os
from datetime import datetime, timezone

# Initialize AWS services
dynamodb = boto3.resource('dynamodb')
kms = boto3.client('kms')

# Retrieve environment variables
kms_key_arn = os.environ['PAYMENT_CRYPTOGRAPHY_KEY_ARN']
table_name = os.environ['DYNAMODB_TABLE_NAME']

# Get DynamoDB table reference
table = dynamodb.Table(table_name)

# Encrypt SecureToken with KMS
def encrypt_token(token):
    response = kms.encrypt(
        KeyId=kms_key_arn,
        Plaintext=token
    )
    return response['CiphertextBlob']

# Lambda function to persist payment
def persist_payment_ledger(event, context):
    # Retrieve input data from event
    transaction_id = event['TransactionID']
    secure_token = event['SecureToken']
    amount = event['Amount']
    processor_id = event['ProcessorID']
    status = event['Status']
    
    # Encrypt the SecureToken using KMS
    encrypted_token = encrypt_token(secure_token)
    
    # Get current UTC time as a timezone-aware object
    timestamp = datetime.now(timezone.utc).isoformat()

    # Store encrypted data in DynamoDB
    table.put_item(
        Item={
            'TransactionID': transaction_id,
            'SecureToken': encrypted_token,
            'Amount': amount,
            'ProcessorID': processor_id,
            'Status': status,
            'Timestamp': timestamp
        }
    )
    return {
        'statusCode': 200,
        'body': json.dumps('Payment transaction recorded successfully')
    }
