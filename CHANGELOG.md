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

## [3.0.0](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/compare/v2.0.2...v3.0.0) (2025-06-27)


### ⚠ BREAKING CHANGES

* renamed codecommit_repo_name in repo_name since codecommit will be deprecated

### Bug Fixes

* renamed codecommit_repo_name in repo_name since codecommit will be deprecated ([4935cf8](https://git.lantechlongwave.it/RnD/terraform-aws-gitops-updater/commit/4935cf832e7e820694f9c5e71b66294975c8c6f1))

