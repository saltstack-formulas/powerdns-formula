# Changelog

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
