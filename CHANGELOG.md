# Changelog

## 1.0.0 (2025-08-05)


### ⚠ BREAKING CHANGES

* updated requestor_settings input block to better reflect the actual terraform resource and possible attributes. Also updated the default values for requestor_settings and how they are referenced which cleaned up the code a bit.
* removed commented lines from old primary approvers logic. The new input method and logic for primary approvers is a breaking change as it requires changes to the module input. These are reflected in the basic and advanced examples.

### Features

* added backup parameter to the primary and alternative approver blocks, and description to the input variable definition ([3d31f70](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/3d31f7017b391528ecdd722ce145469d51c2028b))
* added input values and dynamic block allowing for multiple primary approvers ([2a09de3](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/2a09de3c395d030402a3d5a62c0717feb6598499))
* added markdown lint configuration file, with md012 - multiple c… ([05d143b](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/05d143b4be727fe0d118c0fafd49e9fb9cf8186a))
* added markdown lint configuration file, with md012 - multiple consecutive lines, md013 - line length, md024 - multiple headers with the same content ([2c91ecc](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/2c91ecc02f75594ec2ee1cf31b4569bc9f54983b))
* added reference to newly added lint configuration file ([4330184](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/43301840c49ac0310619a8a7574f1b4c3c59e0ad))
* added reference to newly added lint configuration file ([a745a54](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/a745a5422afe62c679a4d175a028a24478e9a196))
* improve code to avoid unnecessary variables ([79b6d7e](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/79b6d7e7146aab2cfa7d25fc1122ac4cf9dcc8d7))
* improve code to avoid unnecessary variables ([9269bf3](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/9269bf3e28b56581ffb24c0531c1227010fd962a))
* removed commented lines from old primary approvers logic. The new input method and logic for primary approvers is a breaking change as it requires changes to the module input. These are reflected in the basic and advanced examples. ([60f14f2](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/60f14f2760305866fa35c237a959861a8f6af6ce))
* updated basic and advanced example to reflect changes to primary_approver ([756d595](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/756d595bf633a9baef7e4dda1afcebbf4f072361))
* updated configuration for tfdocs and updated readme ([55684f6](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/55684f63cc38e757b9b65c23409a0e54de94a227))


### Bug Fixes

* added a local variable that goes through all of the resources and removes duplicates with values() and zipmap() functions, ensuring each resource being associated with the catalog only once. Also removed spaces from the key parameters as they are composed of display names. ([8b0c610](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/8b0c6109c35771295de9789f69f95b541f09f6ff))
* added ellipsis to the merge() for loop for catalog_resource_associations ([4e0063f](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/4e0063fb82582403516c6bf67a0dd47c1456f398))
* added ellipsis to the merge() for loop for catalog_resource_associations ([6835a40](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/6835a40df71a0ee97cba10b2f8d7902f2c1d56c5))
* changed the conditional check of approval_required input paramet… ([be44511](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/be44511b03391d4f8239c9c086ad3654a10369a0))
* changed the conditional check of approval_required input parameter to not check for null. The value has a default value defined in the input variable, and will never be null. ([f324b60](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/f324b60d3a9429d2d32b04cb804b5a84ead8d7b7))
* created local that transformes local.resources to a map that distinct() should function properly on ([cc065a0](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/cc065a00bfec292faa1a454f4427106ba670bfbf))
* created the specific catalog and access package resource association keys in the source local to ensure unique keys, no duplicates and more readability ([9569e9d](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/9569e9d87465d616fa5101ef0f62d0fb32ce4060))
* fixed broken for_each reference after restructuring the requesto… ([da7e4f6](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/da7e4f678999e0c10a51b7c51cf84cf2314e2afc))
* fixed broken for_each reference after restructuring the requestor_settings block ([353ca49](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/353ca49e4e0b688370515b2f6f8715452117e89c))
* fixed local variable reference typo ([542af07](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/542af070778dbc84b009a61db381ffd53c47fd94))
* fixed readme file names ([b66089d](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/b66089da7f09e8180f3a8768f66567cb24a4a47b))
* grept apply ([c44ad45](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/c44ad45990312ba90f9b1e2d5b07ac6d79fd374a))
* grept apply ([0052f3e](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/0052f3e77e15a37f18cbbe45bc27e0e79f433ffd))
* grept apply ([25b9dfa](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/25b9dfacb32a3664696015a3252757ce65339f08))
* grept apply ([8b12a98](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/8b12a9801bd0ac8849626c7c3491ce6d0a4f630c))
* grept apply ([dddace1](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/dddace190fd7d77b435a1ccaeb0a7fbfedcf33d4))
* Merge pull request [#71](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/issues/71) from amestofortytwo/fix/remove-duplicate-catalog-associations ([9a9155a](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/9a9155a5bac7f0bc91b1ff379a24648671836bb5)), closes [#36](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/issues/36)
* removed replacement of spaces in keys as it would introduce too much of a breaking change for all resources ([3bce94b](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/3bce94bdbc9d83acdedc32e77d4c4fcec066ef04))
* replaced distinct with merge ([276c4a6](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/276c4a635588e76d0910e374e3b165f5654c43ff))
* testing out the combination of value and zipmap functions to remove duplicates ([5ef460c](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/5ef460c66e44a643b47030765f86c1ccbf00a367))
* updated default behaviour of requsetor_settings to specify the correct parameter. ([558c0c3](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/558c0c3330defd3119035decd1562bf987f0b7fc))
* updated default behaviour of requsetor_settings to specify the correct parameter. Also updated the configuration of tf-docs fixing the readme generation and markdown linting. ([c6a1d7b](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/c6a1d7b5504cb4633025896d44389339560beffe))
* updated input parameter reference ([94cc3ab](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/94cc3aba7dabf21e5a8a462aa0a78c25671eea3a))
* updated requestor_settings input block to better reflect the actual terraform resource and possible attributes. Also updated the default values for requestor_settings and how they are referenced which cleaned up the code a bit. ([d111843](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/d1118439b456253e6dbd12456fe0e3ae73676c9e))
* updated resource catalog association to include origin system in the source map key, and ensure distinct objects to prevent duplicates. ([456b4ee](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/456b4ee6c20503ae60fbc23109d32a77f8ffa061))


### Miscellaneous Chores

* release 1.0.0 ([0920b57](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/0920b573619afa553866efbf1864d20e12ba239c))
* release 1.0.0 ([949fdf2](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/949fdf2f85153d2497f5b7f9e6046655a817058f))

## [2.1.0](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/compare/v2.0.1...v2.1.0) (2024-06-18)


### Features

* updated configuration for tfdocs and updated readme ([55684f6](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/55684f63cc38e757b9b65c23409a0e54de94a227))


### Bug Fixes

* fixed readme file names ([b66089d](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/b66089da7f09e8180f3a8768f66567cb24a4a47b))
* grept apply ([dddace1](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/dddace190fd7d77b435a1ccaeb0a7fbfedcf33d4))
* updated default behaviour of requsetor_settings to specify the correct parameter. ([558c0c3](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/558c0c3330defd3119035decd1562bf987f0b7fc))

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
