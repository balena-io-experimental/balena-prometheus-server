
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
 * @module logs
 */
var EventEmitter, Promise, pubnub, utils, _;

_ = require('lodash');

Promise = require('bluebird');

EventEmitter = require('events').EventEmitter;

pubnub = require('./pubnub');

utils = require('./utils');


/**
 * @summary Subscribe to device logs
 * @function
 * @public
 *
 * @description This function emits various events:
 *
 * - `line`: When a log line arrives, passing an object as an argument.
 * - `error`: When an error occurs, passing an error instance as an argument.
 *
 * The object returned by this function also contains the following functions:
 *
 * - `.unsubscribe()`: Unsubscribe from the device channel.
 *
 * @param {Object} pubnubKeys - PubNub keys
 * @param {String} pubnubKeys.subscribe_key - subscribe key
 * @param {String} pubnubKeys.publish_key - publish key
 * @param {Object} device - device
 *
 * @returns {EventEmitter} logs
 *
 * @example
 * deviceLogs = logs.subscribe
 * 	subscribe_key: '...'
 * 	publish_key: '...'
 * ,
 * 	uuid: '...'
 *
 * deviceLogs.on 'line', (line) ->
 * 	console.log(line.message)
 * 	console.log(line.isSystem)
 * 	console.log(line.timestamp)
 *
 * deviceLogs.on 'error', (error) ->
 * 	throw error
 */

exports.subscribe = function(pubnubKeys, device) {
  var channel, emitter, instance;
  channel = utils.getChannel(device);
  instance = pubnub.getInstance(pubnubKeys);
  emitter = new EventEmitter();
  instance.subscribe({
    channel: channel,
    restore: true,
    message: function(payload) {
      return _.each(utils.extractMessages(payload), function(data) {
        return emitter.emit('line', data);
      });
    },
    error: function(error) {
      return emitter.emit('error', error);
    }
  });
  emitter.unsubscribe = function() {
    return instance.unsubscribe({
      channel: channel
    });
  };
  return emitter;
};


/**
 * @summary Get device logs history
 * @function
 * @public
 *
 * @param {Object} pubnubKeys - PubNub keys
 * @param {String} pubnubKeys.subscribe_key - subscribe key
 * @param {String} pubnubKeys.publish_key - publish key
 * @param {Object} device - device
 *
 * @returns {Promise<Object[]>} device logs history
 *
 * @example
 * logs.history
 * 	subscribe_key: '...'
 * 	publish_key: '...'
 * ,
 * 	uuid: '...'
 * .then (lines) ->
 * 	for line in lines
 * 		console.log(line.message)
 * 		console.log(line.isSystem)
 * 		console.log(line.timestamp)
 */

exports.history = function(pubnubKeys, device) {
  return Promise["try"](function() {
    var channel, instance;
    instance = pubnub.getInstance(pubnubKeys);
    channel = utils.getChannel(device);
    return pubnub.history(instance, channel);
  }).map(utils.extractMessages).then(_.flatten);
};
