# Test for the basic example
# This test validates that the basic example can be successfully planned

run "basic_example_plan" {
  command = plan

  module {
    source = "../examples/basic"
  }

  variables {
    # Override variables if needed for testing
  }

  # Validate that the module creates the expected resources
  assert {
    condition     = length(module.elm.entitlement_catalogs) > 0
    error_message = "Expected at least one entitlement catalog to be created"
  }
}
