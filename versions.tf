terraform {
  required_version = ">= 1.6.0, < 1.7.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.36"
    }

    tailscale = {
      source  = "tailscale/tailscale"
      version = ">= 0.15.0"
    }
  }
}
