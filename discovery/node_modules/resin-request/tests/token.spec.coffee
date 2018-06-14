Promise = require('bluebird')
m = require('mochainon')
errors = require('resin-errors')
rindle = require('rindle')
tokens = require('./tokens.json')

johnDoeFixture = tokens.johndoe
janeDoeFixture = tokens.janedoe
utils = require('../lib/utils')

{ auth, request, fetchMock, IS_BROWSER } = require('./setup')()

describe 'Request (token):', ->

	@timeout(10000)

	describe '.send()', ->

		describe 'given a simple GET endpoint', ->

			beforeEach ->
				fetchMock.get('begin:https://api.resin.io/foo', 'bar')

			afterEach ->
				fetchMock.restore()

			describe 'given the token is always fresh', ->

				beforeEach ->
					@utilsShouldUpdateToken = m.sinon.stub(utils, 'shouldRefreshKey')
					@utilsShouldUpdateToken.returns(Promise.resolve(false))

				afterEach ->
					@utilsShouldUpdateToken.restore()

				describe 'given there is a token', ->

					beforeEach ->
						auth.setKey(johnDoeFixture.token)

					it 'should send an Authorization header', ->
						promise = request.send
							method: 'GET'
							baseUrl: 'https://api.resin.io'
							url: '/foo'
						.get('request')
						.get('headers')
						.get('Authorization')
						m.chai.expect(promise).to.eventually.equal("Bearer #{johnDoeFixture.token}")

					it 'should not send an Authorization header if sendToken is false', ->
						promise = request.send
							method: 'GET'
							baseUrl: 'https://api.resin.io'
							url: '/foo'
							sendToken: false
						.get('request')
						.get('headers')
						.get('Authorization')
						m.chai.expect(promise).to.eventually.equal(undefined)

				describe 'given there is no token', ->

					beforeEach ->
						auth.removeKey()

					it 'should not send an Authorization header', ->
						promise = request.send
							method: 'GET'
							baseUrl: 'https://api.resin.io'
							url: '/foo'
						.get('request')
						.get('headers')
						.get('Authorization')
						m.chai.expect(promise).to.eventually.not.exist

			describe 'given the token needs to be updated', ->

				beforeEach ->
					@utilsShouldUpdateToken = m.sinon.stub(utils, 'shouldRefreshKey')
					@utilsShouldUpdateToken.returns(Promise.resolve(true))

					auth.setKey(johnDoeFixture.token)


				afterEach ->
					@utilsShouldUpdateToken.restore()

				describe 'given a working /whoami endpoint', ->

					beforeEach ->
						fetchMock.get('https://api.resin.io/whoami', janeDoeFixture.token)

					afterEach ->
						fetchMock.restore()

					it 'should refresh the token', ->
						auth.getKey().then (savedToken) ->
							m.chai.expect(savedToken).to.equal(johnDoeFixture.token)
							return request.send
								baseUrl: 'https://api.resin.io'
								url: '/foo'
						.then (response) ->
							m.chai.expect(response.body).to.equal('bar')
							return auth.getKey()
						.then (savedToken) ->
							m.chai.expect(savedToken).to.equal(janeDoeFixture.token)

					# We could make the token request in parallel to avoid
					# having to wait for it to make the actual request.
					# Given the impact is minimal, the implementation aims
					# to simplicity.
					it 'should use the new token in the same request', ->
						m.chai.expect(auth.getKey()).to.eventually.equal(johnDoeFixture.token)
						request.send
							baseUrl: 'https://api.resin.io'
							url: '/foo'
						.then (response) ->
							authorizationHeader = response.request.headers.Authorization
							m.chai.expect(authorizationHeader).to.equal("Bearer #{janeDoeFixture.token}")

				describe 'given /whoami returns 401', ->

					beforeEach ->
						fetchMock.get 'https://api.resin.io/whoami',
							status: 401
							body: 'Unauthorized'

					afterEach ->
						fetchMock.restore()

					it 'should be rejected with an expiration error', ->
						promise = request.send
							baseUrl: 'https://api.resin.io'
							url: '/foo'
						m.chai.expect(promise).to.be.rejectedWith(errors.ResinExpiredToken)

					it 'should have the session token as an error attribute', ->
						request.send
							baseUrl: 'https://api.resin.io'
							url: '/foo'
						.catch (error) ->
							m.chai.expect(error.token).to.equal(johnDoeFixture.token)

					it 'should clear the token', ->
						request.send
							baseUrl: 'https://api.resin.io'
							url: '/foo'
						.catch ->
							auth.hasKey().then (hasKey) ->
								m.chai.expect(hasKey).to.be.false

				describe 'given /whoami returns a non 401 status code', ->

					beforeEach ->
						fetchMock.get('https://api.resin.io/whoami', 500)

					afterEach ->
						fetchMock.restore()

					it 'should be rejected with a request error', ->
						promise = request.send
							baseUrl: 'https://api.resin.io'
							url: '/foo'
						m.chai.expect(promise).to.be.rejectedWith(errors.ResinRequestError)

	describe '.stream()', ->

		return if IS_BROWSER

		describe 'given a simple endpoint that responds with a string', ->

			beforeEach ->
				fetchMock.get('https://api.resin.io/foo', 'Lorem ipsum dolor sit amet')

			afterEach ->
				fetchMock.restore()

			describe 'given the token is always fresh', ->

				beforeEach ->
					@utilsShouldUpdateToken = m.sinon.stub(utils, 'shouldRefreshKey')
					@utilsShouldUpdateToken.returns(Promise.resolve(false))

				afterEach ->
					@utilsShouldUpdateToken.restore()

				describe 'given there is a token', ->

					beforeEach ->
						auth.setKey(johnDoeFixture.token)

					it 'should send an Authorization header', ->
						request.stream
							method: 'GET'
							baseUrl: 'https://api.resin.io'
							url: '/foo'
						.then (stream) ->
							headers = stream.response.request.headers
							m.chai.expect(headers.Authorization).to.equal("Bearer #{johnDoeFixture.token}")
							rindle.extract(stream)

				describe 'given there is no token', ->

					beforeEach ->
						auth.removeKey()

					it 'should not send an Authorization header', ->
						request.stream
							method: 'GET'
							baseUrl: 'https://api.resin.io'
							url: '/foo'
						.then (stream) ->
							headers = stream.response.request.headers
							m.chai.expect(headers.Authorization).to.not.exist
							rindle.extract(stream)
