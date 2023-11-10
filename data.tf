data "aws_s3_bucket" "billing_data_bucket" {
  bucket = "cloud-carbon-footprint-billingdatabucket-kkkfb7frhuml"
}

data "aws_s3_bucket" "athena_query_results_bucket" {
  bucket = "cloud-carbon-footprint-athenaqueryresultsbucket-24mjc7ujxotx"
}

data "aws_secretsmanager_secret_version" "CCF_MONGODB_URI" {
  secret_id = "CCF_MONGODB_URI"
}

data "aws_secretsmanager_secret_version" "CCF_AWS_BILLING_ACCOUNT_NAME" {
  secret_id = "CCF_AWS_BILLING_ACCOUNT_NAME"
}

data "aws_secretsmanager_secret_version" "CCF_AWS_BILLING_ACCOUNT_ID" {
  secret_id = "CCF_AWS_BILLING_ACCOUNT_ID"
}

data "aws_secretsmanager_secret_version" "CCF_AWS_ATHENA_QUERY_RESULT_LOCATION" {
  secret_id = "CCF_AWS_ATHENA_QUERY_RESULT_LOCATION"
}

data "aws_secretsmanager_secret_version" "CCF_AWS_ATHENA_REGION" {
  secret_id = "CCF_AWS_ATHENA_REGION"
}

data "aws_secretsmanager_secret_version" "CCF_AWS_ATHENA_DB_TABLE" {
  secret_id = "CCF_AWS_ATHENA_DB_TABLE"
}

data "aws_secretsmanager_secret_version" "CCF_AWS_ATHENA_DB_NAME" {
  secret_id = "CCF_AWS_ATHENA_DB_NAME"
}

data "aws_secretsmanager_secret_version" "CCF_AWS_TARGET_ACCOUNT_ROLE_NAME" {
  secret_id = "CCF_AWS_TARGET_ACCOUNT_ROLE_NAME"
}