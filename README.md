# Tailscale Router on AWS EC2 instances - Terraform Module

This module creates a [Tailscale Subnet Router](https://tailscale.com/kb/1019/subnets) in AWS on an [Graviton](https://aws.amazon.com/ec2/graviton/) based [EC2 instance](https://aws.amazon.com/ec2/).

[Tailscale](https://tailscale.com/) is a [Zero Trust Network](https://en.wikipedia.org/wiki/Zero_trust_security_model) VPN service that enables globally distributed devices to act as if they are on the same network. This is a specific type of Tailscale node is a Subnet router that allows private traffic to be advertised across the Tailnet and traffic routed too and from AWS.

This is mainly made up of an AWS Graviton (ARM) EC2 instance that runs the Tailscale VPN software specifically set up to accept routes from the rest of the Tailnet and advertise a set of CIDR's across the network. This includes setting up IP Forwarding on the instance, and disabling Source/Destination Check on the EC2 instance, making it a router within a VPC.

The main configuration is completed as part of the `user_data` element to call the [tailscale-install.sh](./templates/tailscale-install.sh.tpl) file. This file:

- Sets the hostname of the instance
- Updated the node using `apt` to the latest modules
- Enables IP Forwarding
- Install's Tailscale from the [Tailscale APT repository](https://pkgs.tailscale.com/stable/#ubuntu)
- Starts up Tailscale using the Authentication Key, and Advertised Routes

It will be required to include the [Tailscale Provider](https://registry.terraform.io/providers/tailscale/tailscale/latest/docs) within your configuration to have this module run, otherwise the keys can't be generated to add the router to the Tailscale network. Note that you can use either environment variables or enter in the details in a `provider` block to configure access.

## Usage - Minimal Example

```terraform
terraform {
    .....
    required_providers {
        ....
        tailscale = {
            source  = "tailscale/tailscale
            version = ">= 0.15.0"
        }
        ....
    }
}

module "tailscale_router" {
  source = "./path/to/module"

  hostname       = "hostname.example.com"
  subnet_id      = " subnet-00000000000000000"
  local_cidrs    = "10.0.0.0/24"
}
```

## Usage - Exhaustive Example

```terraform
terraform {
    .....
    required_providers {
        ....
        tailscale = {
            source  = "tailscale/tailscale
            version = ">= 0.15.0"
        }
        ....
    }
}

provider "tailscale" {
    api_key = "my_api_key"
    tailnet = "example.com"
}

module "tailscale_router" {
  source = "./path/to/module"

  hostname       = "hostname.example.com"
  subnet_id      = " subnet-00000000000000000"
  local_cidrs    = "10.0.0.0/24,10.10.0.0/24"
  instance_size  = "t4g.medium"
  ssh_key_name   = "key_name"
  private_ip     = "10.0.0.10"
  ipv6_addresses = ["2001:db8::10]
}
```

---

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0, < 1.7.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.36 |
| <a name="requirement_tailscale"></a> [tailscale](#requirement\_tailscale) | >= 0.15.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_instance_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.this_sg_icmp_allow](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.this_sg_icmpv6_allow](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.this_sg_outbound_allow](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.this_sg_outbound_allow_ipv6](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [tailscale_tailnet_key.this](https://registry.terraform.io/providers/tailscale/tailscale/latest/docs/resources/tailnet_key) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_iam_policy_document.instance_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_subnet.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_hostname"></a> [hostname](#input\_hostname) | (Required) Hostname for the Tailscale router - Fully Qualitied Domain Name (FQDN) e.g. tailscale.example.com | `string` | n/a | yes |
| <a name="input_instance_size"></a> [instance\_size](#input\_instance\_size) | (Required) EC2 instance type for the Tailscale Router (needs to be a t4g.* instance type. e.g. t4g.medium, default t4g.small | `string` | `"t4g.small"` | no |
| <a name="input_ipv6_addresses"></a> [ipv6\_addresses](#input\_ipv6\_addresses) | (Optional) Set a static IPv6 address of the Tailscale router. e.g. 2001:db8::1 | `list(string)` | `null` | no |
| <a name="input_local_cidrs"></a> [local\_cidrs](#input\_local\_cidrs) | (Required) List of CIDRs that this router will advertise to the Tailscale network. e.g. 10.0.0.0/24,10.0.1.0/24 | `string` | n/a | yes |
| <a name="input_private_ip"></a> [private\_ip](#input\_private\_ip) | (Optional) Set a static private IP of the Tailscale router. e.g. 10.0.0.10 | `string` | `null` | no |
| <a name="input_ssh_key_name"></a> [ssh\_key\_name](#input\_ssh\_key\_name) | (Optional) The SSH Keyname that will be used on the Tailscale router. e.g. tailscale | `string` | `null` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | (Required) Suubnet ID for where the Tailscale router will sit inside your network. e.g. subnet-00000000000000000 | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tailscale_instance"></a> [tailscale\_instance](#output\_tailscale\_instance) | Details of the Tailscale Router Instance |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
