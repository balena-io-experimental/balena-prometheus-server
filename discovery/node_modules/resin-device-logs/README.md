resin-device-logs
-----------------

[![npm version](https://badge.fury.io/js/resin-device-logs.svg)](http://badge.fury.io/js/resin-device-logs)
[![dependencies](https://david-dm.org/resin-io/resin-device-logs.png)](https://david-dm.org/resin-io/resin-device-logs.png)
[![Build Status](https://travis-ci.org/resin-io/resin-device-logs.svg?branch=master)](https://travis-ci.org/resin-io/resin-device-logs)
[![Build status](https://ci.appveyor.com/api/projects/status/vxkytm4f0t1tuj4f?svg=true)](https://ci.appveyor.com/project/jviotti/resin-device-logs)

Join our online chat at [![Gitter chat](https://badges.gitter.im/resin-io/chat.png)](https://gitter.im/resin-io/chat)

Resin.io device logs utilities.

Role
----

The intention of this module is to provide low level access to Resin.io device logs.

**THIS MODULE IS LOW LEVEL AND IS NOT MEANT TO BE USED BY END USERS DIRECTLY**.

Unless you know what you're doing, use the [Resin SDK](https://github.com/resin-io/resin-sdk) instead.

Installation
------------

Install `resin-device-logs` by running:

```sh
$ npm install --save resin-device-logs
```

Documentation
-------------


* [logs](#module_logs)
    * [.subscribe(pubnubKeys, device)](#module_logs.subscribe) ⇒ <code>EventEmitter</code>
    * [.history(pubnubKeys, device, [options])](#module_logs.history) ⇒ <code>Promise.&lt;Array.&lt;Object&gt;&gt;</code>
    * [.historySinceLastClear(pubnubKeys, device, [options])](#module_logs.historySinceLastClear) ⇒ <code>Promise.&lt;Array.&lt;Object&gt;&gt;</code>
    * [.clear(pubnubKeys, device)](#module_logs.clear) ⇒ <code>Promise</code>
    * [.getLastClearTime(pubnubKeys, device)](#module_logs.getLastClearTime) ⇒ <code>Promise.&lt;number&gt;</code>

<a name="module_logs.subscribe"></a>

### logs.subscribe(pubnubKeys, device) ⇒ <code>EventEmitter</code>
This function emits various events:

- `line`: When a log line arrives, passing an object as an argument.
- `clear`: When the `clear` request is published (see the `clear` method)
- `error`: When an error occurs, passing an error code as an argument.

The object returned by this function also contains the following functions:

- `.unsubscribe()`: Unsubscribe from the device channel.

**Kind**: static method of [<code>logs</code>](#module_logs)  
**Summary**: Subscribe to device logs  
**Returns**: <code>EventEmitter</code> - logs  
**Access**: public  

| Param | Type | Description |
| --- | --- | --- |
| pubnubKeys | <code>Object</code> | PubNub keys |
| device | <code>Object</code> | device |

**Example**  
```js
deviceLogs = logs.subscribe
	subscribe_key: '...'
	publish_key: '...'
,
	device

deviceLogs.on 'line', (line) ->
	console.log(line.message)
	console.log(line.isSystem)
	console.log(line.timestamp)

deviceLogs.on 'error', (error) ->
	throw error

deviceLogs.on 'clear', ->
	console.clear()
```
<a name="module_logs.history"></a>

### logs.history(pubnubKeys, device, [options]) ⇒ <code>Promise.&lt;Array.&lt;Object&gt;&gt;</code>
**Kind**: static method of [<code>logs</code>](#module_logs)  
**Summary**: Get device logs history  
**Returns**: <code>Promise.&lt;Array.&lt;Object&gt;&gt;</code> - device logs history  
**Access**: public  

| Param | Type | Description |
| --- | --- | --- |
| pubnubKeys | <code>Object</code> | PubNub keys |
| device | <code>Object</code> | device |
| [options] | <code>Object</code> | other options supported by https://www.pubnub.com/docs/nodejs-javascript/api-reference#history |

**Example**  
```js
logs.history
	subscribe_key: '...'
	publish_key: '...'
,
	device
.then (lines) ->
	for line in lines
		console.log(line.message)
		console.log(line.isSystem)
		console.log(line.timestamp)
```
<a name="module_logs.historySinceLastClear"></a>

### logs.historySinceLastClear(pubnubKeys, device, [options]) ⇒ <code>Promise.&lt;Array.&lt;Object&gt;&gt;</code>
**Kind**: static method of [<code>logs</code>](#module_logs)  
**Summary**: Get device logs history after the most recent clear  
**Returns**: <code>Promise.&lt;Array.&lt;Object&gt;&gt;</code> - device logs history  
**Access**: public  

| Param | Type | Description |
| --- | --- | --- |
| pubnubKeys | <code>Object</code> | PubNub keys |
| device | <code>Object</code> | device |
| [options] | <code>Object</code> | other options supported by https://www.pubnub.com/docs/nodejs-javascript/api-reference#history |

**Example**  
```js
logs.historySinceLastClear
	subscribe_key: '...'
	publish_key: '...'
,
	device
.then (lines) ->
	for line in lines
		console.log(line.message)
		console.log(line.isSystem)
		console.log(line.timestamp)
```
<a name="module_logs.clear"></a>

### logs.clear(pubnubKeys, device) ⇒ <code>Promise</code>
**Kind**: static method of [<code>logs</code>](#module_logs)  
**Summary**: Clear device logs history  
**Returns**: <code>Promise</code> - - resolved witht he PubNub publish response  
**Access**: public  

| Param | Type | Description |
| --- | --- | --- |
| pubnubKeys | <code>Object</code> | PubNub keys |
| device | <code>Object</code> | device |

<a name="module_logs.getLastClearTime"></a>

### logs.getLastClearTime(pubnubKeys, device) ⇒ <code>Promise.&lt;number&gt;</code>
**Kind**: static method of [<code>logs</code>](#module_logs)  
**Summary**: Get the most recent device logs history clear time  
**Returns**: <code>Promise.&lt;number&gt;</code> - timetoken  
**Access**: public  

| Param | Type | Description |
| --- | --- | --- |
| pubnubKeys | <code>Object</code> | PubNub keys |
| device | <code>Object</code> | device |


Support
-------

If you're having any problem, please [raise an issue](https://github.com/resin-io/resin-device-logs/issues/new) on GitHub and the Resin.io team will be happy to help.

Tests
-----

Run the test suite by doing:

```sh
$ npm test
```

Contribute
----------

- Issue Tracker: [github.com/resin-io/resin-device-logs/issues](https://github.com/resin-io/resin-device-logs/issues)
- Source Code: [github.com/resin-io/resin-device-logs](https://github.com/resin-io/resin-device-logs)

Before submitting a PR, please make sure that you include tests, and that [coffeelint](http://www.coffeelint.org/) runs without any warning:

```sh
$ npm run lint
```

License
-------

The project is licensed under the Apache 2.0 license.
