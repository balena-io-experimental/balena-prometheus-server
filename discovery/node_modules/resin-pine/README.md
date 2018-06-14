resin-pine
----------

[![npm version](https://badge.fury.io/js/resin-pine.svg)](http://badge.fury.io/js/resin-pine)
[![dependencies](https://david-dm.org/resin-io-modules/resin-pine.png)](https://david-dm.org/resin-io-modules/resin-pine.png)
[![Circle Build Status](https://circleci.com/gh/resin-io-modules/resin-pine/tree/master.svg?style=shield)](https://circleci.com/gh/resin-io-modules/resin-pine)
[![Appveyor Build status](https://ci.appveyor.com/api/projects/status/cwh3jfc7vur5bvmu/branch/master?svg=true)](https://ci.appveyor.com/project/resin-io/resin-pine/branch/master)

Join our online chat at [![Gitter chat](https://badges.gitter.im/resin-io/chat.png)](https://gitter.im/resin-io/chat)

Resin.io PineJS client.

Role
----

The intention of this module is to provide a ready to use subclass of [pinejs-client-js](https://github.com/resin-io/pinejs-client-js) which uses [resin-request](https://github.com/resin-io-modules/resin-request).

**THIS MODULE IS LOW LEVEL AND IS NOT MEANT TO BE USED BY END USERS DIRECTLY**.

Unless you know what you're doing, use the [Resin SDK](https://github.com/resin-io/resin-sdk) instead.

Installation
------------

Install `resin-pine` by running:

```sh
$ npm install --save resin-pine
```

Documentation
-------------

Instantiate the PineJS like that:

```
var pine = require('resin-pine')({
  apiUrl: "https://api.resin.io/",
  apiVersion: "v2",
  request: request, // An instantiated resin-request instance
  auth: auth // An instantiated resin-auth instance
})
```

Where the factory method accepts the following options:
* `apiUrl`, string, **required**, is the Resin.io API url like `https://api.resin.io/`,
* `apiVersion`, string, **required**, is the version of the API to talk to, like `v2`. The current stable version is `v2`,
* `apiKey`, string, *optional*, is the API key to make the requests with,
* `request`, object, an instantiated [resin-request](https://github.com/resin-io/resin-request) instance.
* `auth`, object, an instantiated [resin-auth](https://github.com/resin-io-modules/resin-auth) instance.


Head over to [pinejs-client-js](https://github.com/resin-io/pinejs-client-js) for the returned PineJS instance documentation.

Support
-------

If you're having any problem, please [raise an issue](https://github.com/resin-io-modules/resin-pine/issues/new) on GitHub and the Resin.io team will be happy to help.

Tests
-----

Run the test suite by doing:

```sh
$ npm test
```

Contribute
----------

- Issue Tracker: [github.com/resin-io-modules/resin-pine/issues](https://github.com/resin-io-modules/resin-pine/issues)
- Source Code: [github.com/resin-io-modules/resin-pine](https://github.com/resin-io-modules/resin-pine)

Before submitting a PR, please make sure that you include tests, and that [coffeelint](http://www.coffeelint.org/) runs without any warning:

```sh
$ npm run lint
```

License
-------

The project is licensed under the Apache 2.0 license.
