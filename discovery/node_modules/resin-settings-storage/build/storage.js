
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
 * @module storage
 */
var Promise, localStorage, _;

Promise = require('bluebird');

_ = require('lodash');

localStorage = require('./local-storage');


/**
 * @summary Set a value
 * @function
 * @public
 *
 * @param {String} name - name
 * @param {*} value - value
 *
 * @return {Promise}
 *
 * @example
 * storage.set('token', '1234')
 */

exports.set = function(name, value) {
  return Promise["try"](function() {
    if (!_.isString(value)) {
      value = JSON.stringify(value);
    }
    return localStorage.setItem(name, value);
  });
};


/**
 * @summary Get a value
 * @function
 * @public
 *
 * @param {String} name - name
 *
 * @return {Promise<*>} value or undefined
 *
 * @example
 * storage.get('token').then (token) ->
 * 	console.log(token)
 */

exports.get = function(name) {
  return Promise["try"](function() {
    var result;
    localStorage._init();
    result = localStorage.getItem(name) || void 0;
    if (/^-?\d+\.?\d*$/.test(result)) {
      result = parseFloat(result);
    }
    try {
      result = JSON.parse(result);
    } catch (_error) {}
    return result;
  }).catchReturn(void 0);
};


/**
 * @summary Check if a value exists
 * @function
 * @public
 *
 * @param {String} name - name
 *
 * @return {Promise<Boolean>} has value
 *
 * @example
 * storage.has('token').then (hasToken) ->
 * 	if hasToken
 * 		console.log('Yes')
 * 	else
 * 		console.log('No')
 */

exports.has = function(name) {
  return exports.get(name).then(function(value) {
    return value != null;
  });
};


/**
 * @summary Remove a value
 * @function
 * @public
 *
 * @param {String} name - name
 *
 * @return {Promise}
 *
 * @example
 * storage.remove('token')
 */

exports.remove = function(name) {
  return Promise["try"](function() {
    return localStorage.removeItem(name);
  });
};
