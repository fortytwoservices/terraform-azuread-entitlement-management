# Test validation for the basic example
# This uses Terraform's native test framework to validate the example configuration

run "validate_basic_example" {
  command = plan

  module {
    source = "./examples/basic"
  }
}

