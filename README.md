# Terraform AzureAD - Entitlement Catalog
### terraform-azuread-entitlement-management

---

# ***THIS MODULE IS UNDER DEVELOPMENT AND NOT YET RELEASED. BREAKING CHANGES MAY OCCUR WITHOUT WARNING***

---

This module allows you to simply do Entitlement Management in Azure AD through Catalogs and Access Packages. 

The input to the module is based on Access Packages, but the information is used to create both Catalogs, Access Packages, Assignment Policies and assigning resources to both the Catalogs and Access Packages.

This module aims to simplify the definition of all the resources as much as possible, but all parameter values are identical to the actual azuread resource parameters.

All optional values are described in the input variable documentation, with it's default values.