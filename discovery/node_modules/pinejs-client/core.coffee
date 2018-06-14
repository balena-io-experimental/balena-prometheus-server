((root, factory) ->
	if typeof define is 'function' and define.amd
		# AMD. Register as an anonymous module.
		define ->
			return (root.PinejsClientCore = factory())
	else if typeof exports is 'object'
		# Node. Does not work with strict CommonJS, but
		# only CommonJS-like enviroments that support module.exports,
		# like Node.
		module.exports = factory()
	else
		# Browser globals
		root.PinejsClientCore = factory()
) this, ->

	noop = ->
	deprecated = {}
	addDeprecated = (name, message) ->
		deprecated[name] = ->
			console.warn('pinejs-client deprecated:', message)
			deprecated[name] = noop
	addDeprecated(
		'expandObject'
		'`$expand: a: b: ...` is deprecated, please use `$expand: a: $expand: b: ...` instead.'
	)
	addDeprecated(
		'expandPrimitive'
		'`$expand: a: "b"` is deprecated, please use `$expand: a: $expand: "b"` instead.'
	)
	addDeprecated(
		'expandFilter'
		'`$filter: a: b: ...` is deprecated, please use `$filter: a: $any: { $alias: "x", $expr: x: b: ... }` instead.'
	)

	# Utils must support .isString, .isObject, and .isArray
	# Promise must support Promise.reject, returning a rejected promise
	return (utils, Promise) ->
		do ->
			# Check that the objects passed in have the required properties.
			requiredMethods = ['isString', 'isNumber', 'isBoolean', 'isObject', 'isArray', 'isDate']
			for method in requiredMethods when !utils[method]?
				throw new Error('The utils implementation must support ' + requiredMethods.join(', '))
			if !Promise.reject?
				throw new Error('The Promise implementation must support .reject')

		isPrimitive = (value) ->
			value is null or utils.isString(value) or utils.isNumber(value) or utils.isBoolean(value) or utils.isDate(value)

		# Escape a resource name (string), or resource path (array)
		escapeResource = (resource) ->
			if utils.isString(resource)
				encodeURIComponent(resource)
			else if utils.isArray(resource)
				resource =
					for component in resource
						encodeURIComponent(component)
				resource.join('/')
			else
				throw new Error('Not a valid resource: ' + typeof resource)

		# Escape a primitive value (string or number)
		escapeValue = (value) ->
			if utils.isString(value)
				value = value.replace(/'/g, "''")
				return "'" + encodeURIComponent(value) + "'"
			else if value is null or utils.isNumber(value) or utils.isBoolean(value)
				return value
			else if utils.isDate(value)
				return "datetime'#{value.toISOString()}'"
			else
				throw new Error('Not a valid value: ' + typeof value)

		join = (strOrArray, separator = ',') ->
			if utils.isString(strOrArray)
				strOrArray
			else if utils.isArray(strOrArray)
				strOrArray.join(separator)
			else
				throw new Error('Expected a string or array, got: ' + typeof strOrArray)

		# Join together a bunch of statements making sure the whole lot is correctly parenthesised
		# `forceOuterBrackets` forces the outer brackets to be included when there is only one element (eg a 1 param function)
		bracketJoin = (arr, separator, forceOuterBrackets = false) ->
			str = arr.join(')' + separator + '(')
			if arr.length > 1
				return '((' + str + '))'
			if forceOuterBrackets
				return '(' + str + ')'
			return str

		# Add the parentKey + operator if it exists.
		addParentKey = (filter, parentKey, operator = ' eq ') ->
			if parentKey?
				return escapeResource(parentKey) + operator + filter
			return filter

		applyBinds = (filter, params, parentKey) ->
			for index, param of params
				param = '(' + buildFilter(param) + ')'
				# Escape $ for filter.replace
				param = param.replace(/\$/g, '$$$$')
				filter = filter.replace(new RegExp("\\$#{index}([^a-zA-Z0-9]|$)", 'g'), "#{param}$1")
			addParentKey(filter, parentKey)

		buildFilter = do ->
			# Handle special cases for all the different $ operators.
			handleOperator = (filter, parentKey, operator) ->
				operator = operator[1...]
				switch operator
					when 'ne', 'eq', 'gt', 'ge', 'lt', 'le', 'add', 'sub', 'mul', 'div', 'mod'
						operator = ' ' + operator + ' '
						if isPrimitive(filter)
							filter = escapeValue(filter)
							addParentKey(filter, parentKey, operator)
						else if utils.isArray(filter)
							filter = handleArray(filter)
							filter = bracketJoin(filter, operator)
							addParentKey(filter, parentKey)
						else if utils.isObject(filter)
							result = handleObject(filter)
							if result.length < 1
								throw new Error("#{operator} objects must have at least 1 property, got: #{JSON.stringify(filter)}")
							if result.length is 1
								addParentKey(result[0], parentKey, operator)
							else
								filter = bracketJoin(result, operator)
								addParentKey(filter, parentKey)
						else
							throw new Error('Expected null/string/number/bool/obj/array, got: ' + typeof filter)
					when 'contains', 'endswith', 'startswith', 'length', 'indexof', 'substring', 'tolower', 'toupper', 'trim', 'concat'
					, 'year', 'month', 'day', 'hour', 'minute', 'second', 'fractionalseconds', 'date', 'time', 'totaloffsetminutes'
					, 'now', 'maxdatetime', 'mindatetime', 'totalseconds', 'round', 'floor', 'ceiling', 'isof', 'cast'
						if isPrimitive(filter)
							operands = []
							if parentKey?
								operands.push(escapeResource(parentKey))
							operands.push(escapeValue(filter))
							operator + '(' + operands.join() + ')'
						else if utils.isArray(filter)
							filter = handleArray(filter)
							filter = bracketJoin(filter, ',', true)
							filter = operator + filter
							addParentKey(filter, parentKey)
						else if utils.isObject(filter)
							result = handleObject(filter)
							filter = bracketJoin(result, ',', true)
							filter = operator + filter
							addParentKey(filter, parentKey)
						else
							throw new Error('Expected null/string/number/obj/array, got: ' + typeof filter)
					when 'raw'
						if utils.isString(filter)
							addParentKey(filter, parentKey)
						else if utils.isArray(filter)
							[ filter, params... ] = filter
							if not utils.isString(filter)
								throw new Error("First element of array for $#{operator} must be a string, got: #{typeof filter}")
							mappedParams = {}
							for param, index in params
								mappedParams[index + 1] = param
							applyBinds(filter, mappedParams, parentKey)
						else if utils.isObject(filter)
							params = filter
							filter = filter.$string
							if not utils.isString(filter)
								throw new Error("$string element of object for $#{operator} must be a string, got: #{typeof filter}")
							mappedParams = {}
							for index, param of params when index isnt '$string'
								if not /^[a-zA-Z0-9]+$/.test(index)
									throw new Error("$#{operator} param names must contain only [a-zA-Z0-9], got: #{index}")
								mappedParams[index] = param
							applyBinds(filter, mappedParams, parentKey)
						else
							throw new Error("Expected string/array/object for $#{operator}, got: #{typeof filter}")
					when ''
						filter = escapeResource(filter)
						addParentKey(filter, parentKey)
					when 'and', 'or'
						filter = buildFilter(filter, null, " #{operator} ")
						addParentKey(filter, parentKey)
					when 'in'
						operator = " #{operator} "
						if isPrimitive(filter)
							filter = escapeValue(filter)
							addParentKey(filter, parentKey, ' eq ')
						else if utils.isArray(filter)
							filter = handleArray(filter, parentKey, 1)
							filter = bracketJoin(filter, ' or ')
						else if utils.isObject(filter)
							result = handleObject(filter, parentKey)
							if result.length < 1
								throw new Error("#{operator} objects must have at least 1 property, got: #{JSON.stringify(filter)}")
							filter = bracketJoin(result, ' or ')
						else
							throw new Error('Expected null/string/number/bool/obj/array, got: ' + typeof filter)
					when 'not'
						filter = 'not(' + buildFilter(filter) + ')'
						addParentKey(filter, parentKey)
					when 'any', 'all'
						alias = filter.$alias
						expr = filter.$expr
						if not alias?
							throw new Error("Lambda expression (#{operator}) has no alias defined.")
						if not expr?
							throw new Error("Lambda expression (#{operator}) has no expr defined.")
						try
							# Disable the expandFilter deprecation notice when inside a lambda expr
							deprecatedFn = deprecated.expandFilter = ->
							expr = buildFilter(expr)
						finally
							deprecated.expandFilter = deprecatedFn
						expr = "#{operator}(#{alias}:#{expr})"
						addParentKey(expr, parentKey, '/')
					else
						throw new Error("Unrecognised operator: '#{operator}'")

			handleObject = (filter, parentKey) ->
				for own key, value of filter
					if key[0] is '$'
						handleOperator(value, parentKey, key)
					else
						key = [key]
						if parentKey?
							if parentKey.length > 0
								deprecated.expandFilter()
							key = parentKey.concat(key)
						buildFilter(value, key)

			handleArray = (filter, parentKey, minElements = 2) ->
				if filter.length < minElements
					throw new Error("Filter arrays must have at least #{minElements} elements, got: #{JSON.stringify(filter)}")

				for value in filter
					buildFilter(value, parentKey)

			# Turn a filter query object into an OData $filter string
			return (filter, parentKey, joinStr) ->
				if isPrimitive(filter)
					filter = escapeValue(filter)
					addParentKey(filter, parentKey)
				else if utils.isArray(filter)
					filter = handleArray(filter)
					filter = bracketJoin(filter, joinStr ? ' or ')
					addParentKey(filter, parentKey)
				else if utils.isObject(filter)
					filter = handleObject(filter, parentKey)
					bracketJoin(filter, joinStr ? ' and ')
				else
					throw new Error('Expected null/string/number/obj/array, got: ' + typeof filter)

		buildExpand = do ->
			handleObject = (expand, parentKey) ->
				expandOptions = []
				expands = []
				for own key, value of expand
					if key[0] is '$'
						if parentKey.length is 0
							throw new Error('Cannot have expand options without first expanding something!')
						value =
							switch key
								when '$filter'
									buildFilter(value)
								when '$expand'
									buildExpand(value)
								else
									join(value)
						expandOptions.push("#{key}=#{value}")
					else
						if parentKey.length > 0
							deprecated.expandObject()
						key = parentKey.concat(key)
						expands.push(buildExpand(value, key))
				if expandOptions.length > 0 or expands.length == 0
					expandOptions = expandOptions.join('&')
					expandOptions = escapeResource(parentKey) + "(#{expandOptions})"
					expands.push(expandOptions)
				return expands

			handleArray = (expand, parentKey) ->
				if expand.length < 1
					throw new Error("Expand arrays must have at least 1 elements, got: #{JSON.stringify(expand)}")

				for value in expand
					buildExpand(value, parentKey)

			return (expand, parentKey = []) ->
				if isPrimitive(expand)
					if parentKey.length > 0
						deprecated.expandPrimitive()
					escapeResource(parentKey.concat(expand))
				else if utils.isArray(expand)
					expand = handleArray(expand, parentKey)
					expand = join(expand)
				else if utils.isObject(expand)
					expand = handleObject(expand, parentKey)
					join(expand)

		# PinejsClientCore should be subclassed by a class that provides the following functions:
		# _request: ({method, url, body}) -> return Promise

		validParams = [
			'apiPrefix'
			'passthrough'
			'passthroughByMethod'
		]

		class PinejsClientCore

			apiPrefix: '/'
			passthrough: {}
			passthroughByMethod: {}

			# `backendParams` must be used by a backend for any additional parameters it may have.
			constructor: (params, backendParams) ->
				if utils.isString(params)
					params = { apiPrefix: params }

				if utils.isObject(params)
					for validParam in validParams when params[validParam]?
						@[validParam] = params[validParam]

			# `backendParams` must be used by a backend for any additional parameters it may have.
			clone: (params, backendParams) ->
				if utils.isString(params)
					params = { apiPrefix: params }

				cloneParams = {}
				for validParam in validParams
					if @[validParam]?
						cloneParams[validParam] = @[validParam]
					if params?[validParam]?
						cloneParams[validParam] = params[validParam]

				cloneBackendParams = {}
				if utils.isObject(@backendParams)
					for key, value of @backendParams
						cloneBackendParams[key] = value
				if utils.isObject(backendParams)
					for key, value of backendParams
						cloneBackendParams[key] = value

				new @constructor(cloneParams, cloneBackendParams)

			query: (params) ->
				@get(params)

			get: (params) ->
				singular = utils.isObject(params) and params.id?
				return @request(params, method: 'GET').then (data) ->
					if !data?.d?
						throw new Error('Invalid response received.')
					if singular
						if data.d.length > 1
							throw new Error('Returned multiple results when only one was expected.')
						return data.d[0]
					return data.d

			put: (params) ->
				return @request(params, method: 'PUT')

			patch: (params) ->
				return @request(params, method: 'PATCH')

			post: (params) ->
				return @request(params, method: 'POST')

			delete: (params) ->
				return @request(params, method: 'DELETE')

			compile: (params) ->
				if utils.isString(params)
					return params
				else if params.url?
					return params.url
				else
					if !params.resource?
						throw new Error('Either the url or resource must be specified.')
					url = params.resource

					if params.hasOwnProperty('id')
						if !params.id?
							throw new Error('If the id property is set it must be non-null')
						url += '(' + escapeValue(params.id) + ')'

					queryOptions = []
					if params.options?
						for own option, value of params.options
							value =
								switch option
									when 'filter'
										buildFilter(value)
									when 'expand'
										buildExpand(value)
									else
										if utils.isString(value) or utils.isArray(value)
											join(value)
										else
											throw new Error("'#{option}' option has no special handling so must be either a string or array")
							queryOptions.push("$#{option}=" + value)
					if params.customOptions?
						for own option, value of params.customOptions
							queryOptions.push(option + '=' + value)
					if queryOptions.length > 0
						url += '?' + queryOptions.join('&')
					return url

			request: (params, overrides = {}) ->
				try
					{ method, body, passthrough } = params
					passthrough ?= {}

					if utils.isString(params)
						method = 'GET'

					apiPrefix = params.apiPrefix ? @apiPrefix
					url = apiPrefix + @compile(params)

					method = method ? overrides.method ? 'GET'
					method = method.toUpperCase()
					# Filter to prevent accidental parameter passthrough.
					mergeObjs = [
						@passthrough
						@passthroughByMethod[method] ? {}
						passthrough ? {}
						{ method, url, body }
						overrides
					]
					opts = {}
					for obj in mergeObjs
						for own option, value of obj
							opts[option] = value
					opts.method = method

					return @_request(opts)
				catch e
					return Promise.reject(e)

		return PinejsClientCore
