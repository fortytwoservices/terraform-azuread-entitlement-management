<!-- BEGIN_TF_DOCS -->
# Terraform Module - Entra ID Entitlement Management

| :exclamation:  NB! |
|---|
| Due to the renaming of Company, the Github organization has changed name from "amestofortytwo" to "fortytwoservices". Pre-existing Terraform code would need to change that in code. |

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

## Destroy resources

At the time of writing, there is a hard dependency from the Microsoft Azure API that requires all Assignments of the Access Package to be removed before you are allowed to destroy it.
This is because there is no dedicated API call for force removing Assignments or the Access Package itself. After all Assignments have been deleted, you should be able to destroy all resources created by this module.

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>=1.4.6)

- <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) (>=2.39.0)

- <a name="requirement_msgraph"></a> [msgraph](#requirement\_msgraph) (>=0.2.0)

## Examples

### Basic example

```hcl
# This example contains a typical, basic deployment of an Entitlement Catalog, with an Access Package, an Assignment Policy, and AzureAD Groups used as resources.
# Most of the parameters and inputs are left to their default values, as they are typically the correct values in a common deployment.
# Refer to the [documentation](https://github.com/fortytwoservices/terraform-azuread-entitlement-management) for all available input parameters.

###   Terraform Providers
############################
terraform {
  required_version = ">=1.4.6"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=2.39.0"
    }
  }
}

###   Entra ID Groups
########################
locals {
  ad_groups = [
    "elm_approvers", # Azure AD Group whose members are allowed to approve Access Package requests
    "elm_approved"   # Azure AD Group that users will become member of when access request is approved
  ]
}

resource "azuread_group" "elm_groups" {
  for_each         = toset(local.ad_groups)
  display_name     = each.key
  security_enabled = true
}

###   Entra Entitlement Management
########################################
module "elm" {
  source  = "fortytwoservices/entitlement-management/azuread"
  version = "2.0.0"

  entitlement_catalogs = [                      # A list of Entitlement Catalogs, one object per Catalog
    {                                           #
      display_name = "${local.prefix}-catalog1" # Pretty Display Name for the Catalog
      description  = "ELM test catalog1"        # Description of the Catalog

      access_packages = [                                      # List of Access Packages, one object for each Access Package
        {                                                      #
          display_name     = "${local.prefix}-access_package1" # Pretty Display Name for the Access Package
          description      = "ELM test access package1"        # Description of the Access Package
          duration_in_days = 30                                # How many days the assignment is valid for. Conflicts with "expiration_date"

          primary_approvers = [
            {
              subject_type = "groupMembers"
              object_id    = azuread_group.elm_groups["elm_approvers"].object_id # Object ID of the Primary Approver(s)
            }
          ]

          assignment_review_settings = { # Review block that specifies how approvals is handled
            enabled = true               # Whether the assignment should be enabled or not. Defaults to true

            reviewers = [                                                          # List of reviewers. One object per reviewer
              {                                                                    #
                subject_type = "groupMembers"                                      # Type of reviewer. "singleUser", "groupMembers", "connectedOrganizationMembers", "requestorManager", "internalSponsors", "externalSponsors"
                object_id    = azuread_group.elm_groups["elm_approvers"].object_id # Object ID of the reviewer
              }
            ]
          }

          resources = [ # List of resources, one resource per object
            {
              display_name           = azuread_group.elm_groups["elm_approved"].display_name # Descriptive display name to be used for the Terraform Resource key
              resource_origin_system = "AadGroup"                                            # The type of resource in the origin system. "SharePointOnline", "AadApplication", "AadGroup"
              resource_origin_id     = azuread_group.elm_groups["elm_approved"].object_id    # The ID of the Azure resource to be added to the Catalog and Access Package
            }
          ]
        }
      ]
    }
  ]
}
```

### Advanced Example

```hcl
# This example contains a more advanced deployment of an Entitlement Catalog, with an Access Package, an Assignment Policy, and AzureAD Groups used as resources, specific requestors, additional justification etc.
# Most of the parameters and inputs are left to their default values, as they are typically the correct values in a common deployment.
# Refer to the [documentation](https://github.com/fortytwoservices/terraform-azuread-entitlement-management) for all available input parameters.

###   Terraform Providers
############################
terraform {
  required_version = ">=1.4.6"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=2.39.0"
    }
  }
}

###   Azure AD Groups
########################
locals {
  ad_groups = [
    "elm_requestors",            # Azure AD Group whose members are allowed to request access
    "elm_approvers",             # Azure AD Group whose members are allowed to approve Access Package requests
    "elm_alternative_approvers", # Azure AD Group whose members are alternative approvers of Access Package Requests
    "elm_approved"               # Azure AD Group that users will become member of when access request is approved
  ]
}

resource "azuread_group" "elm_groups" {
  for_each         = toset(local.ad_groups)
  display_name     = each.key
  security_enabled = true
}

###   Entra Entitlement Management
########################################
module "elm" {
  source  = "fortytwoservices/entitlement-management/azuread"
  version = "2.0.0"

  entitlement_catalogs = [                      # A list of Entitlement Catalogs, one object per Catalog
    {                                           #
      display_name = "${local.prefix}-catalog1" # Pretty Display Name for the Catalog
      description  = "ELM test catalog1"        # Description of the Catalog

      access_packages = [                                                         # List of Access Packages, one object for each Access Package
        {                                                                         #
          display_name                        = "${local.prefix}-access_package1" # Pretty Display Name for the Access Package
          description                         = "ELM test access package1"        # Description of the Access Package
          duration_in_days                    = 30                                # How many days the assignment is valid for. Conflicts with "expiration_date"
          requestor_justification_required    = true                              # Whether a requestor is required to provide a justification to request an access package. true, false. Defaults to false
          alternative_approval_enabled        = true                              # If approval review should time out and be forwarded to alternative approvers
          enable_alternative_approval_in_days = 7                                 # How many days until approvel review should be forwarded to alternative approvers

          primary_approvers = [
            {
              subject_type = "groupMembers"
              object_id    = azuread_group.elm_groups["elm_approvers"].object_id # Object ID of the Primary Approver(s)
            }
          ]

          alternative_approvers = [                                                          # List of Alternative Approvers, one object per approver
            {                                                                                #
              subject_type = "groupMembers"                                                  # # Type of approver. "singleUser", "groupMembers", "connectedOrganizationMembers", "requestorManager", "internalSponsors", "externalSponsors"
              object_id    = azuread_group.elm_groups["elm_alternative_approvers"].object_id # Object ID of the Primary Approver(s)
            }
          ]

          requestor_settings = {
            requests_accepted = true                              # Whether to accept requests using this policy. When false, no new requests can be made using this policy.
            scope_type        = "AllExistingDirectoryMemberUsers" # A Specifies the scope of the requestors. Valid values are AllConfiguredConnectedOrganizationSubjects, AllExistingConnectedOrganizationSubjects, AllExistingDirectoryMemberUsers, AllExistingDirectorySubjects, AllExternalSubjects, NoSubjects, SpecificConnectedOrganizationSubjects, or SpecificDirectorySubjects.

            requestor = {
              subject_type = "groupMembers"
              object_id    = "00000-00000-00000-00000" # The ID of the subject
            }
          }

          assignment_review_settings = { # Review block that specifies how approvals is handled
            enabled = true               # Whether the assignment should be enabled or not. Defaults to true

            reviewers = [                                                          # List of reviewers. One object per reviewer
              {                                                                    #
                subject_type = "groupMembers"                                      # Type of reviewer. "singleUser", "groupMembers", "connectedOrganizationMembers", "requestorManager", "internalSponsors", "externalSponsors"
                object_id    = azuread_group.elm_groups["elm_approvers"].object_id # Object ID of the reviewer
              }
            ]
          }

          question = [
            {
              required     = true                                                # Whether this question is requried. true, false. Defaults to false
              sequence     = 1                                                   # The sequence number of this question
              default_text = "What is your requirement for this Access Package?" # The default text of this question
            },
            {
              required     = true                      # Whether this question is requried. true, false. Defaults to false
              sequence     = 2                         # The sequence number of this question
              default_text = "What team are you from?" # The default text of this question

              choice = [                                     # List of choices for multiple choice. One object per choice
                { default_text = "Team A" },                 # The default text of this question choice
                { default_text = "Team B" },                 # The default text of this question choice
                {                                            #
                  default_text = "HR"                        # The default text of this question choice
                  actual_value = "corporate_human_resources" # The actual value of this choice. Defaults to default_text value
                }
              ]
            }
          ]

          resources = [ # List of resources, one resource per object
            {
              display_name           = azuread_group.elm_groups["elm_approved"].display_name # Descriptive display name to be used for the Terraform Resource key
              resource_origin_system = "AadGroup"                                            # The type of resource in the origin system. "SharePointOnline", "AadApplication", "AadGroup"
              resource_origin_id     = azuread_group.elm_groups["elm_approved"].object_id    # The ID of the Azure resource to be added to the Catalog and Access Package
            }
          ]
        }
      ]
    }
  ]
}
```

## Providers

The following providers are used by this module:

- <a name="provider_azuread"></a> [azuread](#provider\_azuread) (>=2.39.0)

- <a name="provider_msgraph"></a> [msgraph](#provider\_msgraph) (>=0.2.0)

## Resources

The following resources are used by this module:

- [azuread_access_package.access-packages](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/access_package) (resource)
- [azuread_access_package_assignment_policy.assignment_policies](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/access_package_assignment_policy) (resource)
- [azuread_access_package_catalog.entitlement-catalogs](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/access_package_catalog) (resource)
- [azuread_access_package_resource_catalog_association.resource-catalog-associations](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/access_package_resource_catalog_association) (resource)
- [azuread_access_package_resource_package_association.resource-access-package-associations](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/access_package_resource_package_association) (resource)
- [msgraph_resource_action.resource-access-package-associations](https://registry.terraform.io/providers/microsoft/msgraph/latest/docs/resources/resource_action) (resource)
- [msgraph_resource.resource_access_package_catalog_resource_roles](https://registry.terraform.io/providers/microsoft/msgraph/latest/docs/data-sources/resource) (data source)
- [msgraph_resource.resource_access_package_catalog_resources](https://registry.terraform.io/providers/microsoft/msgraph/latest/docs/data-sources/resource) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_entitlement_catalogs"></a> [entitlement\_catalogs](#input\_entitlement\_catalogs)

Description: A nested list of objects describing Access Packages, it's parent Catalogs, Assignment Policies and associated resources

Type:

```hcl
list(object({                         # List of Entitlement Catalogs, one object for each catalog
    display_name       = string                # Name of the Entitlement Catalog
    description        = optional(string)      # Description of the Entitlement Catalog
    externally_visible = optional(bool, false) # If the Entitlement Catalog should be visible outside of the Azure Tenant. true, false. Defaults to "false"
    published          = optional(bool, true)  # If the Access Packages in this catalog are available for management. true, false. Defaults to "true"

    access_packages = list(object({
      display_name      = string                # Name of the Access Package
      description       = optional(string)      # Description of the Access Package
      hidden            = optional(bool, false) # If the Access Package should be hidden from the requestor
      duration_in_days  = optional(number)      # How many days the assignment is valid for. Conflicts with "expiration_date"
      expiration_date   = optional(string)      # The date that this assignment expires, in RFC3339 format. Conflicts with "duration_in_days"
      extension_enabled = optional(bool, true)  # Whether users will be able to request extension before it expires. true, false. Defaults to true
      requests_accepted = optional(bool, true)  # Whether to accept requests using this policy. When false, no new requests can be made using this policy. true, false. Defaults to true
      scope_type        = optional(string)      # Deprecated! Use the setting in requestor_settings.scope_type. Specifies the scopes of the requestors. AllConfiguredConnectedOrganizationSubjects, AllExistingConnectedOrganizationSubjects, AllExistingDirectoryMemberUsers, AllExistingDirectorySubjects, AllExternalSubjects, NoSubjects, SpecificConnectedOrganizationSubjects, or SpecificDirectorySubjects Defaults to "AllExistingDirectoryMemberUsers".

      # Specified requestor requires scope_type SpecificDirectorySubjects or SpecificConnectedOrganizationSubjects. Defaults to SpecificDirectorySubjects.
      requestor_settings = optional(object({                                    # A block specifying the users who are allowed to request on this policy
        requests_accepted = optional(bool)                                      # Whether to accept requests using this policy. When false, no new requests can be made using this policy.
        scope_type        = optional(string, "AllExistingDirectoryMemberUsers") # A Specifies the scope of the requestors. Valid values are AllConfiguredConnectedOrganizationSubjects, AllExistingConnectedOrganizationSubjects, AllExistingDirectoryMemberUsers, AllExistingDirectorySubjects, AllExternalSubjects, NoSubjects, SpecificConnectedOrganizationSubjects, or SpecificDirectorySubjects.

        requestor = optional(object({
          subject_type = string           # Specifies the type of users. Valid values are singleUser, groupMembers, connectedOrganizationMembers, requestorManager, internalSponsors or externalSponsors
          object_id    = optional(string) # The ID of the subject
        }))
        }),
        {
          scope_type = "AllExistingDirectoryMemberUsers" # Defaults the requestor_settings value to use AllExistingDirectoryMemberUsers.
        }
      )

      approval_required                   = optional(bool, true)  # Whether an approval is required. true, false. Defaults to true
      approval_required_for_extension     = optional(bool, false) # Whether approval is required to grant extension. Same approval settings used to approve initial access will apply. true, false. Defaults to false
      requestor_justification_required    = optional(bool, false) # Whether a requestor is required to provide a justification to request an access package. true, false. Defaults to false
      approval_timeout_in_days            = optional(number, 14)  # Maximum number of days within which a request most be approved. Defaults to 14
      approver_justification_required     = optional(bool, false) # Whether an approver must provide a justification for their decision. Defaults to "false"
      alternative_approval_enabled        = optional(bool, false) # Whether alternative approvers are enabled. Defaults to false
      enable_alternative_approval_in_days = optional(number)      # Number of days before the request is forwarded to alternative approvers

      primary_approvers = optional(list(object({ # A list of objects, with one object for each Primary Approver
        subject_type = string                    # Specifies the type of user. singleUser, groupMembers, connectedOrganizationMembers, requestorManager, internalSponsors, or externalSponsors
        object_id    = string                    # Object ID of the Primary Approver
        backup       = optional(bool, false)     # For a user in an approval stage, this property indicates whether the user is a backup fallback appover
      })))

      alternative_approvers = optional(list(object({
        subject_type = string                # Type of approver. "singleUser", "groupMembers", "connectedOrganizationMembers", "requestorManager", "internalSponsors", "externalSponsors"
        object_id    = string                # Object ID of the Primary Approver
        backup       = optional(bool, false) # For a user in an approval stage, this property indicates whether the user is a backup fallback appover
      })))

      assignment_review_settings = optional(object({
        enabled                         = optional(bool, true)             # Whether the assignment should be enabled or not. Defaults to true
        review_frequency                = optional(string, "annual")       # How ofter reviews should happen. weekly, monthly, quarterly, halfyearly, annual. Defaults to annual
        duration_in_days                = optional(number, 14)             # How many days each occurrence of the access review series will run. Defaults to 14
        review_type                     = optional(string, "Self")         # Self review or specify reviewers. "Self", "Reviewers". Defaults to "self"
        access_review_timeout_behavior  = optional(string, "removeAccess") # What happens if access review times out. "keepAccess", "removeAccess", "acceptAccessRecommendation". Defaults to "removeAccess"
        approver_justification_required = optional(bool, false)            # Whether a reviewer needs to provide a justification for their decision

        reviewers = list(object({              # List of reviewers. One object per reviewer
          subject_type = string                # Type of reviewer. "singleUser", "groupMembers", "connectedOrganizationMembers", "requestorManager", "internalSponsors", "externalSponsors"
          object_id    = string                # Object ID of the reviewer
          backup       = optional(bool, false) # Indicates whether the user is a backup approver or not. "true", "false". Defaults to "false".
        }))
      }))

      question = optional(list(object({      # A list of questions. One object per question
        required     = optional(bool, false) # Whether this question is requried. true, false. Defaults to false
        sequence     = number                # The sequence number of this question
        default_text = string                # The default text of this question

        choice = optional(list(object({   # List of choices for multiple choice. One object per choice
          default_text = string           # The default text of this question choice
          actual_value = optional(string) # The actual value of this choice. Defaults to default_text value
        })))
      })))

      resources = list(object({                             # List of resources, one resource per object
        display_name           = optional(string)           # Deprecated! Descriptive display name to be used for the Terraform Resource key
        resource_origin_system = string                     # The type of resource in the origin system. "SharePointOnline", "AadApplication", "AadGroup"
        resource_origin_id     = string                     # The ID of the Azure resource to be added to the Catalog and Access Package
        access_type            = optional(string, "Member") # The role of access type to the specified resource. "Member", "Owner". Defaults to "Member"
      }))
    }))
  }))
```

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_access_packages"></a> [access\_packages](#output\_access\_packages)

Description: Outputs all Access Packages created through this module

### <a name="output_assignment_policies"></a> [assignment\_policies](#output\_assignment\_policies)

Description: Outputs all Access Package Assignment Policies created through this module

### <a name="output_entitlement_catalogs"></a> [entitlement\_catalogs](#output\_entitlement\_catalogs)

Description: Outputs all Entitlement Catalogs created through this module

### <a name="output_resource_access_package_associations"></a> [resource\_access\_package\_associations](#output\_resource\_access\_package\_associations)

Description: Outputs all Resources associated with the Access Packages

### <a name="output_resource_catalog_associations"></a> [resource\_catalog\_associations](#output\_resource\_catalog\_associations)

Description: Outputs all Resources associated with the Entitlement Catalogs

## Modules

No modules.

<!-- END_TF_DOCS -->