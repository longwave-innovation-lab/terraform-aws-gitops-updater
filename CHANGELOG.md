## [4.2.0](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/compare/v4.1.1...v4.2.0) (2025-10-30)


### Features

* added regex pattern to void triggers on specific tags closes [#19](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/issues/19) ([83ce269](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/commit/83ce26988417f23ad263b0e7b5fc9104dc4c546e))

## [4.1.1](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/compare/v4.1.0...v4.1.1) (2025-10-30)


### Bug Fixes

* fixed condition on check tags which won't trigger update ([951cf48](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/commit/951cf48bafdc27f6e182286fff1c5f972963aec1))

## [4.1.0](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/compare/v4.0.0...v4.1.0) (2025-10-29)


### Features

* lambda doesn't trigger updater when cache tags are pushed ([4174223](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/commit/41742239ec0e933ad7fab39c4dc030178c268cab))

## [4.0.0](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/compare/v3.0.4...v4.0.0) (2025-09-19)


### ⚠ BREAKING CHANGES

* update to terraform AWS provider V6 closes #16

### Features

* update to terraform AWS provider V6 closes [#16](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/issues/16) ([dbdbd49](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/commit/dbdbd492dc8d6fefa259ab3d60479aeaeda26389))


### Bug Fixes

* **gitignore:** deleted terraform.locl.hcl and ingored it ([45f5021](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/commit/45f50218297b913672334c5f1505d53a4da96d04))

## [3.0.4](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/compare/v3.0.3...v3.0.4) (2025-08-08)


### Bug Fixes

* changed codebuild env var to not error when repo_owner is not defined ([02e4564](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/commit/02e4564c68fac91b3348d4e0e2edd32b83a16eb6))

