data "aws_s3_bucket" "billing_data_bucket" {
  bucket = "cloud-carbon-footprint-template-billingdatabucket-1ugv45rw0rnk5"
}

data "aws_s3_bucket" "athena_query_results_bucket" {
  bucket = "cloud-carbon-footprint-t-athenaqueryresultsbucket-12os0754y9pke"
}
