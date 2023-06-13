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

## Destroy resources
At the time of writing, there is a hard dependency from the Microsoft Azure API that requires all Assignments of the Access Package to be removed before you are allowed to destroy it. This is because there is no dedicated API call for force removing Assignments or the Access Package itself. After all Assignments have been deleted, you should be able to destroy all resources created by this module.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.4.6 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >=2.39.0 |

## Example
### Basic Example
```hcl
# This example contains a typical, basic deployment of an Entitlement Catalog, with an Access Package, an Assignment Policy, and AzureAD Groups used as resources.
# Most of the parameters and inputs are left to their default values, as they are typically the correct values in a common deployment.
# Refer to the [documentation](https://github.com/amestofortytwo/terraform-azuread-entitlement-management) for all available input parameters.

###   Azure AD Groups
########################
locals {
  ad_groups = [
    "elm_approvers", # Azure AD Group whose members are allowed to approve Access Package requests
    "elm_approved"   # Azure AD Group that users will become member of when access request is approved
  ]
}

resource "azuread_group" "elm_groups" {
  for_each         = toset(local.ad_groups)
  display_name     = "${local.prefix}-${each.key}"
  security_enabled = true
}


###   Azure AD Entitlement Management
########################################
module "elm" {
  source = "git@github.com:amestofortytwo/terraform-azuread-entitlement-management"

  entitlement_catalogs = [                      # A list of Entitlement Catalogs, one object per Catalog
    {                                           #
      display_name = "${local.prefix}-catalog1" # Pretty Display Name for the Catalog
      description  = "ELM test catalog1"        # Description of the Catalog

      access_packages = [                                                                     # List of Access Packages, one object for each Access Package
        {                                                                                     #
          display_name                  = "${local.prefix}-access_package1"                   # Pretty Display Name for the Access Package
          description                   = "ELM test access package1"                          # Description of the Access Package
          duration_in_days              = 30                                                  # How many days the assignment is valid for. Conflicts with "expiration_date"
          primary_approver_subject_type = "groupMembers"                                      # Specifies the type of user. singleUser, groupMembers, connectedOrganizationMembers, requestorManager, internalSponsors, or externalSponsors
          primary_approver_object_id    = azuread_group.elm_groups["elm_approvers"].object_id # Object ID of the Primary Approver(s)

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


<details><summary>### Advanced Example</summary>

```hcl
# This example contains a more advanced deployment of an Entitlement Catalog, with an Access Package, an Assignment Policy, and AzureAD Groups used as resources, specific requestors, additional justification etc.
# Most of the parameters and inputs are left to their default values, as they are typically the correct values in a common deployment.
# Refer to the [documentation](https://github.com/amestofortytwo/terraform-azuread-entitlement-management) for all available input parameters.

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
  display_name     = "${local.prefix}-${each.key}"
  security_enabled = true
}


###   Azure AD Entitlement Management
########################################
module "elm" {
  source = "git@github.com:amestofortytwo/terraform-azuread-entitlement-management"

  entitlement_catalogs = [                      # A list of Entitlement Catalogs, one object per Catalog
    {                                           #
      display_name = "${local.prefix}-catalog1" # Pretty Display Name for the Catalog
      description  = "ELM test catalog1"        # Description of the Catalog

      access_packages = [                                                                           # List of Access Packages, one object for each Access Package
        {                                                                                           #
          display_name                        = "${local.prefix}-access_package1"                   # Pretty Display Name for the Access Package
          description                         = "ELM test access package1"                          # Description of the Access Package
          duration_in_days                    = 30                                                  # How many days the assignment is valid for. Conflicts with "expiration_date"
          requestor_justification_required    = true                                                # Whether a requestor is required to provide a justification to request an access package. true, false. Defaults to false
          primary_approver_subject_type       = "groupMembers"                                      # Specifies the type of user. singleUser, groupMembers, connectedOrganizationMembers, requestorManager, internalSponsors, or externalSponsors
          primary_approver_object_id          = azuread_group.elm_groups["elm_approvers"].object_id # Object ID of the Primary Approver(s)
          alternative_approval_enabled        = true                                                # If approval review should time out and be forwarded to alternative approvers
          enable_alternative_approval_in_days = 7                                                   # How many days until approvel review should be forwarded to alternative approvers

          alternative_approvers = [                                                          # List of Alternative Approvers, one object per approver
            {                                                                                #
              subject_type = "groupMembers"                                                  # # Type of approver. "singleUser", "groupMembers", "connectedOrganizationMembers", "requestorManager", "internalSponsors", "externalSponsors"
              object_id    = azuread_group.elm_groups["elm_alternative_approvers"].object_id # Object ID of the Primary Approver(s)
            }
          ]

          requestor = {                                                         # A block specifying the users who are allowed to request on this policy
            subject_type = "groupMembers"                                       # Type of requestor. "singleUser", "groupMembers", "connectedOrganizationMembers",
            object_id    = azuread_group.elm_groups["elm_requestors"].object_id # Object ID of the requestor(s)
          }                                                                     # "requestorManager", "internalSponsors", "externalSponsors"

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
</blockquote></details>

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | >=2.39.0 |

## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_entitlement_catalogs"></a> [entitlement\_catalogs](#input\_entitlement\_catalogs) | A nested list of objects describing Access Packages, it's parent Catalogs, Assignment Policies and associated resources | <pre>list(object({<br>    #entitlement_catalogs = list(object({         # A list of Entitlement Catalogs, one object for each catalog<br>    display_name       = string                # Name of the Entitlement Catalog<br>    description        = optional(string)      # Description of the Entitlement Catalog<br>    externally_visible = optional(bool, false) # If the Entitlement Catalog should be visible outside of the Azure Tenant. true, false. Defaults to "false"<br>    published          = optional(bool, true)  # If the Access Packages in this catalog are available for management. true, false. Defaults to "true"<br><br>    access_packages = list(object({<br>      display_name      = string                                              # Name of the Access Package<br>      description       = optional(string)                                    # Description of the Access Package<br>      hidden            = optional(bool, false)                               # If the Access Package should be hidden from the requestor<br>      duration_in_days  = optional(number)                                    # How many days the assignment is valid for. Conflicts with "expiration_date"<br>      expiration_date   = optional(string)                                    # The date that this assignment expires, in RFC3339 format. Conflicts with "duration_in_days"<br>      extension_enabled = optional(bool, true)                                # Whether users will be able to request extension before it expires. true, false. Defaults to true<br>      requests_accepted = optional(bool, true)                                # Whether to accept requests using this policy. When false, no new requests can be made using this policy. true, false. Defaults to true<br>      scope_type        = optional(string, "AllExistingDirectoryMemberUsers") # Specifies the scopes of the requestors. AllConfiguredConnectedOrganizationSubjects, AllExistingConnectedOrganizationSubjects, AllExistingDirectoryMemberUsers, AllExistingDirectorySubjects, AllExternalSubjects, NoSubjects, SpecificConnectedOrganizationSubjects, or SpecificDirectorySubjects Defaults to "AllExistingDirectoryMemberUsers".<br><br>      # Specified requestor requires scope_type SpecificDirectorySubjects or SpecificConnectedOrganizationSubjects. Defaults to SpecificDirectorySubjects.<br>      requestor = optional(object({     # A block specifying the users who are allowed to request on this policy<br>        subject_type = optional(string) # Type of requestor. "singleUser", "groupMembers", "connectedOrganizationMembers", "requestorManager", "internalSponsors", "externalSponsors"<br>        object_id    = optional(string) # Object ID of the requestor(s)<br>      }))<br><br>      approval_required                   = optional(bool, true)  # Whether an approval is required. true, false. Defaults to true<br>      approval_required_for_extension     = optional(bool, false) # Whether approval is required to grant extension. Same approval settings used to approve initial access will apply. true, false. Defaults to false<br>      requestor_justification_required    = optional(bool, false) # Whether a requestor is required to provide a justification to request an access package. true, false. Defaults to false<br>      approval_timeout_in_days            = optional(number, 14)  # Maximum number of days within which a request most be approved. Defaults to 14<br>      approver_justification_required     = optional(bool, false) # Whether an approver must provide a justification for their decision. Defaults to "false"<br>      alternative_approval_enabled        = optional(bool, false) # Whether alternative approvers are enabled. Defaults to false<br>      enable_alternative_approval_in_days = optional(number)      # Number of days before the request is forwarded to alternative approvers<br>      primary_approver_subject_type       = optional(string)      # Specifies the type of user. singleUser, groupMembers, connectedOrganizationMembers, requestorManager, internalSponsors, or externalSponsors<br>      primary_approver_object_id          = optional(string)      # Object ID of the Primary Approver(s)<br><br>      alternative_approvers = optional(list(object({<br>        subject_type = string # Type of approver. "singleUser", "groupMembers", "connectedOrganizationMembers", "requestorManager", "internalSponsors", "externalSponsors"<br>        object_id    = string # Object ID of the Primary Approver(s)<br>      })))<br><br>      assignment_review_settings = optional(object({<br>        enabled                         = optional(bool, true)             # Whether the assignment should be enabled or not. Defaults to true<br>        review_frequency                = optional(string, "annual")       # How ofter reviews should happen. weekly, monthly, quarterly, halfyearly, annual. Defaults to annual<br>        duration_in_days                = optional(number, 14)             # How many days each occurrence of the access review series will run. Defaults to 14<br>        review_type                     = optional(string, "Self")         # Self review or specify reviewers. "Self", "Reviewers". Defaults to "self"<br>        access_review_timeout_behavior  = optional(string, "removeAccess") # What happens if access review times out. "keepAccess", "removeAccess", "acceptAccessRecommendation". Defaults to "removeAccess"<br>        approver_justification_required = optional(bool, false)            # Whether a reviewer needs to provide a justification for their decision<br><br>        reviewers = list(object({              # List of reviewers. One object per reviewer<br>          subject_type = string                # Type of reviewer. "singleUser", "groupMembers", "connectedOrganizationMembers", "requestorManager", "internalSponsors", "externalSponsors"<br>          object_id    = string                # Object ID of the reviewer<br>          backup       = optional(bool, false) # Indicates whether the user is a backup approver or not. "true", "false". Defaults to "false".<br>        }))<br>      }))<br><br>      question = optional(list(object({      # A list of questions. One object per question<br>        required     = optional(bool, false) # Whether this question is requried. true, false. Defaults to false<br>        sequence     = number                # The sequence number of this question<br>        default_text = string                # The default text of this question<br><br>        choice = optional(list(object({   # List of choices for multiple choice. One object per choice<br>          default_text = string           # The default text of this question choice<br>          actual_value = optional(string) # The actual value of this choice. Defaults to default_text value<br>        })))<br>      })))<br><br>      resources = list(object({                             # List of resources, one resource per object<br>        display_name           = string                     # Descriptive display name to be used for the Terraform Resource key<br>        resource_origin_system = string                     # The type of resource in the origin system. "SharePointOnline", "AadApplication", "AadGroup"<br>        resource_origin_id     = string                     # The ID of the Azure resource to be added to the Catalog and Access Package<br>        access_type            = optional(string, "Member") # The role of access type to the specified resource. "Member", "Owner". Defaults to "Member"<br>      }))<br>    }))<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_main-input-output"></a> [main-input-output](#output\_main-input-output) | n/a |
| <a name="output_entitlement-catalogs"></a> [entitlement-catalogs](#output\_entitlement-catalogs) | n/a |
| <a name="output_access-packages"></a> [access-packages](#output\_access-packages) | n/a |
| <a name="output_resources"></a> [resources](#output\_resources) | n/a |

## Resources

| Name | Type |
|------|------|
| [azuread_access_package.access-packages](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/access_package) | resource |
| [azuread_access_package_assignment_policy.assignment_policies](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/access_package_assignment_policy) | resource |
| [azuread_access_package_catalog.entitlement-catalogs](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/access_package_catalog) | resource |
| [azuread_access_package_resource_catalog_association.resource-catalog-associations](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/access_package_resource_catalog_association) | resource |
| [azuread_access_package_resource_package_association.resource-access-package-associations](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/access_package_resource_package_association) | resource |
<!-- END_TF_DOCS -->