# Change Log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [3.5.0] - 2016-04-22

- Add `proxyUrl` setting.

## [3.4.2] - 2016-02-03

- Add `deltaUrl` setting.

## [3.4.1] - 2015-12-04

- Omit tests from NPM package.

## [3.4.0] - 2015-11-16

- Add `imageMakerUrl` setting.

## [3.3.1] - 2015-11-15

- Fix `getAll()` not interpreting dynamic settings.

## [3.3.0] - 2015-11-15

- Implement `getAll()` function.

## [3.2.2] - 2015-11-12

- Default user home directory to the operating system temporary directory in all instances.

## [3.2.1] - 2015-11-09

- Default user home directory to `__dirname`.

## [3.2.0] - 2015-09-23

### Added

- Add `apiKeyVariable` setting.

## [3.1.0] - 2015-09-07

### Added

- Add `vpnUrl` setting.
- Add `registryUrl` setting.

## [3.0.0] - 2015-09-07

### Added

- Implement dynamic default settings.
- Implement environment variables support.
- Add new `resinUrl` setting.
- Implement e2e test suite.

### Changed

- Improve documentation.
- Switch to YAML for configuration files.
- Use `$HOME/[._]resinrc.yml` for user configuration file.
- Use `resinrc.yml` for per project configuration file.

## [2.1.0] - 2015-08-12

### Added

- Add `projectsDirectory` setting.

## [2.0.0] - 2015-07-17

### Changed

- Rename `tokenValidityTime` setting to `tokenRefreshInterval`.

## [1.5.0] - 2015-07-16

### Added

- Added `tokenValidityTime` setting.

## [1.4.0] - 2015-07-01

### Added

- Added `cacheDirectory` setting.
- Added `imageCacheTime` setting.

## [1.3.0] - 2015-06-18

### Added

- JSDoc documentation.
- License to every source files.

### Changed

- Improved README documentation.

## [1.2.0] - 2015-06-10

### Changed

- Upgrade [ConfJS](https://github.com/resin-io/conf.js).

## [1.1.0] - 2015-06-02

### Added

- Add `dashboardUrl` setting property.

## [1.0.1] - 2015-05-18

### Added

- Add `.hound.yml` configuration file.

### Changed

- Default `remoteUrl` to `api.resin.io`.

[3.5.0]: https://github.com/resin-io/resin-settings-client/compare/v3.4.2...v3.5.0
[3.4.2]: https://github.com/resin-io/resin-settings-client/compare/v3.4.1...v3.4.2
[3.4.1]: https://github.com/resin-io/resin-settings-client/compare/v3.4.0...v3.4.1
[3.4.0]: https://github.com/resin-io/resin-settings-client/compare/v3.3.1...v3.4.0
[3.3.1]: https://github.com/resin-io/resin-settings-client/compare/v3.3.0...v3.3.1
[3.3.0]: https://github.com/resin-io/resin-settings-client/compare/v3.2.2...v3.3.0
[3.2.2]: https://github.com/resin-io/resin-settings-client/compare/v3.2.1...v3.2.2
[3.2.1]: https://github.com/resin-io/resin-settings-client/compare/v3.2.0...v3.2.1
[3.2.0]: https://github.com/resin-io/resin-settings-client/compare/v3.1.0...v3.2.0
[3.1.0]: https://github.com/resin-io/resin-settings-client/compare/v3.0.0...v3.1.0
[3.0.0]: https://github.com/resin-io/resin-settings-client/compare/v2.1.0...v3.0.0
[2.1.0]: https://github.com/resin-io/resin-settings-client/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/resin-io/resin-settings-client/compare/v1.5.0...v2.0.0
[1.5.0]: https://github.com/resin-io/resin-settings-client/compare/v1.4.0...v1.5.0
[1.4.0]: https://github.com/resin-io/resin-settings-client/compare/v1.3.0...v1.4.0
[1.3.0]: https://github.com/resin-io/resin-settings-client/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/resin-io/resin-settings-client/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/resin-io/resin-settings-client/compare/v1.0.1...v1.1.0
[1.0.1]: https://github.com/resin-io/resin-settings-client/compare/v1.0.0...v1.0.1
