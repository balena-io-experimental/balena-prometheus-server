{ test } = require './test'

it 'should throw an unrecognised operator error', ->
	test new Error("Unrecognised operator: 'foobar'"),
		resource: 'test'
		options:
			filter:
				$foobar: 'fails'

it 'should throw an error on null id', ->
	test new Error('If the id property is set it must be non-null'),
		resource: 'test'
		id: null

it 'should throw an error on undefined id', ->
	test new Error('If the id property is set it must be non-null'),
		resource: 'test'
		id: undefined
