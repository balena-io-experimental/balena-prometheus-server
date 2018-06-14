"use strict";
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
var Promise = require("bluebird");
var getLocalStorage = require("./local-storage");
/**
 * @summary Get an instance of storage module
 * @function
 * @static
 * @public
 *
 * @param {Object?} options - options
 * @param {string?} options.dataDirectory - the directory to use for storage in Node.js. Ignored in the browser.
 *
 * @return {storage}
 * @example
 * const storage = require('resin-settings-storage')({
 * 	dataDirectory: '/opt/cache/resin'
 * })
 */
var getStorage = function (_a) {
    var dataDirectory = (_a === void 0 ? {} : _a).dataDirectory;
    var localStorage = getLocalStorage(dataDirectory);
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
    var set = function (name, value) {
        return Promise.try(function () {
            if (typeof value !== 'string') {
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
     * storage.get('token').then((token) => {
     * 	console.log(token)
     * });
     */
    var get = function (name) {
        return Promise.try(function () {
            // Run `node-localstorage` constructor to update
            // internal cache of saved files.
            // Without this, external changes to the data
            // directory (with `fs` for example) will not
            // be detected by `node-localstorage`.
            if (typeof localStorage._init === 'function') {
                localStorage._init();
            }
            var result = localStorage.getItem(name);
            if (result == null) {
                return undefined;
            }
            if (/^-?\d+\.?\d*$/.test(result)) {
                return parseFloat(result);
            }
            try {
                return JSON.parse(result);
            }
            catch (error) {
                // do nothing
            }
            return result;
        }).catchReturn(undefined);
    };
    /**
     * @summary Check if the value exists
     * @function
     * @public
     *
     * @param {String} name - name
     *
     * @return {Promise<Boolean>} has value
     *
     * @example
     * storage.has('token').then((hasToken) => {
     * 	if (hasToken) {
     * 		console.log('Yes')
     * 	} else {
     * 		console.log('No')
     * });
     */
    var has = function (name) { return get(name).then(function (value) { return value != null; }); };
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
    var remove = function (name) {
        return Promise.try(function () { return localStorage.removeItem(name); });
    };
    /**
     * @summary Remove all values
     * @function
     * @public
     *
     *
     * @return {Promise}
     *
     * @example
     * storage.clear()
     */
    var clear = function () { return Promise.try(function () { return localStorage.clear(); }); };
    return { set: set, get: get, has: has, remove: remove, clear: clear };
};
module.exports = getStorage;
//# sourceMappingURL=storage.js.map