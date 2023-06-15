###   Full resource outputs
##############################
output "entitlement_catalogs" {
  description = "Outputs all Entitlement Catalogs created through this module"
  value       = azuread_access_package_catalog.entitlement-catalogs[*]
}

output "access_packages" {
  description = "Outputs all Access Packages created through this module"
  value       = azuread_access_package.access-packages[*]
}

output "assignment_policies" {
  description = "Outputs all Access Package Assignment Policies created through this module"
  value       = azuread_access_package_assignment_policy.assignment_policies[*]
}

output "resource_catalog_associations" {
  description = "Outputs all Resources associated with the Entitlement Catalogs"
  value       = azuread_access_package_resource_catalog_association.resource-catalog-associations[*]
}

output "resource_access_package_associations" {
  description = "Outputs all Resources associated with the Access Packages"
  value       = azuread_access_package_resource_package_association.resource-access-package-associations[*]
}