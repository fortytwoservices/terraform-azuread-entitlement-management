###   Input variables
########################
variable "connected_organizations" {
  description = "A list of connected organizations to be used in Access Package policies"
  type = list(object({
    display_name = string                         # Name of the Connected Organization.
    description  = optional(string)               # Description of the Connected Organization.
    identity_sources = list(object({              # A list of identity sources for the connected organization.
      type         = optional(string, "tenantid") # Type of identity source. Either "tenantid" or "domainname". Defaults to "tenantid".
      lookup_value = string                       # If `type` is "tenantid", this is the ID of the external Azure AD tenant. If `type` is "domainname", this is the verified domain name of the external Azure AD tenant.
      display_name = optional(string, "")         # (Optional) Display name for the identity source.
    }))
    state = optional(string, "configured") # State of the connected organization. Either "configured" or "proposed". Defaults to "configured".
  }))
  default = []
}

variable "entitlement_catalogs" {
  description = "A nested list of objects describing Access Packages, it's parent Catalogs, Assignment Policies and associated resources"
  type = list(object({                         # List of Entitlement Catalogs, one object for each catalog
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
        access_type            = optional(string, "Member") # The role of access type to the specified resource. "Member" or "Owner" can be used if resource_origin_system is "AadGroup", uuid of role needs to be used if resource_origin_system is "AadApplication". Defaults to "Member"
      }))
    }))
  }))
}
