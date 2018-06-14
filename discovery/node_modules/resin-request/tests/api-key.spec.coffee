Promise = require('bluebird')
m = require('mochainon')
rindle = require('rindle')
johnDoeFixture = require('./tokens.json').johndoe
utils = require('../lib/utils')

{ auth, request, fetchMock, IS_BROWSER } = require('./setup')()

describe 'Request (api key):', ->

	@timeout(10000)

	describe 'given the token is always fresh', ->

		beforeEach ->
			@utilsShouldUpdateToken = m.sinon.stub(utils, 'shouldRefreshKey')
			@utilsShouldUpdateToken.returns(Promise.resolve(false))

		afterEach ->
			@utilsShouldUpdateToken.restore()

		describe 'given a simple GET endpoint containing special characters in query strings', ->

			beforeEach ->
				fetchMock.get('begin:https://api.resin.io/foo', 200)

			afterEach ->
				fetchMock.restore()

			describe 'given no api key', ->

				it 'should not encode special characters automatically', ->
					promise = request.send
						method: 'GET'
						baseUrl: 'https://api.resin.io'
						url: '/foo?$bar=baz'
						apiKey: undefined
					.get('request')
					.get('uri')
					.get('path')
					m.chai.expect(promise).to.eventually.equal('/foo?$bar=baz')

			describe 'given an api key', ->

				it 'should not encode special characters automatically', ->
					promise = request.send
						method: 'GET'
						baseUrl: 'https://api.resin.io'
						url: '/foo?$bar=baz'
						apiKey: '123456789'
					.get('request')
					.get('uri')
					.get('path')
					m.chai.expect(promise).to.eventually.equal('/foo?$bar=baz&apikey=123456789')

		describe 'given a simple GET endpoint', ->

			beforeEach ->
				fetchMock.get('begin:https://api.resin.io/foo', 'Foo Bar')

			afterEach ->
				fetchMock.restore()

			describe 'given an api key', ->

				describe 'given no token', ->

					beforeEach ->
						auth.removeKey()

					describe '.send()', ->

						it 'should pass an apikey query string', ->
							promise = request.send
								method: 'GET'
								baseUrl: 'https://api.resin.io'
								url: '/foo'
								apiKey: '123456789'
							.get('request')
							.get('uri')
							.get('query')
							m.chai.expect(promise).to.eventually.equal('apikey=123456789')

					describe '.stream()', ->

						return if IS_BROWSER

						it 'should pass an apikey query string', ->
							request.stream
								method: 'GET'
								baseUrl: 'https://api.resin.io'
								url: '/foo'
								apiKey: '123456789'
							.then (stream) ->
								m.chai.expect(stream.response.request.uri.query).to.equal('apikey=123456789')
								rindle.extract(stream)

				describe 'given a token', ->

					beforeEach ->
						auth.setKey(johnDoeFixture.token)

					describe '.send()', ->

						it 'should pass an apikey query string', ->
							promise = request.send
								method: 'GET'
								baseUrl: 'https://api.resin.io'
								url: '/foo'
								apiKey: '123456789'
							.get('request')
							.get('uri')
							.get('query')
							m.chai.expect(promise).to.eventually.equal('apikey=123456789')

						it 'should still send an Authorization header', ->
							promise = request.send
								method: 'GET'
								baseUrl: 'https://api.resin.io'
								url: '/foo'
								apiKey: '123456789'
							.get('request')
							.get('headers')
							.get('Authorization')
							m.chai.expect(promise).to.eventually.equal("Bearer #{johnDoeFixture.token}")

					describe '.stream()', ->

						return if IS_BROWSER

						it 'should pass an apikey query string', ->
							request.stream
								method: 'GET'
								baseUrl: 'https://api.resin.io'
								url: '/foo'
								apiKey: '123456789'
							.then (stream) ->
								m.chai.expect(stream.response.request.uri.query).to.equal('apikey=123456789')
								rindle.extract(stream)

						it 'should still send an Authorization header', ->
							request.stream
								method: 'GET'
								baseUrl: 'https://api.resin.io'
								url: '/foo'
								apiKey: '123456789'
							.then (stream) ->
								headers = stream.response.request.headers
								m.chai.expect(headers.Authorization).to.equal("Bearer #{johnDoeFixture.token}")
								rindle.extract(stream)

			describe 'given an empty api key', ->

				describe 'given no token', ->

					beforeEach ->
						auth.removeKey()

					describe '.send()', ->

						it 'should not pass an apikey query string', ->
							promise = request.send
								method: 'GET'
								baseUrl: 'https://api.resin.io'
								url: '/foo'
								apiKey: ''
							.get('request')
							.get('uri')
							.get('query')
							m.chai.expect(promise).to.eventually.be.null

					describe '.stream()', ->

						return if IS_BROWSER

						it 'should not pass an apikey query string', ->
							request.stream
								method: 'GET'
								baseUrl: 'https://api.resin.io'
								url: '/foo'
								apiKey: ''
							.then (stream) ->
								m.chai.expect(stream.response.request.uri.query).to.not.exist
								rindle.extract(stream)
