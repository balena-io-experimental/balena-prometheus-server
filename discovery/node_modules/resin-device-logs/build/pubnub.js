
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
var Promise, PubNub, _;

_ = require('lodash');

Promise = require('bluebird');

PubNub = require('pubnub');


/**
 * @summary Get a PubNub instance
 * @function
 * @protected
 *
 * @param {Object} options - PubNub options
 * @param {String} options.subscribe_key - subscribe key
 * @param {String} options.publish_key - publish key
 *
 * @returns {Object} PubNub instance
 */

exports.getInstance = function(options) {
  options.ssl = true;
  return PubNub.init(options);
};


/**
 * @summary Get logs history from an instance
 * @function
 * @protected
 *
 * @description
 * **BE CAREFUL!** This function reacts poorly to non valid channels.
 * It just returns an empty array as if it didn't have any history messages.
 *
 * @param {Object} instance - PubNub instance
 * @param {String} channel - channel
 *
 * @returns {Promise<String[]>} history messages
 */

exports.history = function(instance, channel) {
  return Promise.fromNode(function(callback) {
    return instance.history({
      channel: channel,
      callback: function(history) {
        return callback(null, _.first(history));
      },
      error: callback
    });
  });
};
