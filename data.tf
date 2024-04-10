#
# Specific data entries which are used around this module
#

# Get the subnet details from the provided subnet ID
data "aws_subnet" "this" {
  id = var.subnet_id
}