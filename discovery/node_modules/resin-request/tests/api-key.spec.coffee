Promise = require('bluebird')
m = require('mochainon')
nock = require('nock')
rindle = require('rindle')
settings = require('resin-settings-client')
token = require('resin-token')
johnDoeFixture = require('./tokens.json').johndoe
request = require('../lib/request')
utils = require('../lib/utils')

describe 'Request (api key):', ->

	@timeout(10000)

	describe 'given the token is always fresh', ->

		beforeEach ->
			@utilsShouldUpdateToken = m.sinon.stub(utils, 'shouldUpdateToken')
			@utilsShouldUpdateToken.returns(Promise.resolve(false))

		afterEach ->
			@utilsShouldUpdateToken.restore()

		describe 'given a simple GET endpoint containing special characters in query strings', ->

			beforeEach ->
				nock(settings.get('apiUrl'))
					.get('/foo')
					.query(true)
					.reply(200)

			afterEach ->
				nock.cleanAll()

			describe 'given no api key', ->

				beforeEach ->
					process.env.RESIN_API_KEY = ''

				it 'should not encode special characters automatically', ->
					promise = request.send
						method: 'GET'
						url: '/foo?$bar=baz'
					.get('request')
					.get('uri')
					.get('path')
					m.chai.expect(promise).to.eventually.equal('/foo?$bar=baz')

			describe 'given an api key', ->

				beforeEach ->
					process.env.RESIN_API_KEY = '123456789'

				afterEach ->
					process.env.RESIN_API_KEY = ''

				it 'should not encode special characters automatically', ->
					promise = request.send
						method: 'GET'
						url: '/foo?$bar=baz'
					.get('request')
					.get('uri')
					.get('path')
					m.chai.expect(promise).to.eventually.equal('/foo?$bar=baz&api_key=123456789')

		describe 'given a simple GET endpoint', ->

			beforeEach ->
				nock(settings.get('apiUrl')).get('/foo').query(true).reply(200, 'Foo Bar')

			afterEach ->
				nock.cleanAll()

			describe 'given an api key', ->

				beforeEach ->
					process.env.RESIN_API_KEY = '123456789'

				afterEach ->
					process.env.RESIN_API_KEY = ''

				describe 'given no token', ->

					beforeEach ->
						token.remove()

					describe '.send()', ->

						it 'should pass an api_key query string', ->
							promise = request.send
								method: 'GET'
								url: '/foo'
							.get('request')
							.get('uri')
							.get('query')
							m.chai.expect(promise).to.eventually.equal('api_key=123456789')

					describe '.stream()', ->

						it 'should pass an api_key query string', (done) ->
							request.stream
								method: 'GET'
								url: '/foo'
							.then (stream) ->
								m.chai.expect(stream.response.request.uri.query).to.equal('api_key=123456789')
								rindle.extract(stream).nodeify(done)

				describe 'given a token', ->

					beforeEach ->
						token.set(johnDoeFixture.token)

					describe '.send()', ->

						it 'should pass an api_key query string', ->
							promise = request.send
								method: 'GET'
								url: '/foo'
							.get('request')
							.get('uri')
							.get('query')
							m.chai.expect(promise).to.eventually.equal('api_key=123456789')

						it 'should still send an Authorization header', ->
							promise = request.send
								method: 'GET'
								url: '/foo'
							.get('request')
							.get('headers')
							.get('Authorization')
							m.chai.expect(promise).to.eventually.equal("Bearer #{johnDoeFixture.token}")

					describe '.stream()', ->

						it 'should pass an api_key query string', (done) ->
							request.stream
								method: 'GET'
								url: '/foo'
							.then (stream) ->
								m.chai.expect(stream.response.request.uri.query).to.equal('api_key=123456789')
								rindle.extract(stream).nodeify(done)

						it 'should still send an Authorization header', (done) ->
							request.stream
								method: 'GET'
								url: '/foo'
							.then (stream) ->
								headers = stream.response.request.headers
								m.chai.expect(headers.Authorization).to.equal("Bearer #{johnDoeFixture.token}")
								rindle.extract(stream).nodeify(done)

			describe 'given an empty api key', ->

				beforeEach ->
					process.env.RESIN_API_KEY = ''

				describe 'given no token', ->

					beforeEach ->
						token.remove()

					describe '.send()', ->

						it 'should not pass an api_key query string', ->
							promise = request.send
								method: 'GET'
								url: '/foo'
							.get('request')
							.get('uri')
							.get('query')
							m.chai.expect(promise).to.eventually.be.null

						it 'should not pass an api_key query string', ->
							promise = request.send
								method: 'GET'
								url: '/foo'
							.get('request')
							.get('uri')
							.get('query')
							m.chai.expect(promise).to.eventually.be.null

					describe '.stream()', ->

						it 'should not pass an api_key query string', (done) ->
							request.stream
								method: 'GET'
								url: '/foo'
							.then (stream) ->
								m.chai.expect(stream.response.request.uri.query).to.not.exist
								rindle.extract(stream).nodeify(done)
