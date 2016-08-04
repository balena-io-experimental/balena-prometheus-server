
/*
The MIT License

Copyright (c) 2015 Resin.io, Inc. https://resin.io.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
 */

/**
 * @module token
 */
var Promise, TOKEN_KEY, atob, errors, storage, url;

Promise = require('bluebird');

atob = require('atob');

url = require('url');

errors = require('resin-errors');

storage = require('resin-settings-storage');

TOKEN_KEY = 'token';


/**
 * @summary Check if a token is valid
 * @function
 * @public
 *
 * @param {String} token - token
 * @returns {Promise<Boolean>} is valid
 *
 * @example
 * token.isValid('...').then (isValid) ->
 * 	if isValid
 * 		console.log('The token is valid!')
 */

exports.isValid = function(token) {
  return exports.parse(token)["return"](true)["catch"](errors.ResinMalformedToken, function() {
    return false;
  });
};


/**
 * @summary Set the token
 * @function
 * @public
 *
 * @param {String} token - token
 * @returns {Promise<String>} token
 *
 * @example
 * token.set('...')
 */

exports.set = function(token) {
  return exports.isValid(token).then(function(isValid) {
    if (!isValid) {
      throw new Error('The token is invalid');
    }
    return storage.set(TOKEN_KEY, token.trim());
  });
};


/**
 * @summary Get the token
 * @function
 * @public
 *
 * @description
 * This function resolved to undefined if no token.
 *
 * @returns {Promise<String>} token
 *
 * @example
 * token.get().then (sessionToken) ->
 *		console.log(sessionToken)
 */

exports.get = function() {
  return storage.get(TOKEN_KEY);
};


/**
 * @summary Has a token
 * @function
 * @public
 *
 * @returns {Promise<Boolean>} has token
 *
 * @example
 * token.has().then (hasToken) ->
 *		if hasToken
 *			console.log('There is a token!')
 *		else
 *			console.log('There is not a token!')
 */

exports.has = function() {
  return storage.has(TOKEN_KEY);
};


/**
 * @summary Remove the token
 * @function
 * @public
 *
 * @description
 * This promise is not rejected if there was no token at the time of removal.
 *
 * @returns {Promise}
 *
 * @example
 * token.remove()
 */

exports.remove = function() {
  return storage.remove(TOKEN_KEY);
};


/**
 * @summary Parse a token
 * @function
 * @public
 *
 * @description
 * This function does't save the token. Use `token.set()` if you want to persist it afterwards.
 *
 * @param {String} token - token
 * @returns {Promise<Object>} parsed token
 *
 * @example
 * token.parse('...').then (parsedToken) ->
 *		console.log(parsedToken)
 */

exports.parse = function(token) {
  return Promise["try"](function() {
    var data, header, signature, _ref;
    try {
      token = token.trim();
      _ref = token.split('.'), header = _ref[0], data = _ref[1], signature = _ref[2];
      return JSON.parse(atob(data));
    } catch (_error) {
      throw new errors.ResinMalformedToken(token);
    }
  });
};


/**
 * @summary Get the saved token data
 * @function
 * @public
 *
 * @description
 * In this context, "data" refers to the information encoded in the token.
 *
 * @returns {Promise<Object>} token data
 *
 * @example
 * token.getData().then (data) ->
 *		console.log(data)
 */

exports.getData = function() {
  return exports.has().then(function(hasToken) {
    if (!hasToken) {
      return;
    }
    return exports.get().then(exports.parse);
  });
};


/**
 * @summary Get a property from a saved token
 * @function
 * @public
 *
 * @description
 * This function resolves to undefined for any property name if there is no token.
 * It also resolved to undefined if the property name is invalid.
 *
 * @param {String} property - property name
 * @returns {Promise<*>} property value
 *
 * @example
 * token.getProperty('username').then (username) ->
 *		console.log(username)
 */

exports.getProperty = function(property) {
  return exports.getData().then(function(data) {
    return data != null ? data[property] : void 0;
  });
};


/**
 * @summary Get the username of the saved token
 * @function
 * @public
 *
 * @description
 * This function resolves to undefined if there is no token
 *
 * @returns {Promise<String>} username
 *
 * @example
 * token.getUsername().then (username) ->
 *		console.log(username)
 */

exports.getUsername = function() {
  return exports.getProperty('username');
};


/**
 * @summary Get the user id of the saved token
 * @function
 * @public
 *
 * @description
 * This function resolves to undefined if there is no token
 *
 * @returns {Promise<Number>} user id
 *
 * @example
 * token.getUserId().then (userId) ->
 *		console.log(userId)
 */

exports.getUserId = function() {
  return exports.getProperty('id');
};


/**
 * @summary Get the email of the saved token
 * @function
 * @public
 *
 * @description
 * This function resolves to undefined if there is no token
 *
 * @returns {Promise<String>} email
 *
 * @example
 * token.getEmail().then (email) ->
 *		console.log(email)
 */

exports.getEmail = function() {
  return exports.getProperty('email');
};


/**
 * @summary Get the age of the saved token
 * @function
 * @public
 *
 * @description
 * This function resolves to undefined if there is no token
 *
 * @returns {Promise<Number>} age in milliseconds
 *
 * @example
 * token.getAge().then (age) ->
 *		console.log(age)
 */

exports.getAge = function() {
  return exports.getProperty('iat').then(function(iat) {
    if (iat == null) {
      return;
    }
    return Date.now() - (iat * 1000);
  });
};
