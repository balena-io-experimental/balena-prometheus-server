###
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
###

_ = require('lodash')
zlib = require('zlib')
request = require('request')
stream = require('stream')
progress = require('progress-stream')
rindle = require('rindle')
utils = require('./utils')

###*
# @summary Get progress stream
# @function
# @private
#
# @param {Object} response - request response object
# @param {Number} total - response total
# @param {Function} [onState] - on state callback (state)
# @returns {Stream} progress stream
#
# @example
# progressStream = getProgressStream response, (state) ->
# 	console.log(state)
#
# return requestStream.pipe(progressStream).pipe(output)
###
getProgressStream = (response, total, onState = _.noop) ->
	progressStream = progress
		time: 500
		length: total

	progressStream.on 'progress', (state) ->
		if state.length is 0
			return onState(undefined)

		return onState
			total: state.length
			received: state.transferred
			eta: state.eta
			percentage: state.percentage

	return progressStream

###*
# @summary Make a node request with progress
# @function
# @protected
#
# @param {Object} options - request options
# @returns {Promise<Stream>} request stream
#
# @example
# progress.estimate(options).then (stream) ->
#		stream.pipe(fs.createWriteStream('foo/bar'))
#		stream.on 'progress', (state) ->
#			console.log(state)
###
exports.estimate = (options) ->

	# Disable gzip support. We manually handle compression
	# given the need of finer control.
	options.gzip = false

	# Disabling gzip makes request omit an Accept-Encoding: gzip
	# completely. We disable automatic gzip decompression
	# but still want to receive the gzip encoded response to handle
	# it ourselves, therefore we pass the HTTP header manually.
	options.headers['Accept-Encoding'] = 'gzip, deflate'

	requestStream = request(options)

	# Instantly pipe the response to a PassThrough stream
	# to allow data to be piped after `response` was emitted.
	passStream = new stream.PassThrough()
	requestStream.pipe(passStream)

	return rindle.onEvent(requestStream, 'response').then (response) ->
		responseLength = utils.getResponseLength(response)

		output = new stream.PassThrough()
		output.response = response

		total = responseLength.uncompressed or responseLength.compressed
		progressStream = getProgressStream response, total, (state) ->
			output.emit('progress', state)

		if utils.isResponseCompressed(response)
			gunzip = new zlib.createGunzip()

			# Uncompress after of before piping trough process
			# depending on the response length available to us
			if responseLength.compressed? and not responseLength.uncompressed?
				passStream.pipe(progressStream).pipe(gunzip).pipe(output)
			else
				passStream.pipe(gunzip).pipe(progressStream).pipe(output)

		else
			passStream.pipe(progressStream).pipe(output)

		return output

