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

## [3.0.3](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/compare/v3.0.2...v3.0.3) (2025-08-08)


### Bug Fixes

* changed codebuild env var to not error when repo_owner is not defined ([6080b7a](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/commit/6080b7a81c7a7e35d3efac322f020372ef9f0bb3))

## [3.0.2](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/compare/v3.0.1...v3.0.2) (2025-08-08)


### Bug Fixes

* **action:** make action start on lambda code changes ([504c849](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/commit/504c849d9a162687c223120c1004a21abc0d1fe6))
* now codebuild won't get triggered on empty tags closes [#10](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/issues/10) ([f274ae6](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/commit/f274ae678f759ac8760539b7363d8f6e635190d2))
* upgraded CB default image, changed email of default git user to longwave ([e859b38](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/commit/e859b38d6b6a5aac3e8e17fae8310c7a023bfdd1))

## [3.0.1](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/compare/v3.0.0...v3.0.1) (2025-07-16)


### Bug Fixes

* solved issue with multiple istances of this module in the same terraform script closes [#8](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/issues/8) ([319b4fe](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/commit/319b4fee3d613b54d6815ccd745a88bb61203e8d))

