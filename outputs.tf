#
# Outputs from this module
#

output "tailscale_instance" {
  description = "Details of the Tailscale Router Instance"
  value       = aws_instance.this
}