# Backend configuration (best practice: use a remote backend for state, locking, and encryption).
# Left commented initially to allow quick local init. Uncomment and configure one of the examples below.

/* Example: Terraform Cloud
terraform {
  backend "remote" {
    organization = "YOUR_TFC_ORG"
    workspaces {
      name = "tgw-poc"
    }
  }
}
*/

/* Example: S3 backend (requires pre-created bucket, DynamoDB table, and optional KMS key)
terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "tgw-poc/terraform.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
    kms_key_id     = "arn:aws:kms:ap-southeast-2:111122223333:key/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  }
}
*/


