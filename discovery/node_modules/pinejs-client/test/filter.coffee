{ test } = require './test'
_ = require 'lodash'

testFilter = (input, output) ->
	resource = 'test'
	if not _.isError(output)
		output = resource + '?$filter=' + output
	it "should compile #{JSON.stringify(input)} to #{output}", ->
		test output, {
			resource
			options:
				filter: input
		}

testFilter(
	a: 'b'
	d: 'e'
	"((a eq 'b') and (d eq 'e'))"
)

testFilter(
	a: "b'c"
	d: "e''f'''g"
	"((a eq 'b''c') and (d eq 'e''''f''''''g'))"
)

testOperator = (operator) ->
	createFilter = (partialFilter) ->
		"$#{operator}": partialFilter

	testFilter(
		createFilter
			a: 'b'
			c: 'd'
		"((a eq 'b') #{operator} (c eq 'd'))"
	)

	testFilter(
		createFilter [
			a: 'b'
		,
			c: 'd'
		]
		"((a eq 'b') #{operator} (c eq 'd'))"
	)

	testFilter(
		a: createFilter 'b'
		"a #{operator} 'b'"
	)

	testFilter(
		a: createFilter [
			'b'
			'c'
		]
		"a eq (('b') #{operator} ('c'))"
	)

	testFilter(
		a: createFilter
			b: 'c'
			d: 'e'
		"a eq ((b eq 'c') #{operator} (d eq 'e'))"
	)

	testFilter(
		a: createFilter
			$: 'b'
		"a #{operator} b"
	)

	testFilter(
		a: createFilter
			$: ['b', 'c']
		"a #{operator} b/c"
	)

	rawDatetime = "datetime'2015-10-20T14%3A04%3A05.374Z'"
	testFilter(
		a: createFilter
			$raw: rawDatetime
		"a #{operator} #{rawDatetime}"
	)

	testFilter(
		a: createFilter
			$or: [
				$: 'b'
			,
				$: 'c'
			]
		"a #{operator} ((b) or (c))"
	)

testFunction = (funcName) ->
	createFilter = (partialFilter) ->
		filter = {}
		filter['$' + funcName] = partialFilter
		return filter

	testFilter(
		createFilter
			a: 'b'
			c: 'd'
		"#{funcName}((a eq 'b'),(c eq 'd'))"
	)

	testFilter(
		createFilter [
			a: 'b'
		,
			c: 'd'
		]
		"#{funcName}((a eq 'b'),(c eq 'd'))"
	)

	testFilter(
		a: createFilter 'b'
		"#{funcName}(a,'b')"
	)

	testFilter(
		a: createFilter [
			'b'
			'c'
		]
		"a eq #{funcName}(('b'),('c'))"
	)

	testFilter(
		a: createFilter
			b: 'c'
			d: 'e'
		"a eq #{funcName}((b eq 'c'),(d eq 'e'))"
	)

testOperator('ne')
testOperator('eq')
testOperator('gt')
testOperator('ge')
testOperator('lt')
testOperator('le')

# Test operands
testFilter(
	a: 'b'
	"a eq 'b'"
)
testFilter(
	a: 1
	'a eq 1'
)
testFilter(
	a: true
	'a eq true'
)
testFilter(
	a: false
	'a eq false'
)
testFilter(
	a: null
	'a eq null'
)
do ->
	date = new Date()
	testFilter(
		a: date
		"a eq datetime'#{date.toISOString()}'"
	)


# Test mixing operators
testFilter(
	$ne: [
		$eq:
			a: 'b'
			c: 'd'
	,
		e: 'f'
	]
	"((((a eq 'b') eq (c eq 'd'))) ne (e eq 'f'))"
)

testFilter(
	[
		$eq:
			a: 'b'
			c: 'd'
	,
		$ne:
			e: 'f'
			g: 'h'
	]
	"((((a eq 'b') eq (c eq 'd'))) or (((e eq 'f') ne (g eq 'h'))))"
)

testFilter(
	$ne: [
		$eq: [
			a: 'b'
		,
			d: 'e'
		]
	,
		c: 'd'
	]
	"((((a eq 'b') eq (d eq 'e'))) ne (c eq 'd'))"
)

testFilter(
	a:
		b: 'c'
	"a/b eq 'c'"
)

testFilter(
	a:
		b: 'c'
		d: 'e'
	"((a/b eq 'c') and (a/d eq 'e'))"
)

testFilter(
	a: [
		b: 'c'
	,
		d: 'e'
	]
	"a eq ((b eq 'c') or (d eq 'e'))"
)

testFilter(
	a: [
		'c'
		'd'
	]
	"a eq (('c') or ('d'))"
)

testFilter(
	a:
		b: [
			'c'
			'd'
		]
	"a/b eq (('c') or ('d'))"
)

testFilter(
	a:
		[
			b: 'c'
			'd'
		]
	"a eq ((b eq 'c') or ('d'))"
)

testFilter(
	a:
		b: 'c'
		$eq: 'd'
	"((a/b eq 'c') and (a eq 'd'))"
)

# Test raw strings
testFilter(
	$raw: "(a/b eq 'c' and a eq 'd')"
	"(a/b eq 'c' and a eq 'd')"
)

testFilter(
	$raw: true
	new Error('Expected string/array/object for $raw, got: boolean')
)

testFilter(
	[
		$raw: 'a ge b'
	,
		$raw: 'a le c'
	]
	'((a ge b) or (a le c))'
)

testFilter(
	a:
		b: [
			$raw: 'c ge d'
		,
			$raw: 'd le e'
		]
	'a/b eq ((c ge d) or (d le e))'
)

testFilter(
	a:
		b:
			$and: [
				$raw: 'c ge d'
			,
				$raw: 'e le f'
			]
	'a/b eq ((c ge d) and (e le f))'
)


# Test raw arrays
testFilter(
	$raw: [
		'a/b eq $1 and a eq $2'
		'c'
		'd'
	]
	"a/b eq ('c') and a eq ('d')"
)

testFilter(
	$raw: [
		true
	]
	new Error('First element of array for $raw must be a string, got: boolean')
)

testFilter(
	$raw: [
		'a/b eq $1 and a eq $2'
		{ c: 'd' }
		$add: [
			1
			2
		]
	]
	"a/b eq (c eq 'd') and a eq (((1) add (2)))"
)

testFilter(
	$raw: [
		'a/b eq $1'
		$raw: '$$'
	]
	'a/b eq ($$)'
)

testFilter(
	$raw: [
		'a/b eq $10 and a eq $1'
		[1..10]...
	]
	'a/b eq (10) and a eq (1)'
)


# Test raw objects
testFilter(
	$raw:
		$string: 'a/b eq $1 and a eq $2'
		1: 'c'
		2: 'd'
	"a/b eq ('c') and a eq ('d')"
)

testFilter(
	$raw:
		$string: true
	new Error('$string element of object for $raw must be a string, got: boolean')
)
testFilter(
	$raw:
		$string: ''
		$invalid: ''
	new Error('$raw param names must contain only [a-zA-Z0-9], got: $invalid')
)

testFilter(
	$raw:
		$string: 'a/b eq $1 and a eq $2'
		1: c: 'd'
		2: $add: [
			1
			2
		]
	"a/b eq (c eq 'd') and a eq (((1) add (2)))"
)

testFilter(
	$raw:
		$string: 'a/b eq $1'
		1: $raw: '$$'
	'a/b eq ($$)'
)

testFilter(
	$raw:
		$string: 'a/b eq $10 and a eq $1'
		1: 1
		10: 10
	'a/b eq (10) and a eq (1)'
)

testFilter(
	$raw:
		$string: 'a eq $a and b eq $b or b eq $b2'
		a: 'a'
		b: 'b'
		b2: 'b2'
	"a eq ('a') and b eq ('b') or b eq ('b2')"
)


# Test $and
testFilter(
	a:
		b:
			$and: [
				'c'
				'd'
			]
	"a/b eq (('c') and ('d'))"
)

testFilter(
	a:
		b:
			$and: [
				c: 'd'
			,
				e: 'f'
			]
	"a/b eq ((c eq 'd') and (e eq 'f'))"
)

# Test $or
testFilter(
	a:
		b:
			$or: [
				'c'
				'd'
			]
	"a/b eq (('c') or ('d'))"
)

testFilter(
	a:
		b:
			$or: [
				c: 'd'
			,
				e: 'f'
			]
	"a/b eq ((c eq 'd') or (e eq 'f'))"
)

# Test $in
testFilter(
	a:
		b:
			$in: [
				'c'
			]
	"a/b eq 'c'"
)

testFilter(
	a:
		b:
			$in: [
				'c'
				'd'
			]
	"((a/b eq 'c') or (a/b eq 'd'))"
)

testFilter(
	a:
		b:
			$in: [
				c: 'd'
			,
				e: 'f'
			]
	"((a/b/c eq 'd') or (a/b/e eq 'f'))"
)

testFilter(
	a:
		b:
			$in:
				c: 'd'
	"a/b/c eq 'd'"
)

testFilter(
	a:
		b:
			$in:
				c: 'd'
				e: 'f'
	"((a/b/c eq 'd') or (a/b/e eq 'f'))"
)

testFilter(
	a:
		b:
			$in: 'c'
	"a/b eq 'c'"
)

# Test $not
testFilter(
	$not: 'a'
	"not('a')"
)

testFilter(
	$not:
		a: 'b'
	"not(a eq 'b')"
)

testFilter(
	$not:
		a: 'b'
		c: 'd'
	"not(((a eq 'b') and (c eq 'd')))"
)

testFilter(
	$not: [
		a: 'b'
	,
		c: 'd'
	]
	"not(((a eq 'b') or (c eq 'd')))"
)

testFilter(
	a:
		$not: 'b'
	"a eq not('b')"
)

testFilter(
	a:
		$not: [
			'b'
			'c'
		]
	"a eq not((('b') or ('c')))"
)

testFilter(
	a:
		$not:
			b: 'c'
			d: 'e'
	"a eq not(((b eq 'c') and (d eq 'e')))"
)

testFilter(
	a:
		$not: [
			b: 'c'
		,
			d: 'e'
		]
	"a eq not(((b eq 'c') or (d eq 'e')))"
)

# Test $add
testOperator('add')

# Test $sub
testOperator('sub')

# Test $mul
testOperator('mul')

# Test $div
testOperator('div')

# Test $mod
testOperator('mod')

# Test $
testFilter(
	a:
		$: 'b'
	'a eq b'
)

testFilter(
	a:
		b:
			$: 'c'
	'a/b eq c'
)

testFilter(
	a:
		b:
			$: ['c', 'd']
	'a/b eq c/d'
)

# Test functions
testFunction('contains')
testFunction('endswith')
testFunction('startswith')
testFunction('length')
testFunction('indexof')
testFunction('substring')
testFunction('tolower')
testFunction('toupper')
testFunction('trim')
testFunction('concat')
testFunction('year')
testFunction('month')
testFunction('day')
testFunction('hour')
testFunction('minute')
testFunction('second')
testFunction('fractionalseconds')
testFunction('date')
testFunction('time')
testFunction('totaloffsetminutes')
testFunction('now')
testFunction('maxdatetime')
testFunction('mindatetime')
testFunction('totalseconds')
testFunction('round')
testFunction('floor')
testFunction('ceiling')
testFunction('isof')
testFunction('cast')

# Test a one param function
testFilter(
	$eq: [
		$tolower: $: 'a'
	,
		$tolower: 'b'
	]
	"((tolower(a)) eq (tolower('b')))"
)

testLambda = (operator) ->
	createFilter = (partialFilter) ->
		"$#{operator}": partialFilter

	testFilter(
		a:
			createFilter
				$alias: 'b'
				$expr:
					b: c: 'd'
		"a/#{operator}(b:b/c eq 'd')"
	)

	testFilter(
		a:
			createFilter
				$expr:
					b: c: 'd'
		new Error("Lambda expression (#{operator}) has no alias defined.")
	)

	testFilter(
		a:
			createFilter
				$alias: 'b'
		new Error("Lambda expression (#{operator}) has no expr defined.")
	)

# Test $any
testLambda('any')

# Test $all
testLambda('all')
