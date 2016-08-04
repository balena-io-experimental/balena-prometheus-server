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

Promise = require('bluebird')
_ = require('lodash')
token = require('resin-token')

# Expose for testing purposes
exports.TOKEN_REFRESH_INTERVAL = 1 * 1000 * 60 * 60 # 1 hour in milliseconds

###*
# @summary Determine if the token should be updated
# @function
# @protected
#
# @description
# This function makes use of a soft user-configurable setting called `tokenRefreshInterval`.
# That setting doesn't express that the token is "invalid", but represents that it is a good time for the token to be updated *before* it get's outdated.
#
# @returns {Promise<Boolean>} the token should be updated
#
# @example
# tokenUtils.shouldUpdateToken().then (shouldUpdateToken) ->
#		if shouldUpdateToken
#			console.log('Updating token!')
###
exports.shouldUpdateToken = ->
	token.getAge().then (age) ->
		return age >= exports.TOKEN_REFRESH_INTERVAL

###*
# @summary Get authorization header content
# @function
# @protected
#
# @description
# This promise becomes undefined if no saved token.
#
# @returns {Promise<String>} authorization header
#
# @example
# utils.getAuthorizationHeader().then (authorizationHeader) ->
#		headers =
#			Authorization: authorizationHeader
###
exports.getAuthorizationHeader = ->
	token.get().then (sessionToken) ->
		return if not sessionToken?
		return "Bearer #{sessionToken}"

###*
# @summary Get error message from response
# @function
# @protected
#
# @param {Object} response - node request response
# @returns {String} error message
#
# @example
# request
#		method: 'GET'
#		url: 'https://foo.bar'
#	, (error, response) ->
#		throw error if error?
#		message = utils.getErrorMessageFromResponse(response)
###
exports.getErrorMessageFromResponse = (response) ->
	if not response.body?
		return 'The request was unsuccessful'
	if response.body.error?
		return response.body.error.text
	return response.body

###*
# @summary Check if the status code represents an error
# @function
# @protected
#
# @param {Number} statusCode - status code
# @returns {Boolean} represents an error
#
# @example
# if utils.isErrorCode(400)
#		console.log('400 is an error code!')
###
exports.isErrorCode = (statusCode) ->
	return statusCode >= 400

###*
# @summary Check whether a response body is compressed
# @function
# @protected
#
# @param {Object} response - request response object
# @returns {Boolean} whether the response body is compressed
#
# @example
# if utils.isResponseCompressed(response)
# 	console.log('The response body is compressed')
###
exports.isResponseCompressed = (response) ->
	return response.headers['content-encoding'] is 'gzip'

###*
# @summary Get response compressed/uncompressed length
# @function
# @protected
#
# @param {Object} response - request response object
# @returns {Object} response length
#
# @example
# responseLength = utils.getResponseLength(response)
# console.log(responseLength.compressed)
# console.log(responseLength.uncompressed)
###
exports.getResponseLength = (response) ->
	return {
		uncompressed: _.parseInt(response.headers['content-length']) or undefined

		# X-Transfer-Length equals the compressed size of the body.
		# This header is sent by Image Maker when downloading OS images.
		compressed: _.parseInt(response.headers['x-transfer-length']) or undefined
	}

###*
# @summary Print debug information about a request/response
# @function
# @protected
#
# @param {Object} options - request options
# @param {Object} response - request response
#
# @example
# options = {
# 	method: 'GET'
#   url: '/foo'
# }
#
# request(options).spread (response) ->
# 	utils.debugRequest(options, response)
###
exports.debugRequest = (options, response) ->
	return if not process.env.DEBUG
	options.statusCode = response.statusCode
	console.error(options)
