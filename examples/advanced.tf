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


###   Azure AD Entitlement Management
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