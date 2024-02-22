# Changelog

## [1.0.1](https://github.com/amestofortytwo/terraform-azuread-entitlement-management/compare/v1.0.0...v1.0.1) (2024-02-22)


### Bug Fixes

* added a local variable that goes through all of the resources and removes duplicates with values() and zipmap() functions, ensuring each resource being associated with the catalog only once. Also removed spaces from the key parameters as they are composed of display names. ([8b0c610](https://github.com/amestofortytwo/terraform-azuread-entitlement-management/commit/8b0c6109c35771295de9789f69f95b541f09f6ff))
* added ellipsis to the merge() for loop for catalog_resource_associations ([4e0063f](https://github.com/amestofortytwo/terraform-azuread-entitlement-management/commit/4e0063fb82582403516c6bf67a0dd47c1456f398))
* added ellipsis to the merge() for loop for catalog_resource_associations ([6835a40](https://github.com/amestofortytwo/terraform-azuread-entitlement-management/commit/6835a40df71a0ee97cba10b2f8d7902f2c1d56c5))
* created local that transformes local.resources to a map that distinct() should function properly on ([cc065a0](https://github.com/amestofortytwo/terraform-azuread-entitlement-management/commit/cc065a00bfec292faa1a454f4427106ba670bfbf))
* created the specific catalog and access package resource association keys in the source local to ensure unique keys, no duplicates and more readability ([9569e9d](https://github.com/amestofortytwo/terraform-azuread-entitlement-management/commit/9569e9d87465d616fa5101ef0f62d0fb32ce4060))
* fixed local variable reference typo ([542af07](https://github.com/amestofortytwo/terraform-azuread-entitlement-management/commit/542af070778dbc84b009a61db381ffd53c47fd94))
* Merge pull request [#71](https://github.com/amestofortytwo/terraform-azuread-entitlement-management/issues/71) from amestofortytwo/fix/remove-duplicate-catalog-associations ([9a9155a](https://github.com/amestofortytwo/terraform-azuread-entitlement-management/commit/9a9155a5bac7f0bc91b1ff379a24648671836bb5)), closes [#36](https://github.com/amestofortytwo/terraform-azuread-entitlement-management/issues/36)
* removed replacement of spaces in keys as it would introduce too much of a breaking change for all resources ([3bce94b](https://github.com/amestofortytwo/terraform-azuread-entitlement-management/commit/3bce94bdbc9d83acdedc32e77d4c4fcec066ef04))
* replaced distinct with merge ([276c4a6](https://github.com/amestofortytwo/terraform-azuread-entitlement-management/commit/276c4a635588e76d0910e374e3b165f5654c43ff))
* testing out the combination of value and zipmap functions to remove duplicates ([5ef460c](https://github.com/amestofortytwo/terraform-azuread-entitlement-management/commit/5ef460c66e44a643b47030765f86c1ccbf00a367))
* updated resource catalog association to include origin system in the source map key, and ensure distinct objects to prevent duplicates. ([456b4ee](https://github.com/amestofortytwo/terraform-azuread-entitlement-management/commit/456b4ee6c20503ae60fbc23109d32a77f8ffa061))

## 1.0.0 (2023-06-15)


### Miscellaneous Chores

* release 1.0.0 ([0920b57](https://github.com/amestofortytwo/terraform-azuread-entitlement-management/commit/0920b573619afa553866efbf1864d20e12ba239c))
* release 1.0.0 ([949fdf2](https://github.com/amestofortytwo/terraform-azuread-entitlement-management/commit/949fdf2f85153d2497f5b7f9e6046655a817058f))
