## [2.0.2](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/compare/v2.0.1...v2.0.2) (2025-01-31)


### Bug Fixes

* **lambda:** fixed an error when used with another LW module lambda.zip payload will be used cross modules and cause conflics closes [#3](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/issues/3) ([1d8c4ae](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/commit/1d8c4aeaa6675cd29265faa03643975db0f80e94))

## [2.0.1](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/compare/v2.0.0...v2.0.1) (2025-01-30)


### Bug Fixes

* added default tags with Service Project GitopsUpdater ([e02366e](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/commit/e02366e768343a9dca1c4f99fc84d24d158ec078))

## [2.0.0](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/compare/60a96a8bba0f96a6ec64868cc2025891178798bc...v2.0.0) (2025-01-30)


### ⚠ BREAKING CHANGES

* changed the way to reference the ecr regisries to make it possible to isolate the event rule

### Features

* first version with all triggers working, todo fix buildspec of codebuild ([60a96a8](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/commit/60a96a8bba0f96a6ec64868cc2025891178798bc))


### Bug Fixes

* **actions:** porting to github ([daa16e0](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/commit/daa16e0b91c0ec025bc9458c761e1d7d98de4a13))
* added ignore to zip files ([1a0a723](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/commit/1a0a72351f10a740f20ee8545b978750c28ccaec))
* changed the way to reference the ecr regisries to make it possible to isolate the event rule ([7b7f93e](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/commit/7b7f93e3622029611f27cb85cffdc60aaac6e6a4))
* **issue template:** moved issue template to Github format ([50796fe](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/commit/50796fe6e17e4d2f10a10e3a9d5c9d024eb5ea4e))
* **issue template:** moved temporarily issue template files to solve github port ([4a97fce](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/commit/4a97fce138b3f3e29620bcc2b032969e4616f294))
* solved some tweaking problems to amke the pipeline working ([b4338b2](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/commit/b4338b25f6d0b10dbda33091912624e7c20c165b))

