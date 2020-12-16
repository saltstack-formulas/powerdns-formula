# Changelog

## [0.3.2](https://github.com/saltstack-formulas/powerdns-formula/compare/v0.3.1...v0.3.2) (2020-12-16)


### Continuous Integration

* **gemfile.lock:** add to repo with updated `Gemfile` [skip ci] ([7a19c67](https://github.com/saltstack-formulas/powerdns-formula/commit/7a19c6771b7fa445a4fae663bb31e6476d00684e))
* **gitlab-ci:** use GitLab CI as Travis CI replacement ([39907b6](https://github.com/saltstack-formulas/powerdns-formula/commit/39907b66634e0a6ca8d08b8660086df3e74b9c9b))
* **kitchen:** use `saltimages` Docker Hub where available [skip ci] ([0bb19ea](https://github.com/saltstack-formulas/powerdns-formula/commit/0bb19ea640db71afc96eed7afdd5899192303faf))
* **kitchen+travis:** add new platforms [skip ci] ([2071a52](https://github.com/saltstack-formulas/powerdns-formula/commit/2071a523aef48437b4bb2defea96264f439d70b5))
* **kitchen+travis:** adjust matrix to add `3000.2` & remove `2018.3` [skip ci] ([61f4f47](https://github.com/saltstack-formulas/powerdns-formula/commit/61f4f47e9d548bfba5d3a584bb499d04f5008214))
* **kitchen+travis:** adjust matrix to add `3000.3` [skip ci] ([ab1b2c7](https://github.com/saltstack-formulas/powerdns-formula/commit/ab1b2c78ed320922460b6a153bd8ac353f2f1f1d))
* **kitchen+travis:** remove `master-py2-arch-base-latest` [skip ci] ([c223812](https://github.com/saltstack-formulas/powerdns-formula/commit/c223812b9a1ff23f430c986520041b553fd182cc))
* **pre-commit:** add to formula [skip ci] ([3aec1f4](https://github.com/saltstack-formulas/powerdns-formula/commit/3aec1f44abd6a562d78c16ee3cf5809b3244fa1d))
* **pre-commit:** enable/disable `rstcheck` as relevant [skip ci] ([b712795](https://github.com/saltstack-formulas/powerdns-formula/commit/b712795181c7f9ff38e3ddc1608e10e2d3960823))
* **pre-commit:** finalise `rstcheck` configuration [skip ci] ([5e79467](https://github.com/saltstack-formulas/powerdns-formula/commit/5e79467db0ed3f36f4a8c605f4703a9fe46c9da5))
* **travis:** add notifications => zulip [skip ci] ([2cf5ed9](https://github.com/saltstack-formulas/powerdns-formula/commit/2cf5ed91d1927ebb884592bdcf5ae108b02edbfb))
* **workflows/commitlint:** add to repo [skip ci] ([058986d](https://github.com/saltstack-formulas/powerdns-formula/commit/058986d9dfd3ab37fd46fb88529ccfc2ee0652ce))


### Documentation

* **readme:** use correct heading [skip ci] ([b2bcbfb](https://github.com/saltstack-formulas/powerdns-formula/commit/b2bcbfb44c4b0eb0b95a863b8984f69604c78a79))

## [0.3.1](https://github.com/saltstack-formulas/powerdns-formula/compare/v0.3.0...v0.3.1) (2020-04-18)


### Bug Fixes

* modify to get working on `debian`, `fedora` & `opensuse-leap` ([0b130f0](https://github.com/saltstack-formulas/powerdns-formula/commit/0b130f0deb8bffcbaccd3d5b8959a0d026d5cc38))


### Continuous Integration

* **kitchen+travis+inspec:** add initial platforms and test structure ([0b2180a](https://github.com/saltstack-formulas/powerdns-formula/commit/0b2180a183d0f2326e6811a1dadac93f394adfb2))


### Documentation

* **readme:** update `Testing` section ([47232be](https://github.com/saltstack-formulas/powerdns-formula/commit/47232be82a3b7ebfb00872435ca76a2d4bd460a5))


### Tests

* **inspec:** add tests ([45d97d3](https://github.com/saltstack-formulas/powerdns-formula/commit/45d97d329247aa2e5b86ac7988cd94bbac2dc495))

# [0.3.0](https://github.com/saltstack-formulas/powerdns-formula/compare/v0.2.2...v0.3.0) (2020-04-17)


### Bug Fixes

* **watchin:** fix missing `watch_in`s on `powerdns` service ([38fa08b](https://github.com/saltstack-formulas/powerdns-formula/commit/38fa08b2fb71fb6e16234af3387a5dce90aa787d))


### Features

* **ldap:** add LDAP Backend support ([3dc0675](https://github.com/saltstack-formulas/powerdns-formula/commit/3dc06757bde1ae15898b370381abf4030c93ddb0))

## [0.2.2](https://github.com/saltstack-formulas/powerdns-formula/compare/v0.2.1...v0.2.2) (2020-04-17)


### Bug Fixes

* **conf-owner:** put `user` and `group` of `pdns` service in `map.jinja` ([c8a2c0d](https://github.com/saltstack-formulas/powerdns-formula/commit/c8a2c0d1219342e0d92bab3732db0b4b6222b607))

## [0.2.1](https://github.com/saltstack-formulas/powerdns-formula/compare/v0.2.0...v0.2.1) (2020-04-17)


### Code Refactoring

* **map:** use `map.jinja` ng ([4303ab3](https://github.com/saltstack-formulas/powerdns-formula/commit/4303ab30f9bd0fca521dd0d476cc5ac6150fcd71))

# [0.2.0](https://github.com/saltstack-formulas/powerdns-formula/compare/v0.1.0...v0.2.0) (2020-04-17)


### Bug Fixes

* **salt-lint:** fix error ([c163449](https://github.com/saltstack-formulas/powerdns-formula/commit/c1634497f5f9de86824a4db60474e5bea43429c2))
* **yamllint:** fix error ([1203315](https://github.com/saltstack-formulas/powerdns-formula/commit/12033155a82105e022bf06f34cdd4688a61abdd3))


### Documentation

* **readme:** standardise structure (without testing section) ([1f24676](https://github.com/saltstack-formulas/powerdns-formula/commit/1f2467627ced5f414cbadbad9c279d74d38772b6))


### Features

* **semantic-release:** implement for this formula (without platforms) ([e0ce755](https://github.com/saltstack-formulas/powerdns-formula/commit/e0ce7550aa98b11470746a36e508658ff7ceec2b))
