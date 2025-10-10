# Changelog

## [3.0.0](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/compare/v2.2.0...v3.0.0) (2025-10-10)


### ⚠ BREAKING CHANGES

* add support for connected organizations ([#248](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/issues/248))

### Features

* add msgraph provider and support AadApplication ([41f063e](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/41f063e477049739f832c56fa69724420e425639))
* add support for connected organizations ([#248](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/issues/248)) ([3181647](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/3181647cc7e3b3495b0840393bd2740b7112bf09))


### Bug Fixes

* correct connect organization to use tenant id only ([#250](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/issues/250)) ([4b84f35](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/4b84f350d82699a248cbdb0395d40ca760c1e6df))

## [2.2.0](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/compare/v2.1.0...v2.2.0) (2025-08-05)


### Features

* improve code to avoid unnecessary variables ([79b6d7e](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/79b6d7e7146aab2cfa7d25fc1122ac4cf9dcc8d7))
* improve code to avoid unnecessary variables ([9269bf3](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/9269bf3e28b56581ffb24c0531c1227010fd962a))


### Bug Fixes

* change variable description text ([2690295](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/2690295e2e8772268330bc1b68881e4de62e4558))
* change variable description text ([8efbddb](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/8efbddbe064fe456797e1433ff046c2c4cc290ff))
* grept apply ([c44ad45](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/c44ad45990312ba90f9b1e2d5b07ac6d79fd374a))
* grept apply ([0052f3e](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/0052f3e77e15a37f18cbbe45bc27e0e79f433ffd))
* grept apply ([25b9dfa](https://github.com/fortytwoservices/terraform-azuread-entitlement-management/commit/25b9dfacb32a3664696015a3252757ce65339f08))

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
