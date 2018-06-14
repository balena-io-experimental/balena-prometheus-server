_ = require('lodash')
Promise = require('bluebird')
m = require('mochainon')

{ auth, request, getCustomRequest, fetchMock, IS_BROWSER } = require('./setup')()

describe 'Request:', ->

	@timeout(10000)

	beforeEach ->
		auth.removeKey()

	afterEach ->
		fetchMock.restore()

	describe '.send()', ->

		describe 'given a simple absolute GET endpoint', ->

			beforeEach ->
				fetchMock.get 'https://foobar.baz/foo',
					body: from: 'foobar'
					headers:
						'Content-Type': 'application/json'

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
				fetchMock.get 'https://api.resin.io/foo',
					body: method: 'GET'
					headers:
						'Content-Type': 'application/json'
				fetchMock.post 'https://api.resin.io/foo',
					body: method: 'POST'
					headers:
						'Content-Type': 'application/json'
				fetchMock.put 'https://api.resin.io/foo',
					body: method: 'PUT'
					headers:
						'Content-Type': 'application/json'
				fetchMock.patch 'https://api.resin.io/foo',
					body: method: 'PATCH'
					headers:
						'Content-Type': 'application/json'
				fetchMock.delete 'https://api.resin.io/foo',
					body: method: 'DELETE'
					headers:
						'Content-Type': 'application/json'

			it 'should default to GET', ->
				promise = request.send
					baseUrl: 'https://api.resin.io'
					url: '/foo'
				.get('body')
				m.chai.expect(promise).to.eventually.become(method: 'GET')

		describe 'given an endpoint that returns a non json response', ->

			beforeEach ->
				fetchMock.get('https://api.resin.io/foo', 'Hello World')

			it 'should resolve with the plain body', ->
				promise = request.send
					method: 'GET'
					baseUrl: 'https://api.resin.io'
					url: '/foo'
				.get('body')
				m.chai.expect(promise).to.eventually.equal('Hello World')

		describe 'given an endpoint that accepts a non json body', ->

			beforeEach ->
				fetchMock.post 'https://api.resin.io/foo', (url, opts) ->
					return "The body is: #{opts.body}"

			it 'should take the plain body successfully', ->
				promise = request.send
					method: 'POST'
					baseUrl: 'https://api.resin.io'
					url: '/foo'
					body: 'Qux'
					json: false
				.get('body')
				m.chai.expect(promise).to.eventually.equal('The body is: Qux')

		describe 'given simple read only endpoints', ->

			describe 'given a GET endpoint', ->

				describe 'given no response error', ->

					beforeEach ->
						fetchMock.get 'https://api.resin.io/foo',
							body: hello: 'world'
							headers:
								'Content-Type': 'application/json'

					it 'should correctly make the request', ->
						promise = request.send
							method: 'GET'
							baseUrl: 'https://api.resin.io'
							url: '/foo'
						.get('body')
						m.chai.expect(promise).to.eventually.become(hello: 'world')

				describe 'given a response error', ->

					beforeEach ->
						fetchMock.get 'https://api.resin.io/foo',
							status: 500
							body: error: text: 'Server Error'
							headers:
								'Content-Type': 'application/json'

					it 'should be rejected with the error message', ->
						promise = request.send
							method: 'GET'
							baseUrl: 'https://api.resin.io'
							url: '/foo'
						m.chai.expect(promise).to.be.rejectedWith('Server Error')

					it 'should have the status code in the error object', ->
						request.send
							method: 'GET'
							baseUrl: 'https://api.resin.io'
							url: '/foo'
						.catch (error) ->
							m.chai.expect(error.statusCode).to.equal(500)

			describe 'given a HEAD endpoint', ->

				describe 'given no response error', ->

					beforeEach ->
						fetchMock.head('https://api.resin.io/foo', 200)

					it 'should correctly make the request', ->
						promise = request.send
							method: 'HEAD'
							baseUrl: 'https://api.resin.io'
							url: '/foo'
						.get('statusCode')
						m.chai.expect(promise).to.eventually.equal(200)

				describe 'given a response error', ->

					beforeEach ->
						fetchMock.head('https://api.resin.io/foo', 500)

					it 'should be rejected with a generic error message', ->
						promise = request.send
							method: 'HEAD'
							baseUrl: 'https://api.resin.io'
							url: '/foo'
						.get('statusCode')
						m.chai.expect(promise).to.be.rejectedWith('The request was unsuccessful')

		describe 'given simple endpoints that handle a request body', ->

			describe 'given a POST endpoint that mirrors the request body', ->

				beforeEach ->
					fetchMock.post 'https://api.resin.io/foo', (url, opts) ->
						body: opts.body
						headers:
							'Content-Type': 'application/json'

				it 'should eventually return the body', ->
					promise = request.send
						method: 'POST'
						baseUrl: 'https://api.resin.io'
						url: '/foo'
						body:
							foo: 'bar'
					.get('body')
					m.chai.expect(promise).to.eventually.become(foo: 'bar')

			describe 'given a PUT endpoint that mirrors the request body', ->

				beforeEach ->
					fetchMock.put 'https://api.resin.io/foo', (url, opts) ->
						body: opts.body
						headers:
							'Content-Type': 'application/json'

				it 'should eventually return the body', ->
					promise = request.send
						method: 'PUT'
						baseUrl: 'https://api.resin.io'
						url: '/foo'
						body:
							foo: 'bar'
					.get('body')
					m.chai.expect(promise).to.eventually.become(foo: 'bar')

			describe 'given a PATCH endpoint that mirrors the request body', ->

				beforeEach ->
					fetchMock.patch 'https://api.resin.io/foo', (url, opts) ->
						body: opts.body
						headers:
							'Content-Type': 'application/json'

				it 'should eventually return the body', ->
					promise = request.send
						method: 'PATCH'
						baseUrl: 'https://api.resin.io'
						url: '/foo'
						body:
							foo: 'bar'
					.get('body')
					m.chai.expect(promise).to.eventually.become(foo: 'bar')

			describe 'given a DELETE endpoint that mirrors the request body', ->

				beforeEach ->
					fetchMock.delete 'https://api.resin.io/foo', (url, opts) ->
						body: opts.body
						headers:
							'Content-Type': 'application/json'

				it 'should eventually return the body', ->
					promise = request.send
						method: 'DELETE'
						baseUrl: 'https://api.resin.io'
						url: '/foo'
						body:
							foo: 'bar'
					.get('body')
					m.chai.expect(promise).to.eventually.become(foo: 'bar')

		describe 'given an endpoint that fails the first two times', ->

			beforeEach ->
				requestsSeen = 0
				fetchMock.get 'https://example.com/initially-failing', Promise.method ->
					requestsSeen += 1
					if requestsSeen <= 2
						throw new Error('low-level network error')
					else
						return {
							body: result: 'success'
							headers:
								'Content-Type': 'application/json'
						}

			it 'should fail by default', ->
				promise = request.send
					method: 'GET'
					url: 'https://example.com/initially-failing'
				.get('body')
				m.chai.expect(promise).to.eventually.be.rejectedWith(Error)

			it 'should retry and fail if set to retry just once', ->
				promise = request.send
					method: 'GET'
					url: 'https://example.com/initially-failing'
					retries: 1
				.get('body')
				m.chai.expect(promise).to.eventually.be.rejectedWith(Error)

			it 'should retry and eventually succeed if set to retry more than once', ->
				promise = request.send
					method: 'GET'
					url: 'https://example.com/initially-failing'
					retries: 2
				.get('body')
				m.chai.expect(promise).to.eventually.become(result: 'success')

			it 'should retry and eventually succeed if set to retry more than once by default', ->
				retryingRequest = getCustomRequest({ retries: 2 })
				promise = retryingRequest.send
					method: 'GET'
					url: 'https://example.com/initially-failing'
				.get('body')
				m.chai.expect(promise).to.eventually.become(result: 'success')

		describe 'given an endpoint that will time out', ->

			NODE_TIMEOUT_ERROR = new Error('node timeout error')

			beforeEach ->
				@clock = m.sinon.useFakeTimers()

			afterEach ->
				@clock.restore()

			stubTimeout = -> new Promise (resolve, reject) ->
				fetchMock.get 'http://infinite-wait.com', (url, opts) ->
					resolve()

					# Emulate node-fetch timeout behaviour if we use it
					if not IS_BROWSER and opts.timeout
						Promise.delay(opts.timeout).throw(NODE_TIMEOUT_ERROR)
					# Browser/no timeout fetch() simply never resolves.
					else
						new Promise(_.noop)

			it 'should reject the promise after 30s by default', ->
				promise = request.send
					method: 'GET'
					url: 'http://infinite-wait.com'
				.get('body')

				stubTimeout().then =>
					@clock.tick(29000)
					m.chai.expect(promise.isPending()).to.equal(true)

					@clock.tick(1000)
					m.chai.expect(promise).to.eventually.be.rejectedWith(Error)

			it 'should use a provided timeout option', ->
				promise = request.send
					method: 'GET'
					url: 'http://infinite-wait.com'
					timeout: 5000
				.get('body')

				stubTimeout().then =>
					@clock.tick(4000)
					m.chai.expect(promise.isPending()).to.equal(true)

					@clock.tick(1000)
					m.chai.expect(promise).to.eventually.be.rejectedWith(Error)

			it 'should be rejected by the correct error', ->
				promise = request.send
					method: 'GET'
					url: 'http://infinite-wait.com'
				.get('body')

				stubTimeout().then =>
					@clock.tick(30000)

					if IS_BROWSER
						m.chai.expect(promise).to.be.rejectedWith(Promise.TimeoutError)
					else
						m.chai.expect(promise).to.be.rejectedWith(NODE_TIMEOUT_ERROR)
