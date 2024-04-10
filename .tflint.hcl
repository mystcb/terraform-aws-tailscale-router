# tflint configuration
# This file configures how tflint (github.com/terraform-linters/tflint) should scan the repository
# https://github.com/terraform-linters/tflint/blob/master/docs/user-guide/config.md

config {
  # Enable lint checks against Terraform Modules
  module     = true
  # Disables forcing a 0 return code on finding errors
  force      = false
}

# Enforce the standardised Terraform naming convention
# https://github.com/terraform-linters/tflint/blob/master/docs/rules/terraform_naming_convention.md
rule "terraform_naming_convention" {
  enabled = true
}

# Require Terraform Outputs to have descriptions
# https://github.com/terraform-linters/tflint/blob/master/docs/rules/terraform_documented_outputs.md
rule "terraform_documented_outputs" {
  enabled = true
}

# Require Terraform Variables to have descriptions
# https://github.com/terraform-linters/tflint/blob/master/docs/rules/terraform_documented_variables.md
rule "terraform_documented_variables" {
  enabled = true
}

# Require Terraform blocks to define required_version
# https://github.com/terraform-linters/tflint/blob/master/docs/rules/terraform_required_version.md
rule "terraform_required_version" {
    enabled = true
}

# Require Terraform Variables to have types declared
# https://github.com/terraform-linters/tflint/blob/master/docs/rules/terraform_typed_variables.md
rule "terraform_typed_variables" {
    enabled = true
}

# If using AWS, uncomment the block below to enable the plugin.
# You will then need to run `tflint --init` to download the plugin.
# pre-commit will automatically run this init if required.
# For more information about the ruleset:
#    https://github.com/terraform-linters/tflint-ruleset-aws#installation

plugin "aws" {
    enabled = true
    version = "0.29.0"
    source  = "github.com/terraform-linters/tflint-ruleset-aws"
}