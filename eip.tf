# resource "aws_eip" "ccf" {
#   instance = module.ec2_instance.id
#   vpc      = true

#   lifecycle {
#     prevent_destroy = false
#   }

#   tags = {
#     Name = "terraform-ccf-eip-${var.environment}"
#   }
# }