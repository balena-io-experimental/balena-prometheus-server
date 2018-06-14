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

###*
# @module request
###

Promise = require('bluebird')
urlLib = require('url')
assign = require('lodash/assign')
noop = require('lodash/noop')
defaults = require('lodash/defaults')
isEmpty = require('lodash/isEmpty')

errors = require('resin-errors')
utils = require('./utils')
progress = require('./progress')

{ onlyIf } = utils

module.exports = getRequest = ({
	auth,
	debug = false,
	retries = 0,
	isBrowser = false,
	interceptors = []
} = {}) ->
	requestAsync = utils.getRequestAsync()

	debugRequest = if not debug then noop else utils.debugRequest

	exports = {}

	prepareOptions = (options = {}) ->

		defaults options,
			method: 'GET'
			json: true
			strictSSL: true
			headers: {}
			sendToken: true
			refreshToken: true
			retries: retries

		{ baseUrl } = options

		if options.uri
			options.url = options.uri
			delete options.uri
		if urlLib.parse(options.url).protocol?
			delete options.baseUrl

		Promise.try ->
			# Only refresh if we have resin-auth, we're going to use it to send a
			# token, and we haven't opted out of refresh
			return if not (auth? and options.sendToken and options.refreshToken)

			utils.shouldRefreshKey(auth).then (shouldRefreshKey) ->
				return if not shouldRefreshKey

				exports.send
					url: '/whoami'
					baseUrl: baseUrl
					refreshToken: false

				# At this point we're sure there is a saved token,
				# however the fact that /whoami returns 401 allows
				# us to safely assume the token is expired
				.catch
					code: 'ResinRequestError'
					statusCode: 401
				, ->
					return auth.getKey().tap(auth.removeKey).then (key) ->
						throw new errors.ResinExpiredToken(key)

				.get('body')
				.then(auth.setKey)

		.then ->
			if options.sendToken
				utils.getAuthorizationHeader(auth)
		.then (authorizationHeader) ->
			if authorizationHeader?
				options.headers.Authorization = authorizationHeader

			if not isEmpty(options.apiKey)
				# Using `request` qs object results in dollar signs, or other
				# special characters used to query our OData API, being escaped
				# and thus leading to all sort of weird error.
				# The workaround is to append the `apikey` query string manually
				# to prevent affecting the rest of the query strings.
				# See https://github.com/request/request/issues/2129
				options.url += if urlLib.parse(options.url).query? then '&' else '?'
				options.url += "apikey=#{options.apiKey}"

			return options

	interceptRequestOptions = (requestOptions) ->
		interceptRequestOrError(Promise.resolve(requestOptions))

	interceptRequestError = (requestError) ->
		interceptRequestOrError(Promise.reject(requestError))

	interceptResponse = (response) ->
		interceptResponseOrError(Promise.resolve(response))

	interceptResponseError = (responseError) ->
		interceptResponseOrError(Promise.reject(responseError))

	interceptRequestOrError = (initialPromise) ->
		Promise.resolve(
			exports.interceptors.reduce (promise, { request, requestError }) ->
				if request? or requestError?
					promise.then(request, requestError)
				else
					promise
			, initialPromise
		)

	interceptResponseOrError = (initialPromise) ->
		interceptors = exports.interceptors.slice().reverse()
		Promise.resolve(
			interceptors.reduce (promise, { response, responseError }) ->
				if response? or responseError?
					promise.then(response, responseError)
				else
					promise
			, initialPromise
		)

	###*
	# @summary Perform an HTTP request to Resin.io
	# @function
	# @public
	#
	# @description
	# This function automatically handles authorization with Resin.io.
	#
	# The module scans your environment for a saved session token. Alternatively, you may pass the `apiKey` option. Otherwise, the request is made anonymously.
	#
	# @param {Object} options - options
	# @param {String} [options.method='GET'] - method
	# @param {String} options.url - relative url
	# @param {String} [options.apiKey] - api key
	# @param {String} [options.responseFormat] - explicit expected response format,
	# can be one of 'blob', 'json', 'text', 'none'. Defaults to sniffing the content-type
	# @param {*} [options.body] - body
	#
	# @returns {Promise<Object>} response
	#
	# @example
	# request.send
	# 	method: 'GET'
	# 	baseUrl: 'https://api.resin.io'
	# 	url: '/foo'
	# .get('body')
	#
	# @example
	# request.send
	# 	method: 'POST'
	# 	baseUrl: 'https://api.resin.io'
	# 	url: '/bar'
	# 	data:
	# 		hello: 'world'
	# .get('body')
	###
	exports.send = (options = {}) ->
		# Only set the default timeout when doing a normal HTTP
		# request and not also when streaming since in the latter
		# case we might cause unnecessary ESOCKETTIMEDOUT errors.
		options.timeout ?= 30000

		prepareOptions(options)
		.then(interceptRequestOptions, interceptRequestError)
		.then (options) ->
			requestAsync(options)
			.catch (error) ->
				error.requestOptions = options
				throw error
		.then (response) ->
			utils.getBody(response, options.responseFormat)
			.then (body) ->
				response = assign({}, response, { body })

				if utils.isErrorCode(response.statusCode)
					responseError = utils.getErrorMessageFromResponse(response)
					debugRequest(options, response)
					throw new errors.ResinRequestError(responseError, response.statusCode, options)

				return response
		.then(interceptResponse, interceptResponseError)

	###*
	# @summary Stream an HTTP response from Resin.io.
	# @function
	# @public
	#
	# @description
	# **Not implemented for the browser.**
	# This function emits a `progress` event, passing an object with the following properties:
	#
	# - `Number percent`: from 0 to 100.
	# - `Number total`: total bytes to be transmitted.
	# - `Number received`: number of bytes transmitted.
	# - `Number eta`: estimated remaining time, in seconds.
	#
	# The stream may also contain the following custom properties:
	#
	# - `String .mime`: Equals the value of the `Content-Type` HTTP header.
	#
	# See `request.send()` for an explanation on how this function handles authentication.
	#
	# @param {Object} options - options
	# @param {String} [options.method='GET'] - method
	# @param {String} options.url - relative url
	# @param {*} [options.body] - body
	#
	# @returns {Promise<Stream>} response
	#
	# @example
	# request.stream
	# 	method: 'GET'
	# 	baseUrl: 'https://img.resin.io'
	# 	url: '/download/foo'
	# .then (stream) ->
	# 	stream.on 'progress', (state) ->
	# 		console.log(state)
	#
	# 	stream.pipe(fs.createWriteStream('/opt/download'))
	###
	exports.stream = onlyIf(not isBrowser) (options = {}) ->
		rindle = require('rindle')

		prepareOptions(options)
		.then(interceptRequestOptions, interceptRequestError)
		.then(progress.estimate(requestAsync))
		.then (download) ->
			if not utils.isErrorCode(download.response.statusCode)
				# TODO: Move this to resin-image-manager
				download.mime = download.response.headers.get('Content-Type')

				return download

			# If status code is an error code, interpret
			# the body of the request as an error.
			rindle.extract(download)
			.then (data) ->
				responseError = data or 'The request was unsuccessful'
				debugRequest(options, download.response)
				throw new errors.ResinRequestError(responseError, download.response.statusCode)
		.then(interceptResponse, interceptResponseError)

	###*
	# @summary Array of interceptors
	# @type {Interceptor[]}
	# @public
	#
	# @description
	# The current array of interceptors to use. Interceptors intercept requests made
	# by calls to `.stream()` and `.send()` (some of which are made internally) and
	# are executed in the order they appear in this array for requests, and in the
	# reverse order for responses.
	#
	# @example
	# request.interceptors.push(
	# 	requestError: (error) ->
	#		console.log(error)
	#		throw error
	# )
	###
	exports.interceptors = interceptors

	###*
	# @typedef Interceptor
	# @type {object}
	#
	# @description
	# An interceptor implements some set of the four interception hook callbacks.
	# To continue processing, each function should return a value or a promise that
	# successfully resolves to a value.
	#
	# To halt processing, each function should throw an error or return a promise that
	# rejects with an error.
	#
	# @property {function} [request] - Callback invoked before requests are made. Called with
	# the request options, should return (or resolve to) new request options, or throw/reject.
	#
	# @property {function} [response] - Callback invoked before responses are returned. Called with
	# the response, should return (or resolve to) a new response, or throw/reject.
	#
	# @property {function} [requestError] - Callback invoked if an error happens before a request.
	# Called with the error itself, caused by a preceeding request interceptor rejecting/throwing
	# an error for the request, or a failing in preflight token validation. Should return (or resolve
	# to) new request options, or throw/reject.
	#
	# @property {function} [responseError] - Callback invoked if an error happens in the response.
	# Called with the error itself, caused by a preceeding response interceptor rejecting/throwing
	# an error for the request, a network error, or an error response from the server. Should return
	# (or resolve to) a new response, or throw/reject.
	###

	exports._setFetch = (fetch) ->
		requestAsync = utils.getRequestAsync(fetch)

	return exports
