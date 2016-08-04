
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
var _;

_ = require('lodash');


/**
 * @summary Get setting name from environment variable
 * @function
 * @protected
 *
 * @param {String} variable - environment variable
 * @returns {String} setting name
 *
 * @throws Will throw if variable is missing.
 *
 * @example
 * console.log(environment.getSettingName('RESINRC_HELLO_WORLD'))
 * > helloWorld
 */

exports.getSettingName = function(variable) {
  if (_.isEmpty(variable != null ? variable.trim() : void 0)) {
    throw new Error('Missing variable name');
  }
  return _.camelCase(variable.replace(/^RESINRC_/i, ''));
};


/**
 * @summary Determine if a variable is a configuration variable
 * @function
 * @protected
 *
 * @param {String} variable - environment variable
 * @returns {Boolean} is a configuration variable
 *
 * @example
 * console.log(environment.isSettingVariable('RESINRC_HELLO_WORLD'))
 * > true
 *
 * @example
 * console.log(environment.isSettingVariable('EDITOR'))
 * > false
 */

exports.isSettingVariable = function(variable) {
  return /^RESINRC_(.)+/i.test(variable);
};


/**
 * @summary Parse environment variables
 * @function
 * @protected
 *
 * @param {Object} environment - environment
 * @returns {Object} parsed environment variables
 *
 * @example
 * console.log(utils.parse({
 *		RESINRC_RESIN_URL: 'https://resin.io'
 *		EDITOR: 'vim'
 * }))
 * > {
 * > 	resinUrl: 'https://resin.io'
 * > }
 */

exports.parse = function(environment) {
  return _.chain(environment).pick(_.rearg(exports.isSettingVariable, 1)).mapKeys(_.rearg(exports.getSettingName, 1)).value();
};
