data "aws_s3_bucket" "billing_data_bucket" {
  bucket = "cloud-carbon-footprint-billingdatabucket-kkkfb7frhuml"
}

data "aws_s3_bucket" "athena_query_results_bucket" {
  bucket = "cloud-carbon-footprint-athenaqueryresultsbucket-24mjc7ujxotx"
}
