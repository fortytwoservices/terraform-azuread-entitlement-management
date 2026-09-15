# Test validation for the advanced example  
# This uses Terraform's native test framework to validate the example configuration

run "validate_advanced_example" {
  command = plan

  module {
    source = "./examples/advanced"
  }
}

