resin-request
=============

> Resin.io HTTP client.

[![npm version](https://badge.fury.io/js/resin-request.svg)](http://badge.fury.io/js/resin-request)
[![dependencies](https://david-dm.org/resin-io-modules/resin-request.svg)](https://david-dm.org/resin-io-modules/resin-request.svg)
[![Build Status](https://travis-ci.org/resin-io-modules/resin-request.svg?branch=master)](https://travis-ci.org/resin-io-modules/resin-request)
[![Build status](https://ci.appveyor.com/api/projects/status/8qmwhh1vhm27otn4/branch/master?svg=true)](https://ci.appveyor.com/project/resin-io/resin-request/branch/master)
[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/resin-io/chat)

Role
----

The intention of this module is to provide an exclusive client to make HTTP requests to the Resin.io servers.

**THIS MODULE IS LOW LEVEL AND IS NOT MEANT TO BE USED BY END USERS DIRECTLY**.

Unless you know what you're doing, use the [Resin SDK](https://github.com/resin-io/resin-sdk) instead.

Installation
------------

Install `resin-request` by running:

```sh
$ npm install --save resin-request
```

Documentation
-------------

The module returns a _factory function_ that you use to get an instance of the auth module.

It accepts the following params:

| Param | Type | Description |
| --- | --- | --- |
| options | <code>Object</code> | options |
| options.auth | <code>Object</code> | An instantiated [resin-auth](https://github.com/resin-io-modules/resin-auth) instance |
| options.debug | <code>boolean</code> | when set to `true` will log the request details in case of error. |
| options.isBrowser | <code>boolean</code> | set to `true` if the runtime is the browser. |
| options.interceptors | <code>Array&lt;Interceptor&gt;</code> | An initial array of interceptors |

**Example**
```js
var request = require('resin-request')({
	auth: auth,
	debug: false,
	isBrowser: false
})
```


* [request](#module_request)
    * _static_
        * [.interceptors](#module_request.interceptors) : <code>Array.&lt;Interceptor&gt;</code>
        * [.send(options)](#module_request.send) ⇒ <code>Promise.&lt;Object&gt;</code>
        * [.stream(options)](#module_request.stream) ⇒ <code>Promise.&lt;Stream&gt;</code>
    * _inner_
        * [~Interceptor](#module_request..Interceptor) : <code>object</code>

<a name="module_request.interceptors"></a>

### request.interceptors : <code>Array.&lt;Interceptor&gt;</code>
The current array of interceptors to use. Interceptors intercept requests made
by calls to `.stream()` and `.send()` (some of which are made internally) and
are executed in the order they appear in this array for requests, and in the
reverse order for responses.

**Kind**: static property of [<code>request</code>](#module_request)  
**Summary**: Array of interceptors  
**Access**: public  
**Example**  
```js
request.interceptors.push(
	requestError: (error) ->
		console.log(error)
		throw error
)
```
<a name="module_request.send"></a>

### request.send(options) ⇒ <code>Promise.&lt;Object&gt;</code>
This function automatically handles authorization with Resin.io.

The module scans your environment for a saved session token. Alternatively, you may pass the `apiKey` option. Otherwise, the request is made anonymously.

**Kind**: static method of [<code>request</code>](#module_request)  
**Summary**: Perform an HTTP request to Resin.io  
**Returns**: <code>Promise.&lt;Object&gt;</code> - response  
**Access**: public  

| Param | Type | Default | Description |
| --- | --- | --- | --- |
| options | <code>Object</code> |  | options |
| [options.method] | <code>String</code> | <code>&#x27;GET&#x27;</code> | method |
| options.url | <code>String</code> |  | relative url |
| [options.apiKey] | <code>String</code> |  | api key |
| [options.responseFormat] | <code>String</code> |  | explicit expected response format, can be one of 'blob', 'json', 'text', 'none'. Defaults to sniffing the content-type |
| [options.body] | <code>\*</code> |  | body |

**Example**  
```js
request.send
	method: 'GET'
	baseUrl: 'https://api.resin.io'
	url: '/foo'
.get('body')
```
**Example**  
```js
request.send
	method: 'POST'
	baseUrl: 'https://api.resin.io'
	url: '/bar'
	data:
		hello: 'world'
.get('body')
```
<a name="module_request.stream"></a>

### request.stream(options) ⇒ <code>Promise.&lt;Stream&gt;</code>
**Not implemented for the browser.**
This function emits a `progress` event, passing an object with the following properties:

- `Number percent`: from 0 to 100.
- `Number total`: total bytes to be transmitted.
- `Number received`: number of bytes transmitted.
- `Number eta`: estimated remaining time, in seconds.

The stream may also contain the following custom properties:

- `String .mime`: Equals the value of the `Content-Type` HTTP header.

See `request.send()` for an explanation on how this function handles authentication.

**Kind**: static method of [<code>request</code>](#module_request)  
**Summary**: Stream an HTTP response from Resin.io.  
**Returns**: <code>Promise.&lt;Stream&gt;</code> - response  
**Access**: public  

| Param | Type | Default | Description |
| --- | --- | --- | --- |
| options | <code>Object</code> |  | options |
| [options.method] | <code>String</code> | <code>&#x27;GET&#x27;</code> | method |
| options.url | <code>String</code> |  | relative url |
| [options.body] | <code>\*</code> |  | body |

**Example**  
```js
request.stream
	method: 'GET'
	baseUrl: 'https://img.resin.io'
	url: '/download/foo'
.then (stream) ->
	stream.on 'progress', (state) ->
		console.log(state)

	stream.pipe(fs.createWriteStream('/opt/download'))
```
<a name="module_request..Interceptor"></a>

### request~Interceptor : <code>object</code>
An interceptor implements some set of the four interception hook callbacks.
To continue processing, each function should return a value or a promise that
successfully resolves to a value.

To halt processing, each function should throw an error or return a promise that
rejects with an error.

**Kind**: inner typedef of [<code>request</code>](#module_request)  
**Properties**

| Name | Type | Description |
| --- | --- | --- |
| [request] | <code>function</code> | Callback invoked before requests are made. Called with the request options, should return (or resolve to) new request options, or throw/reject. |
| [response] | <code>function</code> | Callback invoked before responses are returned. Called with the response, should return (or resolve to) a new response, or throw/reject. |
| [requestError] | <code>function</code> | Callback invoked if an error happens before a request. Called with the error itself, caused by a preceeding request interceptor rejecting/throwing an error for the request, or a failing in preflight token validation. Should return (or resolve to) new request options, or throw/reject. |
| [responseError] | <code>function</code> | Callback invoked if an error happens in the response. Called with the error itself, caused by a preceeding response interceptor rejecting/throwing an error for the request, a network error, or an error response from the server. Should return (or resolve to) a new response, or throw/reject. |


Support
-------

If you're having any problem, please [raise an issue](https://github.com/resin-io-modules/resin-request/issues/new) on GitHub and the Resin.io team will be happy to help.

Tests
-----

Run the test suite by doing:

```sh
$ npm test
```

Contribute
----------

- Issue Tracker: [github.com/resin-io-modules/resin-request/issues](https://github.com/resin-io-modules/resin-request/issues)
- Source Code: [github.com/resin-io-modules/resin-request](https://github.com/resin-io-modules/resin-request)

Before submitting a PR, please make sure that you include tests, and that [coffeelint](http://www.coffeelint.org/) runs without any warning:

```sh
$ gulp lint
```

License
-------

The project is licensed under the Apache 2.0 license.
