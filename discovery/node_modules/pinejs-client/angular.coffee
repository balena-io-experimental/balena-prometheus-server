((root, factory) ->
	if typeof define is 'function' and define.amd
		# AMD. Register as an anonymous module.
		define ['angular', './core'], factory
	else if typeof exports is 'object'
		# Node. Does not work with strict CommonJS, but
		# only CommonJS-like enviroments that support module.exports,
		# like Node.
		factory(require('angular'), require('./core'))
	else
		# Browser globals
		factory(root.angular, root.PinejsClientCore)
) this, (angular, PinejsClientCore) ->
	# Use our own isBoolean as angular is missing it, but copy the other methods across.
	utils =
		isBoolean: (v) ->
			v in [true, false] or (angular.isObject(v) and Object::toString.call(v) is '[object Boolean]')
	for method in ['isString', 'isNumber', 'isObject', 'isArray', 'isDate']
		utils[method] = angular[method]

	angular
	.module('resin.pinejs', [])
	.service 'pinejs-client', ['$http', '$q', ($http, Promise) ->
		class PinejsClientAngular extends PinejsClientCore(utils, Promise)
			_request: (params) ->
				# Angular expects 'data'.
				params.data = params.body
				delete params.body

				 # Returns an httpPromise so we need to cast to a $q promise, see $http docs.
				return Promise.when($http(params)).then(
					({ data }) -> return data
					({ data }) -> return Promise.reject(new Error(data))
				)
		return PinejsClientAngular
	]
