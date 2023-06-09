<!-- BEGIN_TF_DOCS -->
# Terraform Module - AzureAD Entitlement Management

**By Amesto Fortytwo**

---

# ***THIS MODULE IS UNDER DEVELOPMENT AND NOT YET RELEASED. BREAKING CHANGES MAY OCCUR WITHOUT WARNING***

---

This module allows you to simply deploy and manage Entitlement Management resources in Azure AD Identity Governance.

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

*Complete list of all Terraform resources deployed is provided at the bottom of this page*

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.4.6 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >=2.39.0 |

## Example

```hcl
# This example contains a typical, basic deployment of an Entitlement Catalog, with an Access Package, an Assignment Policy, and AzureAD Groups used as resources.
# Most of the parameters and inputs are left to their default values, as they are typically the correct values in a common deployment.
# Refer to the [documentation](https://github.com/amestofortytwo/terraform-azuread-entitlement-management) for all available input parameters.
```

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | >=2.39.0 |

## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access-packages"></a> [access-packages](#input\_access-packages) | A nested list of objects describing Access Packages, it's parent Catalogs, Assignment Policies and associated resources | <pre>list(object({<br>    entitlement_catalogs = list(object({         # A list of Entitlement Catalogs, one object for each catalog<br>      display_name       = string                # Name of the Entitlement Catalog<br>      description        = optional(string)      # Description of the Entitlement Catalog<br>      externally_visible = optional(bool, false) # If the Entitlement Catalog should be visible outside of the Azure Tenant. true, false. Defaults to "false"<br>      published          = optional(bool, true)  # If the Access Packages in this catalog are available for management. true, false. Defaults to "true"<br><br>      access_packages = object({<br>        display_name      = string                                              # Name of the Access Package<br>        description       = optional(string)                                    # Description of the Access Package<br>        hidden            = optional(bool, false)                               # If the Access Package should be hidden from the requestor<br>        duration_in_days  = optional(number)                                    # How many days the assignment is valid for. Conflicts with "expiration_date"<br>        expiration_date   = optional(string)                                    # The date that this assignment expires, in RFC3339 format. Conflicts with "duration_in_days"<br>        extension_enabled = optional(bool, true)                                # Whether users will be able to request extension before it expires. true, false. Defaults to true<br>        requests_accepted = optional(bool, true)                                # Whether to accept requests using this policy. When false, no new requests can be made using this policy. true, false. Defaults to true<br>        scope_type        = optional(string, "AllExistingDirectoryMemberUsers") # Specifies the scopes of the requestors. AllConfiguredConnectedOrganizationSubjects, AllExistingConnectedOrganizationSubjects, AllExistingDirectoryMemberUsers, AllExistingDirectorySubjects, AllExternalSubjects, NoSubjects, SpecificConnectedOrganizationSubjects, or SpecificDirectorySubjects Defaults to "AllExistingDirectoryMemberUsers".<br><br>        requestor = optional(object({     # A block specifying the users who are allowed to request on this policy<br>          object_id    = optional(string) # Object ID of the requestor(s)<br>          subject_type = optional(string) # Type of requestor. "singleUser", "groupMembers", "connectedOrganizationMembers",<br>        }))                               # "requestorManager", "internalSponsors", "externalSponsors"<br><br>        approval_required                   = optional(bool, true)  # Whether an approval is required. true, false. Defaults to true<br>        approval_required_for_extension     = optional(bool, false) # Whether approval is required to grant extension. Same approval settings used to approve initial access will apply. true, false. Defaults to false<br>        requestor_justification_required    = optional(bool, false) # Whether a requestor is required to provide a justification to request an access package. true, false. Defaults to false<br>        approval_timeout_in_days            = optional(number, 14)  # Maximum number of days within which a request most be approved. Defaults to 14<br>        approver_justification_required     = optional(bool, false) # Whether an approver must provide a justification for their decision. Defaults to "false"<br>        alternative_approval_enabled        = optional(bool, false) # Whether alternative approvers are enabled. Defaults to false<br>        enable_alternative_approval_in_days = optional(number)      # Number of days before the request is forwarded to alternative approvers<br>        primary_approver_subject_type       = optional(string)      # Specifies the type of user. singleUser, groupMembers, connectedOrganizationMembers, requestorManager, internalSponsors, or externalSponsors<br>        primary_approver_object_id          = optional(string)      # Object ID of the Primary Approver(s)<br><br>        alternative_approvers = optional(list(object({<br>          object_id    = string # Object ID of the Primary Approver(s)<br>          subject_type = string # Type of approver. "singleUser", "groupMembers", "connectedOrganizationMembers",<br>        })))                    # "requestorManager", "internalSponsors", "externalSponsors"<br><br>        assignment_review_settings = optional(object({<br>          enabled                         = optional(bool, true)             # Whether the assignment should be enabled or not<br>          review_frequency                = optional(string, "annual")       # How ofter reviews should happen. weekly, monthly, quarterly, halfyearly, annual. Defaults to annual<br>          duration_in_days                = optional(number, 14)             # How many days each occurrence of the access review series will run. Defaults to 14<br>          review_type                     = optional(string, "Self")         # Self review or specify reviewers. "Self", "Reviewers". Defaults to "self"<br>          access_review_timeout_behavior  = optional(string, "removeAccess") # What happens if access review times out. "keepAccess", "removeAccess", "acceptAccessRecommendation". Defaults to "removeAccess"<br>          approver_justification_required = optional(bool, false)            # Whether a reviewer needs to provide a justification for their decision<br><br>          reviewers = list(object({              # List of reviewers. One object per reviewer<br>            object_id    = string                # Object ID of the reviewer<br>            subject_type = string                # Type of reviewer. "singleUser", "groupMembers", "connectedOrganizationMembers", "requestorManager", "internalSponsors", "externalSponsors"<br>            backup       = optional(bool, false) # Indicates whether the user is a backup approver or not. "true", "false". Defaults to "false".<br>          }))<br>        }))<br><br>        question = optional(list(object({      # A list of questions. One object per question<br>          required     = optional(bool, false) # Whether this question is requried. true, false. Defaults to false<br>          sequence     = number                # The sequence number of this question<br>          default_text = string                # The default text of this question<br><br>          choice = optional(list(object({ # List of choices for multiple choice. One object per choice<br>            actual_value = string         # The actual value of this choice<br>            default_text = string         # The default text of this question choice<br>          })))<br>        })))<br><br>        resources = list(object({                             # List of resources, one resource per object<br>          display_name           = string                     # Descriptive display name to be used for the Terraform Resource key<br>          resource_origin_id     = string                     # The ID of the Azure resource to be added to the Catalog and Access Package<br>          resource_origin_system = string                     # The type of resource in the origin system. "SharePointOnline", "AadApplication", "AadGroup"<br>          access_type            = optional(string, "Member") # The role of access type to the specified resource. "Member", "Owner". Defaults to "Member"<br>        }))<br>      })<br>    }))<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_entitlement_catalogs"></a> [entitlement\_catalogs](#output\_entitlement\_catalogs) | Outputs all Entitlement Catalogs created through this module |
| <a name="output_access_packages"></a> [access\_packages](#output\_access\_packages) | Outputs all Access Packages created through this module |
| <a name="output_assignment_policies"></a> [assignment\_policies](#output\_assignment\_policies) | Outputs all Access Package Assignment Policies created through this module |
| <a name="output_resource_catalog_associations"></a> [resource\_catalog\_associations](#output\_resource\_catalog\_associations) | Outputs all Resources associated with the Entitlement Catalogs |
| <a name="output_resource_access_package_associations"></a> [resource\_access\_package\_associations](#output\_resource\_access\_package\_associations) | Outputs all Resources associated with the Access Packages |

## Resources

| Name | Type |
|------|------|
| [azuread_access_package.access-packages](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/access_package) | resource |
| [azuread_access_package_assignment_policy.assignment_policies](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/access_package_assignment_policy) | resource |
| [azuread_access_package_catalog.entitlement-catalogs](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/access_package_catalog) | resource |
| [azuread_access_package_resource_catalog_association.resource-catalog-associations](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/access_package_resource_catalog_association) | resource |
| [azuread_access_package_resource_package_association.resource-access-package-associations](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/access_package_resource_package_association) | resource |
<!-- END_TF_DOCS -->