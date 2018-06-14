v3.1.0

* Added support for empty expand object options (`expand: a: {}`)

v3.0.0

* Added support for dates
* Breaking change: Utils must now provide an `isDate` method.

v2.4.0

* Throw an error if the id property is set but is empty.

v2.3.2

* Throw the correct error when an invalid resource is passed to `escapeResource`

v2.3.1

* Fixed spurious deprecation notice on cases like `$expand: a: $select: 'b'`

v2.3.0

* Deprecated `$expand: a: b: ...`
* Deprecated `$expand: a: "b"`
* Deprecated `$filter: a: b: ...`
* Added support for array and object forms of `$raw` which allows use of bindings for automatic processing of filter fragments and escaping of values.

v2.2.0

* Updated request backend to lodash ^4.0.0

v2.1.1

* Correctly escape single quotes in strings.

v2.1.0

* Added support for the `any` and `all` lambda operators.

v2.0.1

* Commit missed request.js changes.

v2.0.0

* Updated request backend to use bluebird 3.
* Added a nice error message when an option without special handling isn't a string or array.

v1.6.0

* Add suport for nested expands and expand options in the style `a: $expand: b: $select: 'c'`

v1.5.0

* Added support for operator objects with only one value, eg `a: $ne: $: 'b'`
* Added status code to thrown errors from the request backend.

v1.4.0

* Require a valid SSL certificate for the request backend by default.

v1.3.1

* Fixed the request timeout value to be 30s instead of 30ms.

v1.3.0

* Made sure that $in filters can be specified with arrays of length 1
* Default to 30s timeout for request, rather than hanging indefinitely.

v1.2.0

* Added the concept of backend parameters via `new PinejsClient(params, backendParams)` and `.clone(params, backendParams)`
* Added a `cache` backend parameter to the request backend, which is used to create a bluebird-lru-cache cache for GET request ETags.

v1.1.0

* Added a `compile` function that can be used to compile a request object to a url without sending off an actual request.
* Fixed the case of passing no params to the constructor/clone methods.

v1.0.0

* Initial release
