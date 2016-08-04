
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
var Promise, _;

Promise = require('bluebird');

_ = require('lodash');


/**
 * @summary Generate a device UUID
 * @function
 * @public
 *
 * @description
 * This function allows promise style if the callback is omitted.
 *
 * @param {Function} callback - callback (error, uuid)
 *
 * @example
 * deviceRegister.generateUUID (error, uuid) ->
 * 	throw error if error?
 *	# uuid is a generated UUID that can be used for registering
 * 	console.log(uuid)
 */

exports.generateUUID = function(callback) {
  return Promise["try"](function() {
    return _.map(_.range(62), function() {
      return Math.floor(Math.random() * 16).toString(16);
    }).join('');
  }).nodeify(callback);
};


/**
 * @summary Register a device with Resin.io
 * @function
 * @public
 *
 * @description
 * This function allows promise style if the callback is omitted.
 *
 * @param {Object} pineInstance - pine instance
 * @param {Object} options - options
 * @param {Number} options.userId - user id
 * @param {Number} options.applicationId - application id
 * @param {String} options.deviceType - device type
 * @param {String} options.apiKey - api key
 * @param {String} [options.uuid] - device uuid
 * @param {String} [options.apiPrefix] - api prefix
 * @param {Function} callback - callback (error, device)
 *
 * @example
 * pine = require('resin-pine')
 *
 * deviceRegister.register pine,
 *		userId: 199
 *		applicationId: 10350
 *		deviceType: 'raspberry-pi'
 *		apiKey: '...'
 *	, (error, device) ->
 *		throw error if error?
 *		console.log(device)
 */

exports.register = function(pineInstance, options, callback) {
  return Promise["try"](function() {
    return options.uuid || exports.generateUUID();
  }).then(function(uuid) {
    return pineInstance.post({
      apiPrefix: options.apiPrefix,
      resource: 'device',
      body: {
        user: options.userId,
        application: options.applicationId,
        uuid: uuid,
        device_type: options.deviceType,
        registered_at: Math.floor(Date.now() / 1000)
      },
      customOptions: {
        apikey: options.apiKey
      }
    });
  }).nodeify(callback);
};
