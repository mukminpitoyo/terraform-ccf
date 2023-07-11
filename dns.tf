# resource "aws_route53_record" "ccf-internal" {
#   name    = var.dns_name
#   records = [aws_eip.ccf.private_ip]
#   ttl     = "300"
#   type    = "A"
#   zone_id = "Z06550792HSO710Y0TS8G"
# }
