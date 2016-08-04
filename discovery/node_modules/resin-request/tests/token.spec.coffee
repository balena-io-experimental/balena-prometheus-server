Promise = require('bluebird')
m = require('mochainon')
nock = require('nock')
settings = require('resin-settings-client')
errors = require('resin-errors')
rindle = require('rindle')
token = require('resin-token')
tokens = require('./tokens.json')
johnDoeFixture = tokens.johndoe
janeDoeFixture = tokens.janedoe
request = require('../lib/request')
utils = require('../lib/utils')

describe 'Request (token):', ->

	@timeout(10000)

	describe '.send()', ->

		describe 'given a simple GET endpoint', ->

			beforeEach ->
				nock(settings.get('apiUrl')).get('/foo').reply(200, 'bar')

			afterEach ->
				nock.cleanAll()

			describe 'given the token is always fresh', ->

				beforeEach ->
					@utilsShouldUpdateToken = m.sinon.stub(utils, 'shouldUpdateToken')
					@utilsShouldUpdateToken.returns(Promise.resolve(false))

				afterEach ->
					@utilsShouldUpdateToken.restore()

				describe 'given there is a token', ->

					beforeEach ->
						token.set(johnDoeFixture.token)

					it 'should send an Authorization header', ->
						promise = request.send
							method: 'GET'
							url: '/foo'
						.get('request')
						.get('headers')
						.get('Authorization')
						m.chai.expect(promise).to.eventually.equal("Bearer #{johnDoeFixture.token}")

				describe 'given there is no token', ->

					beforeEach ->
						token.remove()

					it 'should not send an Authorization header', ->
						promise = request.send
							method: 'GET'
							url: '/foo'
						.get('request')
						.get('headers')
						.get('Authorization')
						m.chai.expect(promise).to.eventually.not.exist

			describe 'given the token needs to be updated', ->

				beforeEach (done) ->
					@utilsShouldUpdateToken = m.sinon.stub(utils, 'shouldUpdateToken')
					@utilsShouldUpdateToken.returns(Promise.resolve(true))

					token.set(johnDoeFixture.token).nodeify(done)


				afterEach ->
					@utilsShouldUpdateToken.restore()

				describe 'given a working /whoami endpoint', ->

					beforeEach ->
						nock(settings.get('apiUrl'))
							.get('/whoami')
							.reply(200, janeDoeFixture.token)

					afterEach ->
						nock.cleanAll()

					it 'should refresh the token', (done) ->
						token.get().then (savedToken) ->
							m.chai.expect(savedToken).to.equal(johnDoeFixture.token)
							return request.send(url: '/foo')
						.then (response) ->
							m.chai.expect(response.body).to.equal('bar')
							return token.get()
						.then (savedToken) ->
							m.chai.expect(savedToken).to.equal(janeDoeFixture.token)
						.nodeify(done)

					# We could make the token request in parallel to avoid
					# having to wait for it to make the actual request.
					# Given the impact is minimal, the implementation aims
					# to simplicity.
					it 'should use the new token in the same request', (done) ->
						m.chai.expect(token.get()).to.eventually.equal(johnDoeFixture.token)
						request.send(url: '/foo').then (response) ->
							authorizationHeader = response.request.headers.Authorization
							m.chai.expect(authorizationHeader).to.equal("Bearer #{janeDoeFixture.token}")
						.nodeify(done)

				describe 'given /whoami returns 401', ->

					beforeEach ->
						nock(settings.get('apiUrl'))
							.get('/whoami')
							.reply(401, 'Unauthorized')

					afterEach ->
						nock.cleanAll()

					it 'should be rejected with an expiration error', ->
						promise = request.send(url: '/foo')
						m.chai.expect(promise).to.be.rejectedWith(errors.ResinExpiredToken)

					it 'should have the session token as an error attribute', (done) ->
						request.send(url: '/foo').catch (error) ->
							m.chai.expect(error.token).to.equal(johnDoeFixture.token)
						.nodeify(done)

					it 'should clear the token', (done) ->
						request.send(url: '/foo').catch ->
							token.has().then (hasToken) ->
								m.chai.expect(hasToken).to.be.false
						.nodeify(done)

				describe 'given /whoami returns a non 401 status code', ->

					beforeEach ->
						nock(settings.get('apiUrl'))
							.get('/whoami')
							.reply(500)

					afterEach ->
						nock.cleanAll()

					it 'should be rejected with a request error', ->
						promise = request.send(url: '/foo')
						m.chai.expect(promise).to.be.rejectedWith(errors.ResinRequestError)

	describe '.stream()', ->

		describe 'given a simple endpoint that responds with a string', ->

			beforeEach ->
				nock(settings.get('apiUrl')).get('/foo').reply(200, 'Lorem ipsum dolor sit amet')

			afterEach ->
				nock.cleanAll()

			describe 'given the token is always fresh', ->

				beforeEach ->
					@utilsShouldUpdateToken = m.sinon.stub(utils, 'shouldUpdateToken')
					@utilsShouldUpdateToken.returns(Promise.resolve(false))

				afterEach ->
					@utilsShouldUpdateToken.restore()

				describe 'given there is a token', ->

					beforeEach ->
						token.set(johnDoeFixture.token)

					it 'should send an Authorization header', (done) ->
						request.stream
							method: 'GET'
							url: '/foo'
						.then (stream) ->
							headers = stream.response.request.headers
							m.chai.expect(headers.Authorization).to.equal("Bearer #{johnDoeFixture.token}")
							rindle.extract(stream).nodeify(done)

				describe 'given there is no token', ->

					beforeEach ->
						token.remove()

					it 'should not send an Authorization header', (done) ->
						request.stream
							method: 'GET'
							url: '/foo'
						.then (stream) ->
							headers = stream.response.request.headers
							m.chai.expect(headers.Authorization).to.not.exist
							rindle.extract(stream).nodeify(done)
