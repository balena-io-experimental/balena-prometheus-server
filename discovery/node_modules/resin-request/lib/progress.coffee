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

noop = require('lodash/noop')
utils = require('./utils')

###*
# @module progress
###

###*
# @summary Get progress stream
# @function
# @private
#
# @param {Number} total - response total
# @param {Function} [onState] - on state callback (state)
# @returns {Stream} progress stream
#
# @example
# progressStream = getProgressStream response, (state) ->
# 	console.log(state)
#
# return responseStream.pipe(progressStream).pipe(output)
###
getProgressStream = (total, onState = noop) ->
	progress = require('progress-stream')

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
# @description **Not implemented for the browser.**
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
exports.estimate = (requestAsync) -> (options) ->
	requestAsync ?= utils.getRequestAsync()

	zlib = require('zlib')
	stream = require('stream')

	options.gzip = false
	options.headers['Accept-Encoding'] = 'gzip, deflate'

	return requestAsync(options)
	.then (response) ->
		output = new stream.PassThrough()
		output.response = response

		responseLength = utils.getResponseLength(response)
		total = responseLength.uncompressed or responseLength.compressed

		responseStream = response.body

		progressStream = getProgressStream total, (state) ->
			output.emit('progress', state)

		if utils.isResponseCompressed(response)
			gunzip = new zlib.createGunzip()

			# Uncompress after or before piping trough progress
			# depending on the response length available to us
			if responseLength.compressed? and not responseLength.uncompressed?
				responseStream.pipe(progressStream).pipe(gunzip).pipe(output)
			else
				responseStream.pipe(gunzip).pipe(progressStream).pipe(output)

		else
			responseStream.pipe(progressStream).pipe(output)

		return output
