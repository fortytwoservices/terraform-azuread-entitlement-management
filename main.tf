###   Identity Governance - Entitlement Catalogs
###################################################
resource "azuread_access_package_catalog" "entitlement-catalogs" {
  for_each = { for catalog in local.entitlement-catalogs : catalog.display_name => catalog }

  display_name       = each.key
  description        = each.value.description
  externally_visible = try(each.value.externally_visible, null)
  published          = try(each.value.published, null)
}


###   Identity Governance - Access Packages
##############################################
resource "azuread_access_package" "access-packages" {
  for_each = { for ap in local.access-packages : ap.key => ap }

  catalog_id   = azuread_access_package_catalog.entitlement-catalogs[each.value.catalog_key].id
  display_name = each.value.display_name
  description  = each.value.description
  hidden       = try(each.value.hidden, null)

  depends_on = [
    azuread_access_package_catalog.entitlement-catalogs,
    azuread_access_package_resource_catalog_association.resource-catalog-associations
  ]
}

###   Identity Governance - Assignment Policies
##################################################
resource "azuread_access_package_assignment_policy" "assignment_policies" {
  for_each = { for ap in local.access-packages : ap.key => ap }

  display_name      = "${each.value.display_name}-policy"
  description       = each.value.description
  access_package_id = azuread_access_package.access-packages[each.key].id
  duration_in_days  = each.value.duration_in_days
  expiration_date   = each.value.expiration_date
  extension_enabled = each.value.extension_enabled

  requestor_settings {
    requests_accepted = each.value.requests_accepted
    scope_type        = each.value.scope_type != null ? each.value.scope_type : each.value.requestor_settings.scope_type

    dynamic "requestor" {
      for_each = toset(try(each.value.requestor_settings.requestor, null) != null ? [1] : [])

      content {
        object_id    = each.value.requestor_settings.requestor.object_id
        subject_type = each.value.requestor_settings.requestor.subject_type
      }
    }
  }

  approval_settings {
    approval_required                = each.value.approval_required
    approval_required_for_extension  = each.value.approval_required_for_extension
    requestor_justification_required = each.value.requestor_justification_required

    dynamic "approval_stage" {
      for_each = toset(each.value.approval_required ? [1] : [])

      content {
        approval_timeout_in_days            = each.value.approval_timeout_in_days
        approver_justification_required     = each.value.approver_justification_required
        alternative_approval_enabled        = each.value.alternative_approval_enabled
        enable_alternative_approval_in_days = each.value.alternative_approval_enabled ? each.value.enable_alternative_approval_in_days : null


        dynamic "primary_approver" {
          for_each = each.value.approval_required ? (each.value.primary_approvers != null ? toset(each.value.primary_approvers) : []) : []

          content {
            subject_type = primary_approver.value.subject_type
            object_id    = primary_approver.value.object_id
            backup       = primary_approver.value.backup
          }
        }

        dynamic "alternative_approver" {
          for_each = each.value.alternative_approval_enabled != null ? (each.value.alternative_approvers != null ? toset(each.value.alternative_approvers) : []) : []

          content {
            subject_type = alternative_approver.value.subject_type
            object_id    = alternative_approver.value.object_id
            backup       = primary_approver.value.backup
          }
        }
      }
    }
  }

  dynamic "assignment_review_settings" {
    for_each = toset(try(each.value.assignment_review_settings, null) != null ? [1] : [])

    content {
      enabled                         = each.value.assignment_review_settings.enabled
      review_frequency                = each.value.assignment_review_settings.review_frequency
      duration_in_days                = each.value.assignment_review_settings.duration_in_days
      review_type                     = each.value.assignment_review_settings.review_type
      access_recommendation_enabled   = true
      access_review_timeout_behavior  = each.value.assignment_review_settings.access_review_timeout_behavior
      approver_justification_required = each.value.assignment_review_settings.approver_justification_required

      dynamic "reviewer" {
        for_each = each.value.assignment_review_settings.review_type == "Reviewers" ? { for reviewer in each.value.assignment_review_settings.reviewers : reviewer.object_id => reviewer } : {}

        content {
          object_id    = reviewer.value.object_id
          subject_type = reviewer.value.subject_type
          backup       = reviewer.value.backup
        }
      }
    }
  }

  dynamic "question" {
    for_each = toset(each.value.question != null ? each.value.question : [])

    content {
      required = question.value.required
      sequence = question.value.sequence

      text {
        default_text = question.value.default_text
      }

      dynamic "choice" {
        for_each = question.value.choice != null ? question.value.choice : []

        content {
          actual_value = choice.value.actual_value != null ? choice.value.actual_value : choice.value.default_text

          display_value {
            default_text = choice.value.default_text
          }
        }
      }
    }
  }

  depends_on = [
    azuread_access_package_catalog.entitlement-catalogs,
    azuread_access_package.access-packages,
    azuread_access_package_resource_catalog_association.resource-catalog-associations,
    azuread_access_package_resource_package_association.resource-access-package-associations
  ]
}

###   Identity Governance - Resource Catalog Associations
############################################################
resource "azuread_access_package_resource_catalog_association" "resource-catalog-associations" {
  for_each = { for resource in local.resource-catalog-associations-filtered : resource.catalog_resource_association_key => resource }

  catalog_id             = azuread_access_package_catalog.entitlement-catalogs[each.value.catalog_key].id
  resource_origin_id     = each.value.resource_origin_id
  resource_origin_system = each.value.resource_origin_system

  depends_on = [
    azuread_access_package_catalog.entitlement-catalogs
  ]
}

###   Identity Governance - Resource Access Package Associations
###################################################################
resource "azuread_access_package_resource_package_association" "resource-access-package-associations" {
  for_each = { for resource in local.resources : resource.access_package_resource_association_key => resource if resource.resource_origin_system != "AadApplication" }

  catalog_resource_association_id = azuread_access_package_resource_catalog_association.resource-catalog-associations[each.value.catalog_resource_association_key].id
  access_package_id               = azuread_access_package.access-packages[each.value.access_package_key].id
  access_type                     = each.value.access_type

  depends_on = [
    azuread_access_package_catalog.entitlement-catalogs,
    azuread_access_package.access-packages,
    azuread_access_package_resource_catalog_association.resource-catalog-associations
  ]
}

data "msgraph_resource" "resource_access_package_catalog_resources" {
  for_each         = { for resource in local.resources : resource.access_package_resource_association_key => resource if resource.resource_origin_system == "AadApplication" }
  url              = "/identityGovernance/entitlementManagement/catalogs/${azuread_access_package_catalog.entitlement-catalogs[each.value.catalog_key].id}/resources"
  query_parameters = {
    "$filter" = ["(originId eq '${each.value.resource_origin_id}')"]
    "$expand" = ["scopes"]
  }
  response_export_values = {
    all = "@"
  }

  depends_on = [
    azuread_access_package_catalog.entitlement-catalogs,
    azuread_access_package.access-packages,
    azuread_access_package_resource_catalog_association.resource-catalog-associations
  ]
}

output "resource_access_package_catalog_resources_all" {
  // it will output the whole response
  value = data.msgraph_resource.resource_access_package_catalog_resources[*].output.all
}

data "msgraph_resource" "resource_access_package_catalog_resource_roles" {
  for_each = { for resource in local.resources : resource.access_package_resource_association_key => resource if resource.resource_origin_system == "AadApplication" }
  url      = "/identityGovernance/entitlementManagement/catalogs/${azuread_access_package_catalog.entitlement-catalogs[each.value.catalog_key].id}/resourceRoles"
  query_parameters = {
    "$filter" = ["(originSystem eq 'AadApplication' and resource/id eq '${msgraph_resource.resource_access_package_catalog_resources[each.key].output.all.value[0].id}')"]
    "$expand" = ["resource"]
  }
  response_export_values = {
    all = "@"
  }

  depends_on = [
    azuread_access_package_catalog.entitlement-catalogs,
    azuread_access_package.access-packages,
    azuread_access_package_resource_catalog_association.resource-catalog-associations
  ]
}

output "resource_access_package_catalog_resource_roles_all" {
  // it will output the whole response
  value = data.msgraph_resource.resource_access_package_catalog_resource_roles[*].output.all
}

###   Identity Governance - Resource Access Package Associations for AadApplication due to https://github.com/hashicorp/terraform-provider-azuread/issues/1066
###################################################################
resource "msgraph_resource" "resource-access-package-associations" {
  for_each = { for resource in local.resources : resource.access_package_resource_association_key => resource if resource.resource_origin_system == "AadApplication" }
  url      = "/identityGovernance/entitlementManagement/accessPackages/${azuread_access_package.access-packages[each.value.access_package_key].id}/resourceRoleScopes"

  body = {
    role = {
      displayName  = "Standard User"
      description  = "Standard User"
      originSystem = each.value.resource_origin_system
      originId     = each.value.access_type
      Resource = {
        originId     = each.value.resource_origin_id
        originSystem = each.value.resource_origin_system
      }
    }
    scope = {
      originId     = each.value.resource_origin_id
      originSystem = each.value.resource_origin_system
      isRootScope  = true
    }
  }

  # catalog_resource_association_id = azuread_access_package_resource_catalog_association.resource-catalog-associations[each.value.catalog_resource_association_key].id
  # access_package_id               = azuread_access_package.access-packages[each.value.access_package_key].id
  # access_type                     = each.value.access_type

  depends_on = [
    azuread_access_package_catalog.entitlement-catalogs,
    azuread_access_package.access-packages,
    azuread_access_package_resource_catalog_association.resource-catalog-associations
  ]
}
