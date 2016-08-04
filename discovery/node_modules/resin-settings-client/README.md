resin-settings-client
---------------------

[![npm version](https://badge.fury.io/js/resin-settings-client.svg)](http://badge.fury.io/js/resin-settings-client)
[![dependencies](https://david-dm.org/resin-io/resin-settings-client.png)](https://david-dm.org/resin-io/resin-settings-client.png)
[![Build Status](https://travis-ci.org/resin-io/resin-settings-client.svg?branch=master)](https://travis-ci.org/resin-io/resin-settings-client)
[![Build status](https://ci.appveyor.com/api/projects/status/a1tfwovw1kp421sa?svg=true)](https://ci.appveyor.com/project/jviotti/resin-settings-client)

Join our online chat at [![Gitter chat](https://badges.gitter.im/resin-io/chat.png)](https://gitter.im/resin-io/chat)

Resin.io client application shared settings.

Role
----

The intention of this module is to provice low level access to user configurable Resin.io simple settings.

**THIS MODULE IS LOW LEVEL AND IS NOT MEANT TO BE USED BY END USERS DIRECTLY**.

Unless you know what you're doing, use the [Resin SDK](https://github.com/resin-io/resin-sdk) instead.

Installation
------------

Install `resin-settings-client` by running:

```sh
$ npm install --save resin-settings-client
```

Documentation
-------------

This module attempts to retrieve configuration from the following places:

**UNIX:**

- Default settings.
- `$HOME/.resinrc.yml`.
- `$PWD/resinrc.yml`.
- Environment variables matching `RESINRC_<SETTING_NAME>`.

**Windows:**

- Default settings.
- `%UserProfile%\_resinrc.yml`.
- `%cd%\resinrc.yml`.
- Environment variables matching `RESINRC_<SETTING_NAME>`.

The values from all locations are merged together, with sources listed below taking precedence.

For example:

```sh
	$ cat $HOME/.resinrc.yml
	resinUrl: 'resinstaging.io'
	projectsDirectory: '/opt/resin'

	$ cat $PWD/.resinrc.yml
	projectsDirectory: '/Users/resin/Projects'
	dataDirectory: '/opt/resin-data'

	$ echo $RESINRC_DATA_DIRECTORY
	/opt/cache/resin
```

That specific environment will have the following configuration:

```yaml
	resinUrl: 'resinstaging.io'
	projectsDirectory: '/Users/resin/Projects'
	dataDirectory: '/opt/cache/resin'
```


* [settings](#module_settings)
  * [.get(name)](#module_settings.get) ⇒ <code>\*</code>
  * [.getAll()](#module_settings.getAll) ⇒ <code>Object</code>

<a name="module_settings.get"></a>
### settings.get(name) ⇒ <code>\*</code>
**Kind**: static method of <code>[settings](#module_settings)</code>  
**Summary**: Get a setting  
**Returns**: <code>\*</code> - setting value  
**Access:** public  

| Param | Type | Description |
| --- | --- | --- |
| name | <code>String</code> | setting name |

**Example**  
```js
settings.get('dataDirectory')
```
<a name="module_settings.getAll"></a>
### settings.getAll() ⇒ <code>Object</code>
**Kind**: static method of <code>[settings](#module_settings)</code>  
**Summary**: Get all settings  
**Returns**: <code>Object</code> - all settings  
**Access:** public  
**Example**  
```js
settings.getAll()
```

Modifying settings
------------------

This module is intended to only provide *read only* access to the settings. Resin Settings Clients reads settings from various locations, like a local `resinrc` file and a per user `config` file, therefore the module doesn't know where to write changes back.

If you want to persist data related to Resin.io, consider using [Resin Settings Storage](https://github.com/resin-io/resin-settings-storage) instead.

Support
-------

If you're having any problem, please [raise an issue](https://github.com/resin-io/resin-settings-client/issues/new) on GitHub and the Resin.io team will be happy to help.

Tests
-----

Run the test suite by doing:

```sh
$ gulp test
```

Contribute
----------

- Issue Tracker: [github.com/resin-io/resin-settings-client/issues](https://github.com/resin-io/resin-settings-client/issues)
- Source Code: [github.com/resin-io/resin-settings-client](https://github.com/resin-io/resin-settings-client)

Before submitting a PR, please make sure that you include tests, and that [coffeelint](http://www.coffeelint.org/) runs without any warning:

```sh
$ gulp lint
```

License
-------

The project is licensed under the Apache 2.0 license.
