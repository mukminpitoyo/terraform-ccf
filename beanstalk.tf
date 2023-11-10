# Defining the Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "ccf_terraform_app" {
  name        = "govtech-ccf-beanstalk-app"
  description = "GovTech Cloud Carbon Footprint Calculator Application"
}

# # Defining the Elastic Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "ccf_terraform_env" {
  name                = "govtech-ccf-env"
  application         = aws_elastic_beanstalk_application.ccf_terraform_app.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.1.0 running Docker"

  # Configuring Elastic Beanstalk env with necessary  settings
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = aws_vpc.govtech_ccf_vpc.id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${join(",", 
    [aws_subnet.private_a.id], 
    [aws_subnet.private_b.id])}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "MONGODB_URI"
    value     = jsondecode(data.aws_secretsmanager_secret_version.CCF_MONGODB_URI.secret_string)["MONGODB_URI"]
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AWS_BILLING_ACCOUNT_NAME"
    value     = jsondecode(data.aws_secretsmanager_secret_version.CCF_AWS_BILLING_ACCOUNT_NAME.secret_string)["AWS_BILLING_ACCOUNT_NAME"]
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AWS_BILLING_ACCOUNT_ID"
    value     = jsondecode(data.aws_secretsmanager_secret_version.CCF_AWS_BILLING_ACCOUNT_ID.secret_string)["AWS_BILLING_ACCOUNT_ID"]
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AWS_ATHENA_QUERY_RESULT_LOCATION"
    value     = jsondecode(data.aws_secretsmanager_secret_version.CCF_AWS_ATHENA_QUERY_RESULT_LOCATION.secret_string)["AWS_ATHENA_QUERY_RESULT_LOCATION"]
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AWS_ATHENA_REGION"
    value     = jsondecode(data.aws_secretsmanager_secret_version.CCF_AWS_ATHENA_REGION.secret_string)["AWS_ATHENA_REGION"]
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AWS_ATHENA_DB_TABLE"
    value     = jsondecode(data.aws_secretsmanager_secret_version.CCF_AWS_ATHENA_DB_TABLE.secret_string)["AWS_ATHENA_DB_TABLE"]
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AWS_ATHENA_DB_NAME"
    value     = jsondecode(data.aws_secretsmanager_secret_version.CCF_AWS_ATHENA_DB_NAME.secret_string)["AWS_ATHENA_DB_NAME"]
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AWS_TARGET_ACCOUNT_ROLE_NAME"
    value     = jsondecode(data.aws_secretsmanager_secret_version.CCF_AWS_TARGET_ACCOUNT_ROLE_NAME.secret_string)["AWS_TARGET_ACCOUNT_ROLE_NAME"]
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.govtech_ccf_terraform_instance_profile.name
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = aws_security_group.instance.id
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = "cloud-carbon-footprint"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t3.medium"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "classic"
  }

  # Turn on Listener for HTTPS
  setting {
    namespace = "aws:elb:listener:443"
    name      = "ListenerEnabled"
    value     = "true"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "LoadBalanced"
  }

  setting {
    namespace = "aws:elb:loadbalancer"
    name      = "CrossZone"
    value     = "true"  # Enable cross-zone load balancing
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = join(",", [
      aws_subnet.public_a.id,
      aws_subnet.public_b.id
    ])
  }

  setting {
    namespace = "aws:elb:loadbalancer"
    name      = "SecurityGroups"
    value     = aws_security_group.elb.id
  }
}