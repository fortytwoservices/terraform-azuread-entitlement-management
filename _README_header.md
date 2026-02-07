# Terraform Module - Entra ID Entitlement Management

This module allows you to simply deploy and manage Entitlement Management resources in Entra Identity Governance.

The input to the module is based on Access Packages, but the information is used to create both Catalogs, Access Packages, Assignment Policies and assigning resources to both the Catalogs and Access Packages.

This module aims to simplify the definition of all the resources as much as possible, but all parameter values are identical to the actual azuread resource parameters. You will find that default values are applied as often as possible, this is in persuit of as simple of a deployment as possible.

All optional values are described in the input variable documentation, with it's default values.

## Resources deployed by this module

Which resources, and how many of each depends on your configuration

- Entitlement Catalogs
- Access Packages
- Assignment Policies
- Entitlement Catalog Resource associations
- Access Package Resource associations

Complete list of all Terraform resources deployed is provided at the bottom of this page

## Testing

This module includes automated testing for both basic and advanced examples using Terraform validation.

### Running Tests Locally

Use the provided Makefile to run tests:

```bash
# Run all tests (basic and advanced examples)
make test

# Run tests for specific examples
make test-basic
make test-advanced

# Validate all configurations
make validate

# Format Terraform files
make fmt

# Clean up test artifacts
make clean
```

### CI/CD

Tests are automatically run on pull requests via GitHub Actions. The workflow validates:
- Terraform formatting
- Root module configuration
- Basic example configuration
- Advanced example configuration

## Destroy resources

At the time of writing, there is a hard dependency from the Microsoft Azure API that requires all Assignments of the Access Package to be removed before you are allowed to destroy it.
This is because there is no dedicated API call for force removing Assignments or the Access Package itself. After all Assignments have been deleted, you should be able to destroy all resources created by this module.
