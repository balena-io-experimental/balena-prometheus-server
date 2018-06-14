resin-register-device
=====================

> Resin.io device registration utilities.

[![npm version](https://badge.fury.io/js/resin-register-device.svg)](http://badge.fury.io/js/resin-register-device)
[![dependencies](https://david-dm.org/resin-io-modules/resin-register-device.svg)](https://david-dm.org/resin-io-modules/resin-register-device.svg)
[![Build Status](https://travis-ci.org/resin-io-modules/resin-register-device.svg?branch=master)](https://travis-ci.org/resin-io-modules/resin-register-device)
[![Build status](https://ci.appveyor.com/api/projects/status/uh8bg45pxxyx2qif/branch/master?svg=true)](https://ci.appveyor.com/project/resin-io/resin-register-device/branch/master)
[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/resin-io/chat)

Installation
------------

Install `resin-register-device` by running:

```sh
$ npm install --save resin-register-device
```

Documentation
-------------

Resin-Register-Device exports a factory function, which must be called with a dependencies object, containing a configured [`resin-request`](https://github.com/resin-io-modules/resin-request) instance.

Example:
```coffee
deviceRegister = require('resin-register-device')({
	request: request # An instantiated resin-request instance
})
```

### deviceRegister.generateUniqueKey()

Generate a random key, useful for both uuid and api key.

Example:
```coffee
randomKey = deviceRegister.generateUniqueKey()
# randomKey is a randomly generated key that can be used as either a uuid or an api key
console.log(randomKey)
```

### deviceRegister.register(Object options, Function callback)

Register a device with Resin.io.

**Notice**: You can use this function as a promise if you omit the `callback` argument.

The `options` object requires the following properties:

- `Number userId`: The user id.
- `Number applicationId`: The application id.
- `String uuid`: The device's UUID.
- `String deviceType`: The device type slug.
- `String deviceApiKey`: The API key to create for the newly registered device.
- `String provisioningApiKey`: The provisioning API Key.
- `String apiEndpoint`: The API endpoint.

The `callback` gets called with two arguments: `(error, deviceInfo)`, where `deviceInfo` is an object containing one property: the `id` for the device that was just registered.

Example:

```coffee
deviceRegister.register
		userId: 199
		applicationId: 10350
		uuid: '...'
		deviceType: 'raspberry-pi'
		deviceApiKey: '...'
		provisioningApiKey: '...'
		apiEndpoint: 'https://api.resin.io'
	, (error, deviceInfo) ->
		throw error if error?
		console.log(deviceInfo) # { id }
```

Tests
-----

Run the test suite by doing:

```sh
$ npm test
```

Contribute
----------

- Issue Tracker: [github.com/resin-io-modules/resin-register-device/issues](https://github.com/resin-io-modules/resin-register-device/issues)
- Source Code: [github.com/resin-io-modules/resin-register-device](https://github.com/resin-io-modules/resin-register-device)

Before submitting a PR, please make sure that you include tests, and that [coffeelint](http://www.coffeelint.org/) runs without any warning:

```sh
$ npm run lint
```

Support
-------

If you're having any problem, please [raise an issue](https://github.com/resin-io-modules/resin-register-device/issues/new) on GitHub.

License
-------

The project is licensed under the Apache 2.0 license.
