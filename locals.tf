###   Local Variable - Identity Governance Source Variable transformation
############################################################################
locals {
  entitlement-catalogs = flatten([                    # Flattens the nested lists to a list with a depth of 1
    for catalog in var.entitlement_catalogs : catalog # Iterates through all Entitlement Catalogs and creates a list of them
  ])

  access-packages = flatten([                                      # Flattens the nested lists to a list with a depth of 1
    for catalog in var.entitlement_catalogs : [                    # Iterates through all Entitlement Catalogs
      for ap in catalog.access_packages : merge(ap, {              # Iterates through all Access Packages within each Catalog
        catalog_key = catalog.display_name                         # Creates a reference key to the Entitlement Catalog
        key         = "${catalog.display_name}-${ap.display_name}" # Creates a reference key for the Access Package
      })
    ]
  ])

  resources = flatten([                                                                                                                                                                                                                                 # Flattens the nested lists to a list with a depth of 1
    for catalog in var.entitlement_catalogs : [                                                                                                                                                                                                         # Iterates through all Entitlement Catalogs
      for ap in catalog.access_packages : [                                                                                                                                                                                                             # Iterates through all Access Packages within each Catalog
        for resource in ap.resources : merge(resource, {                                                                                                                                                                                                # Iterates through all Resources within each Access Package, within each Catalog
          catalog_key                             = catalog.display_name                                                                                                                                                                                # Creates a reference key to the Entitlement Catalog
          access_package_key                      = "${catalog.display_name}-${ap.display_name}"                                                                                                                                                        # Creates a reference key to the Access Package
          access_package_resource_association_key = "${catalog.display_name}-${ap.display_name}-${resource.display_name != null ? resource.display_name : "${resource.resource_origin_system}-${resource.resource_origin_id}-${resource.access_type}"}" # Creates a reference key for the Access Package Resource Associations
          catalog_resource_association_key        = "${catalog.display_name}-${resource.display_name != null ? resource.display_name : "${resource.resource_origin_system}-${resource.resource_origin_id}-${resource.access_type}"}"                    # Creates a reference key to be used for the Catalog Resource Associations
        })
      ]
    ]
  ])

  resource-catalog-associations-filtered = values(zipmap(local.resources[*].catalog_resource_association_key, local.resources)) # Goes through the list of resource objects and removes duplicates, keeping the last instance in the list
}
