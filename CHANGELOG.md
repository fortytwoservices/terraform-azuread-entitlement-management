# Changelog

## [2.0.1](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/compare/v2.0.0...v2.0.1) (2024-06-13)


### Bug Fixes

* fixed broken for_each reference after restructuring the requestor_settings block ([353ca49](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/353ca49e4e0b688370515b2f6f8715452117e89c))

## [2.0.0](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/compare/v1.0.2...v2.0.0) (2024-06-12)


### ⚠ BREAKING CHANGES

* updated requestor_settings input block to better reflect the actual terraform resource and possible attributes. Also updated the default values for requestor_settings and how they are referenced which cleaned up the code a bit.

### Bug Fixes

* updated requestor_settings input block to better reflect the actual terraform resource and possible attributes. Also updated the default values for requestor_settings and how they are referenced which cleaned up the code a bit. ([d111843](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/d1118439b456253e6dbd12456fe0e3ae73676c9e))

## [1.0.2](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/compare/v1.0.1...v1.0.2) (2024-05-31)


### Bug Fixes

* changed the conditional check of approval_required input parameter to not check for null. The value has a default value defined in the input variable, and will never be null. ([f324b60](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/f324b60d3a9429d2d32b04cb804b5a84ead8d7b7))

## [1.0.1](https://github.com/amestofortytwo/terraform-azuread-entitlement-management/compare/v1.0.0...v1.0.1) (2024-02-22)


### Bug Fixes

* added a local variable that goes through all of the resources and removes duplicates with values() and zipmap() functions, ensuring each resource being associated with the catalog only once. Also removed spaces from the key parameters as they are composed of display names. ([8b0c610](https://github.com/amestofortytwo/terraform-azuread-entitlement-management/commit/8b0c6109c35771295de9789f69f95b541f09f6ff))

## 1.0.0 (2023-06-15)


### Miscellaneous Chores

* release 1.0.0 ([0920b57](https://github.com/amestofortytwo/terraform-azuread-entitlement-management/commit/0920b573619afa553866efbf1864d20e12ba239c))
* release 1.0.0 ([949fdf2](https://github.com/amestofortytwo/terraform-azuread-entitlement-management/commit/949fdf2f85153d2497f5b7f9e6046655a817058f))
