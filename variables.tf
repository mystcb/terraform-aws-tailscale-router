#
# List of all the variables to make this work
#

variable "hostname" {
  description = "(Required) Hostname for the Tailscale router - Fully Qualitied Domain Name (FQDN) e.g. tailscale.example.com"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+([-.][a-z0-9]+)*$|^[a-z0-9]+([-.][a-z0-9]+)*\\.[a-z]{2,}$", var.hostname))
    error_message = "Invalid hostname format. Must be a fully qualified domain name (FQDN) or a single name e.g. tailscale.example.com, tailscale"
  }
}

variable "subnet_id" {
  description = "(Required) Suubnet ID for where the Tailscale router will sit inside your network. e.g. subnet-00000000000000000"
  type        = string

  validation {
    condition     = can(regex("^subnet(-[a-zA-Z0-9]{8,}){1,2}$", var.subnet_id))
    error_message = "Invalid Subnet ID. Must be a valid subnet ID e.g. subnet-00000000000000000"
  }
}

variable "local_cidrs" {
  description = "(Required) List of CIDRs that this router will advertise to the Tailscale network. e.g. 10.0.0.0/24,10.0.1.0/24"
  type        = string

  validation {
    condition     = can(regex("^([0-9]{1,3}[.]){3}[0-9]{1,3}(/[0-9]{1,2})?$", var.local_cidrs))
    error_message = "Invalid list of CIDRs. Must be a list of CIDRs e.g. 10.0.0.0/24,10.0.1.0/24"
  }
}

variable "instance_size" {
  description = "(Required) EC2 instance type for the Tailscale Router (needs to be a t4g.* instance type. e.g. t4g.medium, default t4g.small"
  type        = string
  default     = "t4g.small"

  validation {
    condition = contains([
      "t4g.nano",
      "t4g.micro",
      "t4g.small",
      "t4g.medium",
      "t4g.large",
      "t4g.xlarge",
      "t4g.2xlarge"
    ], var.instance_size)
    error_message = "The instance_size value must be a valid t4g instance type."
  }
}

variable "ssh_key_name" {
  description = "(Optional) The SSH Keyname that will be used on the Tailscale router. e.g. tailscale"
  type        = string
  default     = null
}

variable "private_ip" {
  description = "(Optional) Set a static private IP of the Tailscale router. e.g. 10.0.0.10"
  type        = string
  default     = null

  validation {
    condition     = can(regex("^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", var.private_ip))
    error_message = "Must be a valid IPv4 address e.g. 10.0.0.10"
  }
}

variable "ipv6_addresses" {
  description = "(Optional) Set a static IPv6 address of the Tailscale router. e.g. 2001:db8::1"
  type        = list(string)
  default     = null
}