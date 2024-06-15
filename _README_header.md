# Terraform Module - Entra ID Governance - Entitlement Management

This module allows you to simply deploy and manage Entitlement Management resources in Entra ID Governance.

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

## Destroy resources

At the time of writing, there is a hard dependency from the Microsoft Azure API that requires all Assignments of the Access Package to be removed before you are allowed to destroy it.
This is because there is no dedicated API call for force removing Assignments or the Access Package itself. After all Assignments have been deleted, you should be able to destroy all resources created by this module.
