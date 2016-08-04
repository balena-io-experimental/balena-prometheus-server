
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
var url, _;

_ = require('lodash');

url = require('url');


/**
 * @summary Merge objects into one
 * @function
 * @protected
 *
 * @description
 * The last passed objects have precedence over the first ones.
 *
 * @param {...Object} objects - input objects
 * @returns {Object} merged object
 *
 * @example
 * first = foo: 'bar'
 * second = foo: 'baz'
 * third = foo: 'qux'
 *
 * console.log(utils.mergeObjects(first, second, third))
 * > { foo: 'qux' }
 */

exports.mergeObjects = _.merge;


/**
 * @summary Evaluate a setting property
 * @function
 * @protected
 *
 * @param {Object} [settings={}] - settings
 * @param {String} property - period separated property
 * @returns {*} setting value
 *
 * @throws Will throw if setting is not found.
 *
 * @example
 * console.log(utils.evaluateSetting({ foo: 'bar' }, 'foo'))
 * > 'bar'
 *
 * @example
 * console.log(utils.evaluateSetting({
 * 	foo:
 * 		bar: 'baz'
 * }, 'foo.bar'))
 * > 'baz'
 *
 * @example
 * console.log(utils.evaluateSetting({
 * 	greeting: 'Hola'
 * 	message: ->
 * 		return "#{@greeting} World"
 * }), 'message')
 * > Hola World
 */

exports.evaluateSetting = function(settings, property) {
  var value;
  if (settings == null) {
    settings = {};
  }
  value = _.get(settings, property);
  if (value == null) {
    throw new Error("Setting not found: " + property);
  }
  if (_.isFunction(value)) {
    value = value.call(settings);
  }
  return value;
};
