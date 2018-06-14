"use strict";
/*
Copyright 2016-17 Resin.io

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
var prefixed = function (key) { return "resin-" + key; };
var createVirtualStore = function () {
    var _store = {};
    return {
        getItem: function (key) {
            if (_store.hasOwnProperty(key)) {
                return _store[key];
            }
            else {
                return null;
            }
        },
        setItem: function (key, value) {
            _store[key] = value;
        },
        removeItem: function (key) {
            delete _store[key];
        },
        clear: function () {
            _store = {};
        }
    };
};
// Inspired by https://github.com/gsklee/ngStorage
var isStorageSupported = function ($window, storageType) {
    // Some installations of IE, for an unknown reason, throw "SCRIPT5: Error: Access is denied"
    // when accessing window.localStorage. This happens before you try to do anything with it. Catch
    // that error and allow execution to continue.
    // fix 'SecurityError: DOM Exception 18' exception in Desktop Safari, Mobile Safari
    // when "Block cookies": "Always block" is turned on
    var storage;
    try {
        storage = $window[storageType];
    }
    catch (err) {
        return false;
    }
    var supported;
    // When Safari (OS X or iOS) is in private browsing mode, it appears as though localStorage and sessionStorage
    // is available, but trying to call .setItem throws an exception below:
    // "QUOTA_EXCEEDED_ERR: DOM Exception 22: An attempt was made to add something to storage that exceeded the quota."
    var key = "__" + Math.round(Math.random() * 1e7);
    try {
        storage.setItem(key, key);
        supported = storage.getItem(key) === key;
        storage.removeItem(key);
    }
    catch (err) {
        return false;
    }
    return supported;
};
var createStorage;
if (typeof window !== 'undefined') {
    if (isStorageSupported(window, 'localStorage')) {
        createStorage = function () { return ({
            getItem: function (key) {
                return localStorage.getItem(prefixed(key));
            },
            setItem: function (key, value) {
                return localStorage.setItem(prefixed(key), value);
            },
            removeItem: function (key) {
                return localStorage.removeItem(prefixed(key));
            },
            clear: function () {
                return localStorage.clear();
            }
        }); };
    }
    else {
        createStorage = createVirtualStore;
    }
}
else {
    // Fallback to filesystem based storage if not in the browser.
    // tslint:disable-next-line no-var-requires
    var LocalStorage_1 = require('node-localstorage').LocalStorage;
    createStorage = function (dataDirectory) {
        // Set infinite quota
        return new LocalStorage_1(dataDirectory, Infinity);
    };
}
module.exports = createStorage;
//# sourceMappingURL=local-storage.js.map