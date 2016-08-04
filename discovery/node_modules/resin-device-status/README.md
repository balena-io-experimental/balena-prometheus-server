resin-device-status
===================

> Resin.io device status interpreter

[![npm version](https://badge.fury.io/js/resin-device-status.svg)](http://badge.fury.io/js/resin-device-status)
[![dependencies](https://david-dm.org/resin-io/resin-device-status.svg)](https://david-dm.org/resin-io/resin-device-status.svg)
[![Build Status](https://travis-ci.org/resin-io/resin-device-status.svg?branch=master)](https://travis-ci.org/resin-io/resin-device-status)
[![Build status](https://ci.appveyor.com/api/projects/status/2t0yxu6971bjd4xa/branch/master?svg=true)](https://ci.appveyor.com/project/resin-io/resin-device-status/branch/master)
[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/resin-io/chat)

Role
----

The intention of this module is to provide an encapsulated way to interpret the different device properties as a human readable device status.

**THIS MODULE IS LOW LEVEL AND IS NOT MEANT TO BE USED BY END USERS DIRECTLY**.

Unless you know what you're doing, use the [Resin SDK](https://github.com/resin-io/resin-sdk) instead.

Installation
------------

Install `resin-device-status` by running:

```sh
$ npm install --save resin-device-status
```

Documentation
-------------


* [deviceStatus](#module_deviceStatus)
    * [.status](#module_deviceStatus.status) : <code>Object</code>
    * [.statuses](#module_deviceStatus.statuses) : <code>Array.&lt;Object&gt;</code>
    * [.getStatus(device)](#module_deviceStatus.getStatus) ⇒ <code>Promise</code>

<a name="module_deviceStatus.status"></a>
### deviceStatus.status : <code>Object</code>
**Kind**: static constant of <code>[deviceStatus](#module_deviceStatus)</code>  
**Summary**: Map of possible device statuses  
**Access:** public  
<a name="module_deviceStatus.statuses"></a>
### deviceStatus.statuses : <code>Array.&lt;Object&gt;</code>
**Kind**: static constant of <code>[deviceStatus](#module_deviceStatus)</code>  
**Summary**: Array of device statuses along with their display names  
**Access:** public  
<a name="module_deviceStatus.getStatus"></a>
### deviceStatus.getStatus(device) ⇒ <code>Promise</code>
**Kind**: static method of <code>[deviceStatus](#module_deviceStatus)</code>  
**Summary**: Get status of a device  
**Access:** public  
**Fulfil**: <code>Object</code> - device status  

| Param | Type | Description |
| --- | --- | --- |
| device | <code>Object</code> | device |

**Example**  
```js
resin = require('resin-sdk')
deviceStatus = require('resin-device-status')

resin.models.device.get('9174944').then (device) ->
	deviceStatus.getStatus(device).then (status) ->
		console.log(status.key)
		console.log(status.name)
```

Support
-------

If you're having any problem, please [raise an issue](https://github.com/resin-io/resin-device-status/issues/new) on GitHub and the Resin.io team will be happy to help.

Tests
-----

Run the test suite by doing:

```sh
$ gulp test
```

Contribute
----------

- Issue Tracker: [github.com/resin-io/resin-device-status/issues](https://github.com/resin-io/resin-device-status/issues)
- Source Code: [github.com/resin-io/resin-device-status](https://github.com/resin-io/resin-device-status)

Before submitting a PR, please make sure that you include tests, and that [coffeelint](http://www.coffeelint.org/) runs without any warning:

```sh
$ gulp lint
```

License
-------

The project is licensed under the Apache 2.0 license.
