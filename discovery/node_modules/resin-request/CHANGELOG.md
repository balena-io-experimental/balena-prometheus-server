# Change Log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [4.1.2] - 2016-03-17

### Changed

- Ensure query strings are not encoded when passing an `api_key`.

## [4.1.1] - 2016-03-14

### Changed

- Prevent passing an undefined `api_key` query string.

## [4.1.0] - 2016-03-13

### Added

- Add API key support via `RESIN_API_KEY`.

## [4.0.7] - 2016-03-09

### Changed

- Upgrade dependencies.
- Fix README example indentation.

## [4.0.6] - 2016-03-09

### Changed

- Remove token if its expired.

## [4.0.5] - 2016-03-03

### Changed

- Throw `ResinExpiredToken` if there is a saved token but its expired.

## [4.0.4] - 2016-02-18

### Added

- Show debug information when passing `DEBUG=true`.

### Changed

- Only set a timeout default on non-streaming HTTP requests.

## [4.0.3] - 2016-02-17

### Changed

- Set a default timeout of 30 seconds.

## [4.0.2] - 2016-02-12

### Changed

- Support `baseUrl` option.

## [4.0.1] - 2016-01-24

### Changed

- Add `statusCode` property to `ResinRequestError` instances.

## [4.0.0] - 2016-01-20

### Removed

- Remove custom stream `.length` property.

## 3.0.0 (yanked due to major issues)

## [2.4.3] - 2016-01-20

### Changed

- Make sure we send an `Accept-Encoding` header on streaming requests.
- Only disable `gzip` on streaming requests.
- Enable `strictSSL` by default.
- Change license to Apache 2.0.
- Fix `X-Transfer-Length` header not being interpreted correctly.

## [2.4.2] - 2016-01-08

### Changed

- Fix `X-Transfer-Length` decompression bug.

## [2.4.1] - 2015-11-23

### Changed

- Fix compressed/uncompressed data piping bug.

## [2.4.0] - 2015-11-17

### Added

- Fallback to `X-Transfer-Length` if no `Content-Length`.

## [2.3.2] - 2015-09-07

### Changed

- Upgrade `resin-settings-client` to v3.0.0.

## [2.3.1] - 2015-08-26

### Changed

- Translate `percent` to `percentage` in progress event.

## [2.3.0] - 2015-08-25

### Added

- Implement stream custom `.mime` property.

### Changed

- Document stream custom `.length` property.

## [2.2.5] - 2015-08-24

### Changed

- Use response `Content-Length` to determine stream `length`.

## [2.2.4] - 2015-08-24

### Changed

- Fix random error when piping a stream.

## [2.2.3] - 2015-08-07

### Changed

- Fix unit tests in Appveyor.
- Upgrade `resin-token` to v2.4.1.

## [2.2.2] - 2015-07-27

### Changed

- Prevent Authorization header from being undefined, which resulted on an exception in `request@2.53.0`.

## [2.2.1] - 2015-07-17

### Changed

- Use `tokenRefreshInterval` setting instead of `tokenValidityTime`, to decide if it's time to refresh the token.

## [2.2.0] - 2015-07-17

### Added

- Add `eta` property to progress state.
- Refresh session token at an interval.

## [2.1.0] - 2015-06-29

### Added

- Reject `request.stream()` with the request body if response status code doesn't determine a success.

### Changed

- Upgrade `resin-token`, which now stops validating a token with the server.

## [2.0.0] - 2015-06-18

### Added

- JSDoc documentation.
- License to every source files.
- Implement `request.stream()`.

### Changed

- Support promises.
- Improved README documentation.
- Rename `request()` to `send()`.

## [1.3.0] - 2015-06-12

### Changed

- Move `onProgress` callback to `options` object.

## [1.2.5] - 2015-05-18

### Changed

- Upgrade Resin Settings Client to v1.0.1, which defaults remoteUrl to api.resin.io.

## [1.2.4] - 2015-05-07

### Changed

- Fix pipe issue.

## [1.2.3] - 2015-04-21

### Changed

- Print node-request progress state on `DEBUG`.

### Added

- Configure Hound CI correctly.

## [1.2.2] - 2015-03-20

### Added

- Print request method on `DEBUG`.

## [1.2.1] - 2015-03-20

### Added

- Improve error logging support.
- Implement `DEBUG` flag.

## [1.2.0] - 2015-03-19

### Changed

- Make use of [resin-settings-client](https://github.com/resin-io-modules/resin-settings-client) to retrieve `options.remoteUrl`.

## [1.1.0] - 2015-03-18

### Removed

- `options.token` option is now obsolete, as the token is fetched automatically with [resin-token](https://github.com/resin-io-modules/resin-token).

[4.1.2]: https://github.com/resin-io-modules/resin-request/compare/v4.1.1...v4.1.2
[4.1.1]: https://github.com/resin-io-modules/resin-request/compare/v4.1.0...v4.1.1
[4.1.0]: https://github.com/resin-io-modules/resin-request/compare/v4.0.7...v4.1.0
[4.0.7]: https://github.com/resin-io-modules/resin-request/compare/v4.0.6...v4.0.7
[4.0.6]: https://github.com/resin-io-modules/resin-request/compare/v4.0.5...v4.0.6
[4.0.5]: https://github.com/resin-io-modules/resin-request/compare/v4.0.4...v4.0.5
[4.0.4]: https://github.com/resin-io-modules/resin-request/compare/v4.0.3...v4.0.4
[4.0.3]: https://github.com/resin-io-modules/resin-request/compare/v4.0.2...v4.0.3
[4.0.2]: https://github.com/resin-io-modules/resin-request/compare/v4.0.1...v4.0.2
[4.0.1]: https://github.com/resin-io-modules/resin-request/compare/v4.0.0...v4.0.1
[4.0.0]: https://github.com/resin-io-modules/resin-request/compare/v2.4.3...v4.0.0
[2.4.3]: https://github.com/resin-io-modules/resin-request/compare/v2.4.2...v2.4.3
[2.4.2]: https://github.com/resin-io-modules/resin-request/compare/v2.4.1...v2.4.2
[2.4.1]: https://github.com/resin-io-modules/resin-request/compare/v2.4.0...v2.4.1
[2.4.0]: https://github.com/resin-io-modules/resin-request/compare/v2.3.2...v2.4.0
[2.3.2]: https://github.com/resin-io-modules/resin-request/compare/v2.3.1...v2.3.2
[2.3.1]: https://github.com/resin-io-modules/resin-request/compare/v2.3.0...v2.3.1
[2.3.0]: https://github.com/resin-io-modules/resin-request/compare/v2.2.5...v2.3.0
[2.2.5]: https://github.com/resin-io-modules/resin-request/compare/v2.2.4...v2.2.5
[2.2.4]: https://github.com/resin-io-modules/resin-request/compare/v2.2.3...v2.2.4
[2.2.3]: https://github.com/resin-io-modules/resin-request/compare/v2.2.2...v2.2.3
[2.2.2]: https://github.com/resin-io-modules/resin-request/compare/v2.2.1...v2.2.2
[2.2.1]: https://github.com/resin-io-modules/resin-request/compare/v2.2.0...v2.2.1
[2.2.0]: https://github.com/resin-io-modules/resin-request/compare/v2.1.0...v2.2.0
[2.1.0]: https://github.com/resin-io-modules/resin-request/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/resin-io-modules/resin-request/compare/v1.3.0...v2.0.0
[1.3.0]: https://github.com/resin-io-modules/resin-request/compare/v1.2.5...v1.3.0
[1.2.5]: https://github.com/resin-io-modules/resin-request/compare/v1.2.4...v1.2.5
[1.2.4]: https://github.com/resin-io-modules/resin-request/compare/v1.2.3...v1.2.4
[1.2.3]: https://github.com/resin-io-modules/resin-request/compare/v1.2.2...v1.2.3
[1.2.2]: https://github.com/resin-io-modules/resin-request/compare/v1.2.1...v1.2.2
[1.2.1]: https://github.com/resin-io-modules/resin-request/compare/v1.2.0...v1.2.1
[1.2.0]: https://github.com/resin-io-modules/resin-request/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/resin-io-modules/resin-request/compare/v1.0.0...v1.1.0
