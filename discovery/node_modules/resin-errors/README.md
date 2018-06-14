resin-errors
============

> Resin.io error collection

[![npm version](https://badge.fury.io/js/resin-errors.svg)](http://badge.fury.io/js/resin-errors)
[![dependencies](https://david-dm.org/resin-io-modules/resin-errors.svg)](https://david-dm.org/resin-io-modules/resin-errors.svg)
[![Build Status](https://travis-ci.org/resin-io-modules/resin-errors.svg?branch=master)](https://travis-ci.org/resin-io-modules/resin-errors)
[![Build status](https://ci.appveyor.com/api/projects/status/c7g2vsshixiw4xw9?svg=true)](https://ci.appveyor.com/project/jviotti/resin-errors)
[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/resin-io/chat)
[![Sauce Test Status](https://saucelabs.com/browser-matrix/resin-errors.svg)](https://saucelabs.com/u/resin-errors)

Role
----

The intention of this module is to provide a collection of `Error` instances to be used by the Resin SDK.

**THIS MODULE IS LOW LEVEL AND IS NOT MEANT TO BE USED BY END USERS DIRECTLY**.

Unless you know what you're doing, use the [Resin SDK](https://github.com/resin-io/resin-sdk) instead.

Installation
------------

Install `resin-errors` by running:

```sh
$ npm install --save resin-errors
```

Documentation
-------------


* [errors](#module_errors)
    * [~ResinInvalidDeviceType](#module_errors..ResinInvalidDeviceType)
        * [new ResinInvalidDeviceType(type)](#new_module_errors..ResinInvalidDeviceType_new)
    * [~ResinDiscontinuedDeviceType](#module_errors..ResinDiscontinuedDeviceType)
        * [new ResinDiscontinuedDeviceType(type)](#new_module_errors..ResinDiscontinuedDeviceType_new)
    * [~ResinMalformedToken](#module_errors..ResinMalformedToken)
        * [new ResinMalformedToken(token)](#new_module_errors..ResinMalformedToken_new)
    * [~ResinSupervisorLockedError](#module_errors..ResinSupervisorLockedError)
        * [new ResinSupervisorLockedError(token)](#new_module_errors..ResinSupervisorLockedError_new)
    * [~ResinExpiredToken](#module_errors..ResinExpiredToken)
        * [new ResinExpiredToken(token)](#new_module_errors..ResinExpiredToken_new)
    * [~ResinApplicationNotFound](#module_errors..ResinApplicationNotFound)
        * [new ResinApplicationNotFound(application)](#new_module_errors..ResinApplicationNotFound_new)
    * ~~[~ResinBuildNotFound](#module_errors..ResinBuildNotFound)~~
        * [new ResinBuildNotFound(build)](#new_module_errors..ResinBuildNotFound_new)
    * [~ResinReleaseNotFound](#module_errors..ResinReleaseNotFound)
        * [new ResinReleaseNotFound(release)](#new_module_errors..ResinReleaseNotFound_new)
    * [~ResinImageNotFound](#module_errors..ResinImageNotFound)
        * [new ResinImageNotFound(image)](#new_module_errors..ResinImageNotFound_new)
    * [~ResinServiceNotFound](#module_errors..ResinServiceNotFound)
        * [new ResinServiceNotFound(service)](#new_module_errors..ResinServiceNotFound_new)
    * [~ResinDeviceNotFound](#module_errors..ResinDeviceNotFound)
        * [new ResinDeviceNotFound(device)](#new_module_errors..ResinDeviceNotFound_new)
    * [~ResinAmbiguousDevice](#module_errors..ResinAmbiguousDevice)
        * [new ResinAmbiguousDevice(device)](#new_module_errors..ResinAmbiguousDevice_new)
    * [~ResinAmbiguousApplication](#module_errors..ResinAmbiguousApplication)
        * [new ResinAmbiguousApplication(application)](#new_module_errors..ResinAmbiguousApplication_new)
    * [~ResinKeyNotFound](#module_errors..ResinKeyNotFound)
        * [new ResinKeyNotFound(key)](#new_module_errors..ResinKeyNotFound_new)
    * [~ResinRequestError](#module_errors..ResinRequestError)
        * [new ResinRequestError(body, statusCode, [requestOptions])](#new_module_errors..ResinRequestError_new)
    * [~ResinNotLoggedIn](#module_errors..ResinNotLoggedIn)
    * [~ResinInvalidParameterError](#module_errors..ResinInvalidParameterError)

<a name="module_errors..ResinInvalidDeviceType"></a>

### errors~ResinInvalidDeviceType
**Kind**: inner class of [<code>errors</code>](#module_errors)  
**Summary**: Resin invalid device type  
**Access**: public  
<a name="new_module_errors..ResinInvalidDeviceType_new"></a>

#### new ResinInvalidDeviceType(type)
**Returns**: <code>Error</code> - error instance  

| Param | Type | Description |
| --- | --- | --- |
| type | <code>String</code> | device type |

**Example**  
```js
throw new errors.ResinInvalidDeviceType('raspberry-pi')
```
<a name="module_errors..ResinDiscontinuedDeviceType"></a>

### errors~ResinDiscontinuedDeviceType
**Kind**: inner class of [<code>errors</code>](#module_errors)  
**Summary**: Resin discontinued device type  
**Access**: public  
<a name="new_module_errors..ResinDiscontinuedDeviceType_new"></a>

#### new ResinDiscontinuedDeviceType(type)
The device type that you specified is invalid because it is
discontinued, and this operation is no longer supported.

**Returns**: <code>Error</code> - error instance  

| Param | Type | Description |
| --- | --- | --- |
| type | <code>String</code> | device type |

**Example**  
```js
throw new errors.ResinDiscontinuedDeviceType('edge')
```
<a name="module_errors..ResinMalformedToken"></a>

### errors~ResinMalformedToken
**Kind**: inner class of [<code>errors</code>](#module_errors)  
**Summary**: Resin malformed token  
**Access**: public  
<a name="new_module_errors..ResinMalformedToken_new"></a>

#### new ResinMalformedToken(token)
**Returns**: <code>Error</code> - error instance  

| Param | Type | Description |
| --- | --- | --- |
| token | <code>String</code> | token |

**Example**  
```js
throw new errors.ResinMalformedToken('1234')
```
<a name="module_errors..ResinSupervisorLockedError"></a>

### errors~ResinSupervisorLockedError
**Kind**: inner class of [<code>errors</code>](#module_errors)  
**Summary**: The device supervisor is locked  
**Access**: public  
<a name="new_module_errors..ResinSupervisorLockedError_new"></a>

#### new ResinSupervisorLockedError(token)
**Returns**: <code>Error</code> - error instance  

| Param | Type | Description |
| --- | --- | --- |
| token | <code>String</code> | token |

**Example**  
```js
throw new errors.ResinSupervisorLockedError()
```
<a name="module_errors..ResinExpiredToken"></a>

### errors~ResinExpiredToken
**Kind**: inner class of [<code>errors</code>](#module_errors)  
**Summary**: Resin expired token  
**Access**: public  
<a name="new_module_errors..ResinExpiredToken_new"></a>

#### new ResinExpiredToken(token)
**Returns**: <code>Error</code> - error instance  

| Param | Type | Description |
| --- | --- | --- |
| token | <code>String</code> | token |

**Example**  
```js
throw new errors.ResinExpiredToken('1234')
```
<a name="module_errors..ResinApplicationNotFound"></a>

### errors~ResinApplicationNotFound
**Kind**: inner class of [<code>errors</code>](#module_errors)  
**Summary**: Resin application not found  
**Access**: public  
<a name="new_module_errors..ResinApplicationNotFound_new"></a>

#### new ResinApplicationNotFound(application)
**Returns**: <code>Error</code> - error instance  

| Param | Type | Description |
| --- | --- | --- |
| application | <code>String</code> \| <code>Number</code> | application name or id |

**Example**  
```js
throw new errors.ResinApplicationNotFound('MyApp')
```
<a name="module_errors..ResinBuildNotFound"></a>

### ~~errors~ResinBuildNotFound~~
***Deprecated***

**Kind**: inner class of [<code>errors</code>](#module_errors)  
**Summary**: Resin build not found  
**Access**: public  
<a name="new_module_errors..ResinBuildNotFound_new"></a>

#### new ResinBuildNotFound(build)
**Returns**: <code>Error</code> - error instance  

| Param | Type | Description |
| --- | --- | --- |
| build | <code>Number</code> | build id |

**Example**  
```js
throw new errors.ResinBuildNotFound(123)
```
<a name="module_errors..ResinReleaseNotFound"></a>

### errors~ResinReleaseNotFound
**Kind**: inner class of [<code>errors</code>](#module_errors)  
**Summary**: Resin release not found  
**Access**: public  
<a name="new_module_errors..ResinReleaseNotFound_new"></a>

#### new ResinReleaseNotFound(release)
**Returns**: <code>Error</code> - error instance  

| Param | Type | Description |
| --- | --- | --- |
| release | <code>Number</code> | release id |

**Example**  
```js
throw new errors.ResinReleaseNotFound(123)
```
<a name="module_errors..ResinImageNotFound"></a>

### errors~ResinImageNotFound
**Kind**: inner class of [<code>errors</code>](#module_errors)  
**Summary**: Resin image not found  
**Access**: public  
<a name="new_module_errors..ResinImageNotFound_new"></a>

#### new ResinImageNotFound(image)
**Returns**: <code>Error</code> - error instance  

| Param | Type | Description |
| --- | --- | --- |
| image | <code>Number</code> | image id |

**Example**  
```js
throw new errors.ResinImageNotFound(123)
```
<a name="module_errors..ResinServiceNotFound"></a>

### errors~ResinServiceNotFound
**Kind**: inner class of [<code>errors</code>](#module_errors)  
**Summary**: Resin service not found  
**Access**: public  
<a name="new_module_errors..ResinServiceNotFound_new"></a>

#### new ResinServiceNotFound(service)
**Returns**: <code>Error</code> - error instance  

| Param | Type | Description |
| --- | --- | --- |
| service | <code>Number</code> | service id |

**Example**  
```js
throw new errors.ResinServiceNotFound(123)
```
<a name="module_errors..ResinDeviceNotFound"></a>

### errors~ResinDeviceNotFound
**Kind**: inner class of [<code>errors</code>](#module_errors)  
**Summary**: Resin device not found  
**Access**: public  
<a name="new_module_errors..ResinDeviceNotFound_new"></a>

#### new ResinDeviceNotFound(device)
**Returns**: <code>Error</code> - error instance  

| Param | Type | Description |
| --- | --- | --- |
| device | <code>String</code> \| <code>Number</code> | device name or id |

**Example**  
```js
throw new errors.ResinDeviceNotFound('MyDevice')
```
<a name="module_errors..ResinAmbiguousDevice"></a>

### errors~ResinAmbiguousDevice
**Kind**: inner class of [<code>errors</code>](#module_errors)  
**Summary**: Resin ambiguous device  
**Access**: public  
<a name="new_module_errors..ResinAmbiguousDevice_new"></a>

#### new ResinAmbiguousDevice(device)
**Returns**: <code>Error</code> - error instance  

| Param | Type | Description |
| --- | --- | --- |
| device | <code>String</code> \| <code>Number</code> | device name or id |

**Example**  
```js
throw new errors.ResinAmbiguousDevice('MyDevice')
```
<a name="module_errors..ResinAmbiguousApplication"></a>

### errors~ResinAmbiguousApplication
**Kind**: inner class of [<code>errors</code>](#module_errors)  
**Summary**: Resin ambiguous application  
**Access**: public  
<a name="new_module_errors..ResinAmbiguousApplication_new"></a>

#### new ResinAmbiguousApplication(application)
**Returns**: <code>Error</code> - error instance  

| Param | Type | Description |
| --- | --- | --- |
| application | <code>String</code> \| <code>Number</code> | application name or id |

**Example**  
```js
throw new errors.ResinAmbiguousApplication('MyApp')
```
<a name="module_errors..ResinKeyNotFound"></a>

### errors~ResinKeyNotFound
**Kind**: inner class of [<code>errors</code>](#module_errors)  
**Summary**: Resin key not found  
**Access**: public  
<a name="new_module_errors..ResinKeyNotFound_new"></a>

#### new ResinKeyNotFound(key)
**Returns**: <code>Error</code> - error instance  

| Param | Type | Description |
| --- | --- | --- |
| key | <code>String</code> \| <code>Number</code> | key name, id or value |

**Example**  
```js
throw new errors.ResinKeyNotFound('MyKey')
```
<a name="module_errors..ResinRequestError"></a>

### errors~ResinRequestError
**Kind**: inner class of [<code>errors</code>](#module_errors)  
**Summary**: Resin request error  
**Access**: public  
<a name="new_module_errors..ResinRequestError_new"></a>

#### new ResinRequestError(body, statusCode, [requestOptions])
**Returns**: <code>Error</code> - error instance  

| Param | Type | Description |
| --- | --- | --- |
| body | <code>String</code> | response body |
| statusCode | <code>Number</code> | http status code |
| [requestOptions] | <code>Object</code> | options used to make the request |

**Example**  
```js
throw new errors.ResinRequestError('Unauthorized')
```
<a name="module_errors..ResinNotLoggedIn"></a>

### errors~ResinNotLoggedIn
**Kind**: inner class of [<code>errors</code>](#module_errors)  
**Summary**: Resin not logged in  
**Access**: public  
<a name="module_errors..ResinInvalidParameterError"></a>

### errors~ResinInvalidParameterError
**Kind**: inner class of [<code>errors</code>](#module_errors)  
**Summary**: Resin invalid parameter  
**Access**: public  

Support
-------

If you're having any problem, please [raise an issue](https://github.com/resin-io-modules/resin-errors/issues/new) on GitHub and the Resin.io team will be happy to help.

Tests
-----

Run the test suite by doing:

```sh
$ gulp test
```

Contribute
----------

- Issue Tracker: [github.com/resin-io-modules/resin-errors/issues](https://github.com/resin-io-modules/resin-errors/issues)
- Source Code: [github.com/resin-io-modules/resin-errors](https://github.com/resin-io-modules/resin-errors)

Before submitting a PR, please make sure that you include tests, and that [coffeelint](http://www.coffeelint.org/) runs without any warning:

```sh
$ gulp lint
```

License
-------

The project is licensed under the Apache 2.0 license.
