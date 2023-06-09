variable "access-packages" {
  description = "A nested list of objects describing Access Packages, it's parent Catalogs, Assignment Policies and associated resources"
  type = list(object({
    entitlement_catalogs = object({
      display_name       = string                # Name of the Entitlement Catalog
      description        = optional(string)      # Description of the Entitlement Catalog
      externally_visible = optional(bool, false) # If the Entitlement Catalog should be visible outside of the Azure Tenant. true, false. Defaults to "false"
      published          = optional(bool, true)  # If the Access Packages in this catalog are available for management. true, false. Defaults to "true"

      access_packages = object({
        display_name      = string                                              # Name of the Access Package
        description       = optional(string)                                    # Description of the Access Package
        hidden            = optional(bool, false)                               # If the Access Package should be hidden from the requestor
        duration_in_days  = optional(number)                                    # How many days the assignment is valid for. Conflicts with "expiration_date"
        expiration_date   = optional(string)                                    # The date that this assignment expires, in RFC3339 format. Conflicts with "duration_in_days"
        extension_enabled = optional(bool, true)                                # Whether users will be able to request extension before it expires. true, false. Defaults to true
        requests_accepted = optional(bool, true)                                # Whether to accept requests using this policy. When false, no new requests can be made using this policy. true, false. Defaults to true
        scope_type        = optional(string, "AllExistingDirectoryMemberUsers") # Specifies the scopes of the requestors. AllConfiguredConnectedOrganizationSubjects, AllExistingConnectedOrganizationSubjects, AllExistingDirectoryMemberUsers, AllExistingDirectorySubjects, AllExternalSubjects, NoSubjects, SpecificConnectedOrganizationSubjects, or SpecificDirectorySubjects Defaults to "AllExistingDirectoryMemberUsers".

        requestor = optional(object({     # A block specifying the users who are allowed to request on this policy
          object_id    = optional(string) # Object ID of the requestor(s)
          subject_type = optional(string) # Type of requestor. "singleUser", "groupMembers", "connectedOrganizationMembers",
        }))                               # "requestorManager", "internalSponsors", "externalSponsors"

        approval_required                   = optional(bool, true)  # Whether an approval is required. true, false. Defaults to true
        approval_required_for_extension     = optional(bool, false) # Whether approval is required to grant extension. Same approval settings used to approve initial access will apply. true, false. Defaults to false
        requestor_justification_required    = optional(bool, false) # Whether a requestor is required to provide a justification to request an access package. true, false. Defaults to false
        approval_timeout_in_days            = optional(number, 14)  # Maximum number of days within which a request most be approved. Defaults to 14
        approver_justification_required     = optional(bool, false) # Whether an approver must provide a justification for their decision. Defaults to "false"
        alternative_approval_enabled        = optional(bool, false) # Whether alternative approvers are enabled. Defaults to false
        enable_alternative_approval_in_days = optional(number)      # Number of days before the request is forwarded to alternative approvers
        primary_approver_subject_type       = optional(string)      # "requestorManager", "internalSponsors", "externalSponsors"
        primary_approver_object_id          = optional(string)      # Object ID of the Primary Approver(s)

        alternative_approvers = optional(list(object({
          object_id    = string # Object ID of the Primary Approver(s)
          subject_type = string # Type of approver. "singleUser", "groupMembers", "connectedOrganizationMembers",
        })))                    # "requestorManager", "internalSponsors", "externalSponsors"

        assignment_review_settings = optional(object({
          enabled                         = optional(bool, true)             # Whether the assignment should be enabled or not
          review_frequency                = optional(string, "annual")       # How ofter reviews should happen. weekly, monthly, quarterly, halfyearly, annual. Defaults to annual
          duration_in_days                = optional(number, 14)             # How many days each occurrence of the access review series will run. Defaults to 14
          review_type                     = optional(string, "Self")         # Self review or specify reviewers. "Self", "Reviewers". Defaults to "self"
          access_review_timeout_behavior  = optional(string, "removeAccess") # What happens if access review times out. "keepAccess", "removeAccess", "acceptAccessRecommendation". Defaults to "removeAccess"
          approver_justification_required = false                            # Whether a reviewer needs to provide a justification for their decision

          reviewers = list(object({              # List of reviewers. One object per reviewer
            object_id    = string                # Object ID of the reviewer
            subject_type = string                # Type of reviewer. "singleUser", "groupMembers", "connectedOrganizationMembers", "requestorManager", "internalSponsors", "externalSponsors"
            backup       = optional(bool, false) # Indicates whether the user is a backup approver or not. "true", "false". Defaults to "false".
          }))

          question = optional(list(object({      # A list of questions. One object per question
            required     = optional(bool, false) # Whether this question is requried. true, false. Defaults to false
            sequence     = number                # The sequence number of this question
            default_text = string                # The default text of this question

            choice = optional(list(object({ # List of choices for multiple choice. One object per choice
              actual_value = string         # The actual value of this choice
              default_text = string         # The default text of this question choice
            })))
          })))
        }))

        resources = list(object({                             # List of resources, one resource per object
          display_name           = string                     # Descriptive display name to be used for the Terraform Resource key
          resource_origin_id     = string                     # The ID of the Azure resource to be added to the Catalog and Access Package
          resource_origin_system = string                     # The type of resource in the origin system. "SharePointOnline", "AadApplication", "AadGroup"
          access_type            = optional(string, "Member") # The role of access type to the specified resource. "Member", "Owner". Defaults to "Member"
        }))
      })
    })
  }))
}