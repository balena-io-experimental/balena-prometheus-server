ReadableStream = require('stream').Readable
Promise = require('bluebird')
{ Headers } = require('fetch-ponyfill')({ Promise })
m = require('mochainon')
johnDoeFixture = require('./tokens.json').johndoe
utils = require('../lib/utils')

{ auth } = require('./setup')()

describe 'Utils:', ->

	describe '.shouldRefreshKey()', ->

		describe 'given an API key ', ->

			beforeEach ->
				@tokenHasKeyStub = m.sinon.stub(auth, 'hasKey')
				@tokenHasKeyStub.returns(Promise.resolve(true))
				@tokenGetTypeStub = m.sinon.stub(auth, 'getType')
				@tokenGetTypeStub.returns(Promise.resolve('APIKey'))

			afterEach ->
				@tokenHasKeyStub.restore()
				@tokenGetTypeStub.restore()

			it 'should return false', ->
				m.chai.expect(utils.shouldRefreshKey(auth)).to.eventually.be.false

		describe 'given the token is older than the specified validity time', ->

			beforeEach ->
				@tokenGetAgeStub = m.sinon.stub(auth, 'getAge')
				@tokenGetAgeStub.returns(Promise.resolve(utils.TOKEN_REFRESH_INTERVAL + 1))
				@tokenHasKeyStub = m.sinon.stub(auth, 'hasKey')
				@tokenHasKeyStub.returns(Promise.resolve(true))
				@tokenGetTypeStub = m.sinon.stub(auth, 'getType')
				@tokenGetTypeStub.returns(Promise.resolve('JWT'))

			afterEach ->
				@tokenGetAgeStub.restore()
				@tokenHasKeyStub.restore()
				@tokenGetTypeStub.restore()

			it 'should return true', ->
				m.chai.expect(utils.shouldRefreshKey(auth)).to.eventually.be.true

		describe 'given the token is newer than the specified validity time', ->

			beforeEach ->
				@tokenGetAgeStub = m.sinon.stub(auth, 'getAge')
				@tokenGetAgeStub.returns(Promise.resolve(utils.TOKEN_REFRESH_INTERVAL - 1))
				@tokenHasKeyStub = m.sinon.stub(auth, 'hasKey')
				@tokenHasKeyStub.returns(Promise.resolve(true))
				@tokenGetTypeStub = m.sinon.stub(auth, 'getType')
				@tokenGetTypeStub.returns(Promise.resolve('JWT'))

			afterEach ->
				@tokenGetAgeStub.restore()
				@tokenHasKeyStub.restore()
				@tokenGetTypeStub.restore()

			it 'should return false', ->
				m.chai.expect(utils.shouldRefreshKey(auth)).to.eventually.be.false

		describe 'given the token is equal to the specified validity time', ->

			beforeEach ->
				@tokenGetAgeStub = m.sinon.stub(auth, 'getAge')
				@tokenGetAgeStub.returns(Promise.resolve(utils.TOKEN_REFRESH_INTERVAL))
				@tokenHasKeyStub = m.sinon.stub(auth, 'hasKey')
				@tokenHasKeyStub.returns(Promise.resolve(true))
				@tokenGetTypeStub = m.sinon.stub(auth, 'getType')
				@tokenGetTypeStub.returns(Promise.resolve('JWT'))

			afterEach ->
				@tokenGetAgeStub.restore()
				@tokenHasKeyStub.restore()
				@tokenGetTypeStub.restore()

			it 'should return true', ->
				m.chai.expect(utils.shouldRefreshKey(auth)).to.eventually.be.true

		describe 'given no token', ->

			beforeEach ->
				@tokenHasKeyStub = m.sinon.stub(auth, 'hasKey')
				@tokenHasKeyStub.returns(Promise.resolve(false))

			afterEach ->
				@tokenHasKeyStub.restore()

			it 'should return false', ->
				m.chai.expect(utils.shouldRefreshKey(auth)).to.eventually.be.false

	describe '.getAuthorizationHeader()', ->

		describe 'given there is a token', ->

			beforeEach  ->
				auth.setKey(johnDoeFixture.token)

			it 'should eventually become the authorization header', ->
				m.chai.expect(utils.getAuthorizationHeader(auth)).to.eventually.equal("Bearer #{johnDoeFixture.token}")

		describe 'given there is no token', ->

			beforeEach ->
				auth.removeKey()

			it 'should eventually be undefined', ->
				m.chai.expect(utils.getAuthorizationHeader(auth)).to.eventually.be.undefined

	describe '.getErrorMessageFromResponse()', ->

		describe 'given no body', ->

			beforeEach ->
				@response = {}

			it 'should return a generic error message', ->
				error = utils.getErrorMessageFromResponse(@response)
				m.chai.expect(error).to.equal('The request was unsuccessful')

		describe 'given a response with an error object', ->

			beforeEach ->
				@response =
					body:
						error:
							text: 'An error happened'

			it 'should print the error.text property', ->
				error = utils.getErrorMessageFromResponse(@response)
				m.chai.expect(error).to.equal('An error happened')

		describe 'given a response with a string error property', ->

			beforeEach ->
				@response =
					body:
						error: 'errorTypeSlug'
						message: 'More details about the error'

			it 'should print the error.text property', ->
				error = utils.getErrorMessageFromResponse(@response)
				m.chai.expect(error).to.deep.equal(@response.body)

		describe 'given a response without an error object', ->

			beforeEach ->
				@response =
					body: 'An error happened'

			it 'should print the body', ->
				error = utils.getErrorMessageFromResponse(@response)
				m.chai.expect(error).to.equal('An error happened')

	describe '.isErrorCode()', ->

		it 'should return false for 200', ->
			m.chai.expect(utils.isErrorCode(200)).to.be.false

		it 'should return false for 399', ->
			m.chai.expect(utils.isErrorCode(399)).to.be.false

		it 'should return true for 400', ->
			m.chai.expect(utils.isErrorCode(400)).to.be.true

		it 'should return true for 500', ->
			m.chai.expect(utils.isErrorCode(500)).to.be.true

	describe '.isResponseCompressed()', ->

		it 'should return false if Content-Encoding is gzip', ->
			response =
				headers: new Headers
					'content-encoding': 'gzip'

			m.chai.expect(utils.isResponseCompressed(response)).to.be.true

		it 'should return false if Content-Encoding is not set', ->
			response =
				headers: new Headers({})

			m.chai.expect(utils.isResponseCompressed(response)).to.be.false

	describe '.getResponseLength()', ->

		describe 'given a response with only an X-Transfer-Length header', ->

			beforeEach ->
				@response =
					headers: new Headers
						'x-transfer-length': '1234'

			it 'should return the value of X-Transfer-Length as compressed length', ->
				m.chai.expect(utils.getResponseLength(@response).compressed).to.equal(1234)

			it 'should set the uncompressed length to undefined', ->
				m.chai.expect(utils.getResponseLength(@response).uncompressed).to.be.undefined

		describe 'given a response with only a Content-Length header', ->

			beforeEach ->
				@response =
					headers: new Headers
						'content-length': '1234'

			it 'should return the value of Content-Length as uncompressed length', ->
				m.chai.expect(utils.getResponseLength(@response).uncompressed).to.equal(1234)

			it 'should set the compressed length to undefined', ->
				m.chai.expect(utils.getResponseLength(@response).compressed).to.be.undefined

		describe 'given a response with an empty X-Transfer-Length header', ->

			beforeEach ->
				@response =
					headers: new Headers
						'x-transfer-length': ''

			it 'should set the compressed to undefined', ->
				m.chai.expect(utils.getResponseLength(@response).compressed).to.undefined

		describe 'given a response with an empty Content-Length header', ->

			beforeEach ->
				@response =
					headers: new Headers
						'content-length': ''

			it 'should set the uncompressed to undefined', ->
				m.chai.expect(utils.getResponseLength(@response).uncompressed).to.undefined

		describe 'given a response with an invalid X-Transfer-Length header', ->

			beforeEach ->
				@response =
					headers: new Headers
						'x-transfer-length': 'asdf'

			it 'should set the compressed to undefined', ->
				m.chai.expect(utils.getResponseLength(@response).compressed).to.undefined

		describe 'given a response with an invalid Content-Length header', ->

			beforeEach ->
				@response =
					headers: new Headers
						'content-length': 'asdf'

			it 'should set the uncompressed to undefined', ->
				m.chai.expect(utils.getResponseLength(@response).uncompressed).to.undefined
