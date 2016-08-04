resin-register-device
=====================

> Resin.io device registration utilities.

[![npm version](https://badge.fury.io/js/resin-register-device.svg)](http://badge.fury.io/js/resin-register-device)
[![dependencies](https://david-dm.org/resin-io/resin-register-device.svg)](https://david-dm.org/resin-io/resin-register-device.svg)
[![Build Status](https://travis-ci.org/resin-io/resin-register-device.svg?branch=master)](https://travis-ci.org/resin-io/resin-register-device)
[![Build status](https://ci.appveyor.com/api/projects/status/uh8bg45pxxyx2qif?svg=true)](https://ci.appveyor.com/project/jviotti/resin-register-device)
[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/resin-io/chat)
[![Sauce Test Status](https://saucelabs.com/browser-matrix/resin-register-dev.svg)](https://saucelabs.com/u/resin-register-dev)

Installation
------------

Install `resin-register-device` by running:

```sh
$ npm install --save resin-register-device
```

Documentation
-------------

### deviceRegister.generateUUID(Function callback)

Generate a random UUID.

**Notice**: You can use this function as a promise if you omit the `callback` argument.

Example:
```coffee
deviceRegister.generateUUID (error, uuid) ->
	throw error if error?
	# uuid is a generated UUID that can be used for registering
	console.log(uuid)
```

### deviceRegister.register(Object pineInstance, Object options, Function callback)

Register a device with Resin.io.

**Notice**: You can use this function as a promise if you omit the `callback` argument.

It requires a Pine instance, such as [resin-pine](https://github.com/resin-io/resin-pine) or a custom one that meets your needs.

The `options` object requires the following properties:

- `Number userId`: The user id.
- `Number applicationId`: The application id.
- `String deviceType`: The device type slug.
- `String apiKey`: The API key.
- `[String uuid]`: The uuid. Notice this property is optional, and it will be generated if absent.
- `[String apiPrefix]`: The API prefix. Notice this property is optional, and it will use the one from the passed pine instance if absent.

The `callback` gets called with two arguments: `(error, device)`, where `device` is an object containing two properties: an `id` and the `uuid`.

Example:

```coffee
deviceRegister = require('resin-register-device')
pine = require('resin-pine')

deviceRegister.register pine,
	userId: 199
	applicationId: 10350
	deviceType: 'raspberry-pi'
	apiKey: '...'
, (error, device) ->
	throw error if error?
	console.log(device)
```

Tests
-----

Run the test suite by doing:

```sh
$ gulp test
```

Contribute
----------

- Issue Tracker: [github.com/resin-io/resin-register-device/issues](https://github.com/resin-io/resin-register-device/issues)
- Source Code: [github.com/resin-io/resin-register-device](https://github.com/resin-io/resin-register-device)

Before submitting a PR, please make sure that you include tests, and that [coffeelint](http://www.coffeelint.org/) runs without any warning:

```sh
$ gulp lint
```

Support
-------

If you're having any problem, please [raise an issue](https://github.com/resin-io/resin-register-device/issues/new) on GitHub.

License
-------

The project is licensed under the Apache 2.0 license.
