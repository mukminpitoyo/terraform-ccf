# resource "aws_s3_bucket" "ccf_terraform_state" {
#   bucket = var.terraform_state_bucket
# }

# resource "aws_s3_bucket_versioning" "ccf_terraform_state_versioning" {
#   bucket = aws_s3_bucket.ccf_terraform_state.id

#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "ccf_terraform_state_encryption" {
#   bucket = aws_s3_bucket.ccf_terraform_state.id

#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#     }
#   }
# }

# Creating VPC, IGW
resource "aws_vpc" "govtech_ccf_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "govtech_ccf_vpc"
  }
}

resource "aws_internet_gateway" "ccf_terraform_igw" {
  vpc_id = aws_vpc.govtech_ccf_vpc.id
  tags = {
    Name = "CCF-Terraform-Internet-Gateway"
  }
}

# Creating NAT Gateways and Elastic IPs for each subnet
resource "aws_nat_gateway" "ccf_terraform_nat_a" {
  allocation_id = aws_eip.ccf_terraform_nat_a.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name = "CCF-Terraform-NAT-Gateway-a"
  }
}

resource "aws_nat_gateway" "ccf_terraform_nat_b" {
  allocation_id = aws_eip.ccf_terraform_nat_b.id
  subnet_id     = aws_subnet.public_b.id

  tags = {
    Name = "CCF-Terraform-NAT-Gateway-b"
  }
}

resource "aws_eip" "ccf_terraform_nat_a" {
  vpc = true
}

resource "aws_eip" "ccf_terraform_nat_b" {
  vpc = true
}

# Creating 2x public subnets, 1 for each AZ
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.govtech_ccf_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "CCF-Terraform-Public-Subnet-1a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.govtech_ccf_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-southeast-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "CCF-Terraform-Public-Subnet-1b"
  }
}

# Creating 2x private subnets, 1 for each AZ
resource "aws_subnet" "private_a" {
  vpc_id                  = aws_vpc.govtech_ccf_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "CCF-Terraform-Private-Subnet-1a"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id                  = aws_vpc.govtech_ccf_vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "ap-southeast-1b"
  map_public_ip_on_launch = false
  tags = {
    Name = "CCF-Terraform-Private-Subnet-1b"
  }
}

# Creating Public Route Table with Associations to Public Subnets
resource "aws_route_table" "ccf_terraform_route_table_public" {
  vpc_id = aws_vpc.govtech_ccf_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ccf_terraform_igw.id
  }

  tags = {
    Name = "CCF-Terraform-route-table-public"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.ccf_terraform_route_table_public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.ccf_terraform_route_table_public.id
}

# Creating Private Route Table A for Subnet A
resource "aws_route_table" "ccf_terraform_route_table_private_a" {
  vpc_id = aws_vpc.govtech_ccf_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ccf_terraform_nat_a.id
  }

  tags = {
    Name = "CCF-Terraform-route-table-private-a"
  }
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.ccf_terraform_route_table_private_a.id
}

# Creating Private Route Table B for Subnet B
resource "aws_route_table" "ccf_terraform_route_table_private_b" {
  vpc_id = aws_vpc.govtech_ccf_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ccf_terraform_nat_b.id
  }

  tags = {
    Name = "CCF-Terraform-route-table-private-b"
  }
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.ccf_terraform_route_table_private_b.id
}

# Creating Security Group for EC2 instances
resource "aws_security_group" "instance" {
  name_prefix = "CCF-Terraform-instance-"
  vpc_id      = aws_vpc.govtech_ccf_vpc.id

  # Ingress rules for allowing RDP and HTTP access from anywhere
  ingress {
    description = "RDP from anywhere"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "MySQL from anywhere"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rule to allow all traffic to go anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "elb" {
  name_prefix = "ccf-terraform-elb-"
  vpc_id      = aws_vpc.govtech_ccf_vpc.id

  # Add inbound rules to allow traffic on port 80 and other necessary ports
  # You can customize the security group rules based on your application requirements.

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rule to allow all traffic to go anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creating Instance Profile
resource "aws_iam_instance_profile" "govtech_ccf_terraform_instance_profile" {
  name = "govtech-ccf-terraform-instance-profile"
  role = aws_iam_role.govtech_ccf_role.id
}