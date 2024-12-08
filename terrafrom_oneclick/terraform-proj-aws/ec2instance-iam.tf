module "iam_policy_from_data_source" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.46.0"
  name        = "${var.environment}-BastionHost"
  path        = "/"
  description = "iam policy for bastion ec2"

  policy = data.aws_iam_policy_document.ec2-bastion.json

  tags = {
    PolicyDescription = "Policy created for bastion ec2 instance profile"
  }
}