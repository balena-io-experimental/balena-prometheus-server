_ = require 'lodash'
request = require 'request'
Promise = require 'bluebird'
PinejsClientCore = require './core'
BluebirdLRU = require 'bluebird-lru-cache'
TypedError = require 'typed-error'

request = Promise.promisify(request, multiArgs: true)

class StatusError extends TypedError
	constructor: (@message, @statusCode) ->
		super(@message)

validParams = ['cache']
module.exports = class PinejsClientRequest extends PinejsClientCore(_, Promise)
	constructor: (params, backendParams) ->
		super(params)
		@backendParams = {}
		if _.isObject(backendParams)
			for validParam in validParams when backendParams[validParam]?
				@backendParams[validParam] = backendParams[validParam]
		if @backendParams.cache?
			@cache = BluebirdLRU(@backendParams.cache)

	_request: (params) ->
		# We default to gzip on for efficiency.
		params.gzip ?= true
		# We default to a 30s timeout, rather than hanging indefinitely.
		params.timeout ?= 30000
		# We default to enforcing valid ssl certificates, after all there's a reason we're using them!
		params.strictSSL ?= true
		# The request is always a json request.
		params.json = true

		if @cache? and params.method is 'GET'
			# If the cache is enabled and we are doing a GET then try to use a cached
			# version, and store whatever the (successful) result is.
			@cache.get(params.url).then (cached) ->
				params.headers ?= {}
				params.headers['If-None-Match'] = cached.etag
				request(params).spread (response, body) ->
					if response.statusCode is 304
						return cached
					if 200 <= response.statusCode < 300
						return {
							etag: response.headers.etag
							body
						}
					throw new StatusError(body, response.statusCode)
			.catch BluebirdLRU.NoSuchKeyError, ->
				request(params).spread (response, body) ->
					if 200 <= response.statusCode < 300
						return {
							etag: response.headers.etag
							body
						}
					throw new StatusError(body, response.statusCode)
			.then (cached) =>
				@cache.set(params.url, cached)
				return _.cloneDeep(cached.body)
		else
			request(params).spread (response, body) ->
				if 200 <= response.statusCode < 300
					return body
				throw new StatusError(body, response.statusCode)
