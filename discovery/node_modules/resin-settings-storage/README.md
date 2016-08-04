resin-settings-storage
----------------------

[![npm version](https://badge.fury.io/js/resin-settings-storage.svg)](http://badge.fury.io/js/resin-settings-storage)
[![dependencies](https://david-dm.org/resin-io/resin-settings-storage.png)](https://david-dm.org/resin-io/resin-settings-storage.png)
[![Build Status](https://travis-ci.org/resin-io/resin-settings-storage.svg?branch=master)](https://travis-ci.org/resin-io/resin-settings-storage)
[![Build status](https://ci.appveyor.com/api/projects/status/w9kqe2ok1rbkj42y?svg=true)](https://ci.appveyor.com/project/resin-io/resin-settings-storage)

Join our online chat at [![Gitter chat](https://badges.gitter.im/resin-io/chat.png)](https://gitter.im/resin-io/chat)

Resin.io settings storage utilities.

Role
----

The intention of this module is to provide low level access to how a Resin.io persists settings in both the filesystem and the browser.

**THIS MODULE IS LOW LEVEL AND IS NOT MEANT TO BE USED BY END USERS DIRECTLY**.

Unless you know what you're doing, use the [Resin SDK](https://github.com/resin-io/resin-sdk) instead.

Installation
------------

Install `resin-settings-storage` by running:

```sh
$ npm install --save resin-settings-storage
```

Documentation
-------------


* [storage](#module_storage)
  * [.set(name, value)](#module_storage.set) ⇒ <code>Promise</code>
  * [.get(name)](#module_storage.get) ⇒ <code>Promise.&lt;\*&gt;</code>
  * [.has(name)](#module_storage.has) ⇒ <code>Promise.&lt;Boolean&gt;</code>
  * [.remove(name)](#module_storage.remove) ⇒ <code>Promise</code>

<a name="module_storage.set"></a>
### storage.set(name, value) ⇒ <code>Promise</code>
**Kind**: static method of <code>[storage](#module_storage)</code>  
**Summary**: Set a value  
**Access:** public  

| Param | Type | Description |
| --- | --- | --- |
| name | <code>String</code> | name |
| value | <code>\*</code> | value |

**Example**  
```js
storage.set('token', '1234')
```
<a name="module_storage.get"></a>
### storage.get(name) ⇒ <code>Promise.&lt;\*&gt;</code>
**Kind**: static method of <code>[storage](#module_storage)</code>  
**Summary**: Get a value  
**Returns**: <code>Promise.&lt;\*&gt;</code> - value or undefined  
**Access:** public  

| Param | Type | Description |
| --- | --- | --- |
| name | <code>String</code> | name |

**Example**  
```js
storage.get('token').then (token) ->
	console.log(token)
```
<a name="module_storage.has"></a>
### storage.has(name) ⇒ <code>Promise.&lt;Boolean&gt;</code>
**Kind**: static method of <code>[storage](#module_storage)</code>  
**Summary**: Check if a value exists  
**Returns**: <code>Promise.&lt;Boolean&gt;</code> - has value  
**Access:** public  

| Param | Type | Description |
| --- | --- | --- |
| name | <code>String</code> | name |

**Example**  
```js
storage.has('token').then (hasToken) ->
	if hasToken
		console.log('Yes')
	else
		console.log('No')
```
<a name="module_storage.remove"></a>
### storage.remove(name) ⇒ <code>Promise</code>
**Kind**: static method of <code>[storage](#module_storage)</code>  
**Summary**: Remove a value  
**Access:** public  

| Param | Type | Description |
| --- | --- | --- |
| name | <code>String</code> | name |

**Example**  
```js
storage.remove('token')
```

Support
-------

If you're having any problem, please [raise an issue](https://github.com/resin-io/resin-settings-storage/issues/new) on GitHub and the Resin.io team will be happy to help.

Tests
-----

Run the test suite by doing:

```sh
$ gulp test
```

Contribute
----------

- Issue Tracker: [github.com/resin-io/resin-settings-storage/issues](https://github.com/resin-io/resin-settings-storage/issues)
- Source Code: [github.com/resin-io/resin-settings-storage](https://github.com/resin-io/resin-settings-storage)

Before submitting a PR, please make sure that you include tests, and that [coffeelint](http://www.coffeelint.org/) runs without any warning:

```sh
$ gulp lint
```

License
-------

The project is licensed under the Apache 2.0 license.
