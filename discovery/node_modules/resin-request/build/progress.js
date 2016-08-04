
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
var _, getProgressStream, progress, request, rindle, stream, utils, zlib;

_ = require('lodash');

zlib = require('zlib');

request = require('request');

stream = require('stream');

progress = require('progress-stream');

rindle = require('rindle');

utils = require('./utils');


/**
 * @summary Get progress stream
 * @function
 * @private
 *
 * @param {Object} response - request response object
 * @param {Number} total - response total
 * @param {Function} [onState] - on state callback (state)
 * @returns {Stream} progress stream
 *
 * @example
 * progressStream = getProgressStream response, (state) ->
 * 	console.log(state)
 *
 * return requestStream.pipe(progressStream).pipe(output)
 */

getProgressStream = function(response, total, onState) {
  var progressStream;
  if (onState == null) {
    onState = _.noop;
  }
  progressStream = progress({
    time: 500,
    length: total
  });
  progressStream.on('progress', function(state) {
    if (state.length === 0) {
      return onState(void 0);
    }
    return onState({
      total: state.length,
      received: state.transferred,
      eta: state.eta,
      percentage: state.percentage
    });
  });
  return progressStream;
};


/**
 * @summary Make a node request with progress
 * @function
 * @protected
 *
 * @param {Object} options - request options
 * @returns {Promise<Stream>} request stream
 *
 * @example
 * progress.estimate(options).then (stream) ->
 *		stream.pipe(fs.createWriteStream('foo/bar'))
 *		stream.on 'progress', (state) ->
 *			console.log(state)
 */

exports.estimate = function(options) {
  var passStream, requestStream;
  options.gzip = false;
  options.headers['Accept-Encoding'] = 'gzip, deflate';
  requestStream = request(options);
  passStream = new stream.PassThrough();
  requestStream.pipe(passStream);
  return rindle.onEvent(requestStream, 'response').then(function(response) {
    var gunzip, output, progressStream, responseLength, total;
    responseLength = utils.getResponseLength(response);
    output = new stream.PassThrough();
    output.response = response;
    total = responseLength.uncompressed || responseLength.compressed;
    progressStream = getProgressStream(response, total, function(state) {
      return output.emit('progress', state);
    });
    if (utils.isResponseCompressed(response)) {
      gunzip = new zlib.createGunzip();
      if ((responseLength.compressed != null) && (responseLength.uncompressed == null)) {
        passStream.pipe(progressStream).pipe(gunzip).pipe(output);
      } else {
        passStream.pipe(gunzip).pipe(progressStream).pipe(output);
      }
    } else {
      passStream.pipe(progressStream).pipe(output);
    }
    return output;
  });
};
