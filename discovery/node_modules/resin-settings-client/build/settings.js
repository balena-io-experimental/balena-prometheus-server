
/*
Copyright 2016 Resin.io

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
 */

/**
 * This module attempts to retrieve configuration from the following places:
 *
 * **UNIX:**
 *
 * - Default settings.
 * - `$HOME/.resinrc.yml`.
 * - `$PWD/resinrc.yml`.
 * - Environment variables matching `RESINRC_<SETTING_NAME>`.
 *
 * **Windows:**
 *
 * - Default settings.
 * - `%UserProfile%\_resinrc.yml`.
 * - `%cd%\resinrc.yml`.
 * - Environment variables matching `RESINRC_<SETTING_NAME>`.
 *
 * The values from all locations are merged together, with sources listed below taking precedence.
 *
 * For example:
 *
 * ```sh
 *	$ cat $HOME/.resinrc.yml
 *	resinUrl: 'resinstaging.io'
 *	projectsDirectory: '/opt/resin'
 *
 *	$ cat $PWD/.resinrc.yml
 *	projectsDirectory: '/Users/resin/Projects'
 *	dataDirectory: '/opt/resin-data'
 *
 *	$ echo $RESINRC_DATA_DIRECTORY
 *	/opt/cache/resin
 * ```
 *
 * That specific environment will have the following configuration:
 *
 * ```yaml
 *	resinUrl: 'resinstaging.io'
 *	projectsDirectory: '/Users/resin/Projects'
 *	dataDirectory: '/opt/cache/resin'
 * ```
 *
 * @module settings
 */
var config, defaults, environment, fs, readConfigFile, settings, utils, yaml, _;

_ = require('lodash');

fs = require('fs');

defaults = require('./defaults');

environment = require('./environment');

yaml = require('./yaml');

utils = require('./utils');

config = require('./config');

readConfigFile = function(file) {
  var error;
  try {
    return yaml.parse(fs.readFileSync(file, {
      encoding: 'utf8'
    }));
  } catch (_error) {
    error = _error;
    if (error.code === 'ENOENT') {
      return {};
    }
    throw error;
  }
};

settings = utils.mergeObjects.apply(null, [defaults, readConfigFile(config.paths.user), readConfigFile(config.paths.project), environment.parse(process.env)]);


/**
 * @summary Get a setting
 * @function
 * @public
 *
 * @param {String} name - setting name
 * @return {*} setting value
 *
 * @example
 * settings.get('dataDirectory')
 */

exports.get = function(name) {
  return utils.evaluateSetting(settings, name);
};


/**
 * @summary Get all settings
 * @function
 * @public
 *
 * @return {Object} all settings
 *
 * @example
 * settings.getAll()
 */

exports.getAll = function() {
  return _.mapValues(settings, function(setting, name) {
    return exports.get(name);
  });
};
