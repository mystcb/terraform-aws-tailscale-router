#
# Creation of an Instance Role for the Tailscale router
#

# Instance Profile Assume Policy Document
data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Creation of a role that allows both SSM and CloudWatch access for logging etc
resource "aws_iam_role" "this" {
  name = "${var.hostname}-EC2-IAM-Role"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
  "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

# Creation of an Instance Profile that allows the EC2 instance to assume the role
resource "aws_iam_instance_profile" "this" {
  name = "${var.hostname}-IAM-Profile"
  role = aws_iam_role.this.name
}