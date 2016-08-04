{ test } = require './test'

testExpand = (input, output) ->
	resource = 'test'
	url = resource + '?$expand=' + output
	it "should compile #{JSON.stringify(input)} to #{url}", ->
		test url, {
			resource
			options:
				expand: input
		}

# String
testExpand(
	'a'
	'a'
)

# String array
testExpand(
	['a']
	'a'
)

testExpand(
	['a', 'b']
	'a,b'
)

# String object
testExpand(
	a: 'b'
	'a/b'
)

testExpand(
	a: 'b'
	c: 'd'
	'a/b,c/d'
)

# Object array
testExpand(
	[
		a: 'b'
	]
	'a/b'
)

testExpand(
	[
		a: 'b'
	,
		c: 'd'
	]
	'a/b,c/d'
)

# Array in object
testExpand(
	a: [
		'b'
		'c'
	]
	'a/b,a/c'
)

testExpand(
	a: [
		b: 'c'
	,
		d: 'e'
	]
	'a/b/c,a/d/e'
)

# Object in object
testExpand(
	a:
		b: 'c'
		d: 'e'
	'a/b/c,a/d/e'
)

# Expand options
testExpand(
	a: $filter: b: 'c'
	"a($filter=b eq 'c')"
)

testExpand(
	a:
		$select: ['b', 'c']
	'a($select=b,c)'
)

testExpand(
	a:
		$filter: b: 'c'
		$select: ['d', 'e']
	"a($filter=b eq 'c'&$select=d,e)"
)

testExpand(
	a:
		b: 'c'
		$filter: d: 'e'
		$select: ['f', 'g']
	"a/b/c,a($filter=d eq 'e'&$select=f,g)"
)

testExpand(
	a: [
		$filter: b: 'c'
	,
		$filter: d: 'e'
		$select: ['f', 'g']
	]
	"a($filter=b eq 'c'),a($filter=d eq 'e'&$select=f,g)"
)

testExpand
	a:
		$expand: 'b'
	"a($expand=b)"

testExpand
	a:
		$expand:
			b:
				$expand: 'c'
	"a($expand=b($expand=c))"

testExpand
	a:
		$expand:
			b:
				$expand: 'c'
				$select: [ 'd', 'e' ]
	"a($expand=b($expand=c&$select=d,e))"
