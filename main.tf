#
# Creation of the Tailnet router on an EC2 instance in AWS
#

# Create an authorization token for the Tailscale router to add itself to the Tailnet
resource "tailscale_tailnet_key" "this" {
  reusable      = true
  ephemeral     = false
  preauthorized = true
  expiry        = 7776000
  description   = "Tailnet key for ${split(".", var.hostname)[0]}"
}

# Create an Elastic IP for the Tailscale router to use (if required)
resource "aws_eip" "this" {
  instance                  = aws_instance.this.id
  associate_with_private_ip = aws_instance.this.private_ip
}

# Use a data object to get the latest version of Ubuntu
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

# Build the Tailscale router using Ubuntu 22.04 LTS
resource "aws_instance" "this" {

  # General setup of the instance using the Ubuntu AMI
  ami                     = data.aws_ami.ubuntu.id
  ebs_optimized           = true
  instance_type           = var.instance_size # TODO: Make this selectable
  disable_api_termination = true

  # Key for SSH Access (if required)
  key_name = try(var.ssh_key_name, null)

  # Run the user_data for this instance to install Tailscale
  user_data = templatefile("${path.module}/templates/tailscale-install.sh.tpl",
    {
      ts_authkey  = tailscale_tailnet_key.this.key
      hostname    = var.hostname
      local_cidrs = var.local_cidrs
    }
  )

  # Networking Settings
  source_dest_check      = false # Disabled to allow IP forwarding from the network
  private_ip             = var.private_ip
  ipv6_addresses         = var.ipv6_addresses
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.this.id]

  # Monitoring Settings
  monitoring = true

  # IAM Role Attachments
  iam_instance_profile = aws_iam_instance_profile.this.name

  # Enable Meta Data
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  # Disk setup
  root_block_device {
    volume_type           = "gp3"
    volume_size           = "20"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name = var.hostname
  }
}