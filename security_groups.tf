#
# Security Group for the Tailscale router
#

#
resource "aws_security_group" "this" {
  name                   = "${var.hostname}-SG"
  description            = "Security Group for the ${var.hostname} EC2 instance"
  revoke_rules_on_delete = true
  tags = {
    "Name" = "${var.hostname}-SG"
  }
  vpc_id = data.aws_subnet.this.vpc_id
}


#
# Rules for the Security Group
#

# Egress traffic outbound
#tfsec:ignore:AWS007  tfsec:ignore:aws-vpc-no-public-egress-sgr
resource "aws_security_group_rule" "this_sg_outbound_allow" {
  description       = "Allow traffic to the internet"
  type              = "egress"
  from_port         = "-1"
  to_port           = "-1"
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}

# Egress traffic outbound (IPv6)
#tfsec:ignore:AWS007  tfsec:ignore:aws-vpc-no-public-egress-sgr
resource "aws_security_group_rule" "this_sg_outbound_allow_ipv6" {
  description       = "Allow traffic to the internet"
  type              = "egress"
  from_port         = "-1"
  to_port           = "-1"
  protocol          = "all"
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.this.id
}


# ICMP traffic allow
#tfsec:ignore:AWS006 tfsec:ignore:AWS008 tfsec:ignore:AWS009 tfsec:ignore:aws-ec2-no-public-ingress-sgr
resource "aws_security_group_rule" "this_sg_icmp_allow" {
  description       = "Allow ICMP traffic from the Internet"
  type              = "ingress"
  from_port         = "-1"
  to_port           = "-1"
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}

# ICMP traffic allow
#tfsec:ignore:AWS006 tfsec:ignore:AWS008 tfsec:ignore:AWS009 tfsec:ignore:aws-ec2-no-public-ingress-sgr
resource "aws_security_group_rule" "this_sg_icmpv6_allow" {
  description       = "Allow ICMP traffic from the Internet"
  type              = "ingress"
  from_port         = "-1"
  to_port           = "-1"
  protocol          = "icmpv6"
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.this.id
}