# AWS KMS Key for Encryption

resource "aws_kms_key" "payment_key" {
  description             = "KMS Key for Payment Encryption"
  deletion_window_in_days = 7
}

resource "aws_kms_alias" "payment_key_alias" {
  name          = "alias/paymentledger-key"
  target_key_id = aws_kms_key.payment_key.key_id
}