m = require('mochainon')
nock = require('nock')
token = require('resin-token')
settings = require('resin-settings-client')
request = require('../lib/request')

describe 'Request:', ->

	@timeout(10000)

	beforeEach ->
		token.remove()

	describe '.send()', ->

		describe 'given a simple GET endpoint', ->

			beforeEach ->
				nock(settings.get('apiUrl')).get('/foo').reply(200, from: 'resin')

			afterEach ->
				nock.cleanAll()

			describe 'given an absolute url', ->

				beforeEach ->
					nock('https://foobar.baz').get('/foo').reply(200, from: 'foobar')

				afterEach ->
					nock.cleanAll()

				it 'should preserve the absolute url', ->
					promise = request.send
						method: 'GET'
						url: 'https://foobar.baz/foo'
					.get('body')
					m.chai.expect(promise).to.eventually.become(from: 'foobar')

				it 'should allow passing a baseUrl', ->
					promise = request.send
						method: 'GET'
						baseUrl: 'https://foobar.baz'
						url: '/foo'
					.get('body')
					m.chai.expect(promise).to.eventually.become(from: 'foobar')

		describe 'given multiple endpoints', ->

			beforeEach ->
				nock(settings.get('apiUrl'))
					.get('/foo').reply(200, method: 'GET')
					.post('/foo').reply(200, method: 'POST')
					.put('/foo').reply(200, method: 'PUT')
					.patch('/foo').reply(200, method: 'PATCH')
					.delete('/foo').reply(200, method: 'DELETE')

			afterEach ->
				nock.cleanAll()

			it 'should default to GET', ->
				promise = request.send
					url: '/foo'
				.get('body')
				m.chai.expect(promise).to.eventually.become(method: 'GET')

		describe 'given an endpoint that returns a non json response', ->

			beforeEach ->
				nock(settings.get('apiUrl')).get('/foo').reply(200, 'Hello World')

			afterEach ->
				nock.cleanAll()

			it 'should resolve with the plain body', ->
				promise = request.send
					method: 'GET'
					url: '/foo'
				.get('body')
				m.chai.expect(promise).to.eventually.equal('Hello World')

		describe 'given an endpoint that accepts a non json body', ->

			beforeEach ->
				nock(settings.get('apiUrl')).post('/foo').reply 200, (uri, body) ->
					return "The body is: #{body}"

			afterEach ->
				nock.cleanAll()

			it 'should take the plain body successfully', ->
				promise = request.send
					method: 'POST'
					url: '/foo'
					body: 'Qux'
				.get('body')
				m.chai.expect(promise).to.eventually.equal('The body is: Qux')

		describe 'given simple read only endpoints', ->

			describe 'given a GET endpoint', ->

				describe 'given no response error', ->

					beforeEach ->
						nock(settings.get('apiUrl')).get('/foo').reply(200, hello: 'world')

					afterEach ->
						nock.cleanAll()

					it 'should correctly make the request', ->
						promise = request.send
							method: 'GET'
							url: '/foo'
						.get('body')
						m.chai.expect(promise).to.eventually.become(hello: 'world')

				describe 'given a response error', ->

					beforeEach ->
						nock(settings.get('apiUrl')).get('/foo').reply(500, error: text: 'Server Error')

					afterEach ->
						nock.cleanAll()

					it 'should be rejected with the error message', ->
						promise = request.send
							method: 'GET'
							url: '/foo'
						m.chai.expect(promise).to.be.rejectedWith('Server Error')

					it 'should have the status code in the error object', (done) ->
						request.send
							method: 'GET'
							url: '/foo'
						.catch (error) ->
							m.chai.expect(error.statusCode).to.equal(500)
							done()

			describe 'given a HEAD endpoint', ->

				describe 'given no response error', ->

					beforeEach ->
						nock(settings.get('apiUrl')).head('/foo').reply(200)

					afterEach ->
						nock.cleanAll()

					it 'should correctly make the request', ->
						promise = request.send
							method: 'HEAD'
							url: '/foo'
						.get('statusCode')
						m.chai.expect(promise).to.eventually.equal(200)

				describe 'given a response error', ->

					beforeEach ->
						nock(settings.get('apiUrl')).head('/foo').reply(500)

					afterEach ->
						nock.cleanAll()

					it 'should be rejected with a generic error message', ->
						promise = request.send
							method: 'HEAD'
							url: '/foo'
						.get('statusCode')
						m.chai.expect(promise).to.be.rejectedWith('The request was unsuccessful')

		describe 'given simple endpoints that handle a request body', ->

			describe 'given a POST endpoint that mirrors the request body', ->

				beforeEach ->
					nock(settings.get('apiUrl')).post('/foo').reply 200, (uri, body) ->
						return body

				afterEach ->
					nock.cleanAll()

				it 'should eventually return the body', ->
					promise = request.send
						method: 'POST'
						url: '/foo'
						body:
							foo: 'bar'
					.get('body')
					m.chai.expect(promise).to.eventually.become(foo: 'bar')

			describe 'given a PUT endpoint that mirrors the request body', ->

				beforeEach ->
					nock(settings.get('apiUrl')).put('/foo').reply 200, (uri, body) ->
						return body

				afterEach ->
					nock.cleanAll()

				it 'should eventually return the body', ->
					promise = request.send
						method: 'PUT'
						url: '/foo'
						body:
							foo: 'bar'
					.get('body')
					m.chai.expect(promise).to.eventually.become(foo: 'bar')

			describe 'given a PATCH endpoint that mirrors the request body', ->

				beforeEach ->
					nock(settings.get('apiUrl')).patch('/foo').reply 200, (uri, body) ->
						return body

				afterEach ->
					nock.cleanAll()

				it 'should eventually return the body', ->
					promise = request.send
						method: 'PATCH'
						url: '/foo'
						body:
							foo: 'bar'
					.get('body')
					m.chai.expect(promise).to.eventually.become(foo: 'bar')

			describe 'given a DELETE endpoint that mirrors the request body', ->

				beforeEach ->
					nock(settings.get('apiUrl')).delete('/foo').reply 200, (uri, body) ->
						return body

				afterEach ->
					nock.cleanAll()

				it 'should eventually return the body', ->
					promise = request.send
						method: 'DELETE'
						url: '/foo'
						body:
							foo: 'bar'
					.get('body')
					m.chai.expect(promise).to.eventually.become(foo: 'bar')
