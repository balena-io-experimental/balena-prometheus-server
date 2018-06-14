Promise = require('bluebird')
m = require('mochainon')
zlib = require('zlib')
PassThrough = require('stream').PassThrough
rindle = require('rindle')

{ auth, request, fetchMock, IS_BROWSER } = require('./setup')()

describe 'Request (stream):', ->
	return if IS_BROWSER

	beforeEach ->
		auth.removeKey()

	describe 'given a simple endpoint that responds with an error', ->

		beforeEach ->
			fetchMock.get 'https://api.resin.io/foo',
				status: 400
				body: 'Something happened'

		afterEach ->
			fetchMock.restore()

		it 'should reject with the error message', ->
			promise = request.stream
				method: 'GET'
				baseUrl: 'https://api.resin.io'
				url: '/foo'

			m.chai.expect(promise).to.be.rejectedWith('Something happened')

		it 'should have the status code in the error object', ->
			request.stream
				method: 'GET'
				baseUrl: 'https://api.resin.io'
				url: '/foo'
			.catch (error) ->
				m.chai.expect(error.statusCode).to.equal(400)

	describe 'given a simple endpoint that responds with a string', ->

		beforeEach ->
			fetchMock.get('https://api.resin.io/foo', 'Lorem ipsum dolor sit amet')

		afterEach ->
			fetchMock.restore()

		it 'should be able to pipe the response', ->
			request.stream
				method: 'GET'
				baseUrl: 'https://api.resin.io'
				url: '/foo'
			.then(rindle.extract).then (data) ->
				m.chai.expect(data).to.equal('Lorem ipsum dolor sit amet')

		it 'should be able to pipe the response after a delay', ->
			request.stream
				method: 'GET'
				baseUrl: 'https://api.resin.io'
				url: '/foo'
			.then (stream) ->
				return Promise.delay(200).return(stream)
			.then (stream) ->
				pass = new PassThrough()
				stream.pipe(pass)

				rindle.extract(pass).then (data) ->
					m.chai.expect(data).to.equal('Lorem ipsum dolor sit amet')

	describe 'given multiple endpoints', ->

		beforeEach ->
			fetchMock.get('https://api.resin.io/foo', body: 'GET')
			fetchMock.post('https://api.resin.io/foo', body: 'POST')
			fetchMock.put('https://api.resin.io/foo', body: 'PUT')
			fetchMock.patch('https://api.resin.io/foo', body: 'PATCH')
			fetchMock.delete('https://api.resin.io/foo', body: 'DELETE')

		afterEach ->
			fetchMock.restore()

		describe 'given no method option', ->

			it 'should default to GET', ->
				request.stream
					baseUrl: 'https://api.resin.io'
					url: '/foo'
				.then(rindle.extract).then (data) ->
					m.chai.expect(data).to.equal('GET')

	describe 'given an gzip endpoint with a x-transfer-length header', ->

		beforeEach (done) ->
			message = 'Lorem ipsum dolor sit amet'
			zlib.gzip message, (error, compressedMessage) ->
				return done(error) if error?
				fetchMock.get 'https://api.resin.io/foo',
					status: 200
					body: compressedMessage
					sendAsJson: false
					headers:
						'Content-Type': 'text/plain'
						'X-Transfer-Length': '' + compressedMessage.length
						'Content-Length': undefined
						'Content-Encoding': 'gzip'
				done()

		afterEach ->
			fetchMock.restore()

		it 'should correctly uncompress the body', ->
			request.stream
				baseUrl: 'https://api.resin.io'
				url: '/foo'
			.then (stream) ->
				return rindle.extract(stream)
			.then (data) ->
				m.chai.expect(data).to.equal('Lorem ipsum dolor sit amet')
				m.chai.expect(data.length).to.equal(26)

		it 'should set no .length property', ->
			request.stream
				baseUrl: 'https://api.resin.io'
				url: '/foo'
			.then (stream) ->
				m.chai.expect(stream.length).to.be.undefined

	describe 'given an gzip endpoint with a content-length header', ->

		beforeEach (done) ->
			message = 'Lorem ipsum dolor sit amet'
			zlib.gzip message, (error, compressedMessage) ->
				return done(error) if error?
				fetchMock.get 'https://api.resin.io/foo',
					status: 200
					body: compressedMessage
					sendAsJson: false
					headers:
						'Content-Type': 'text/plain'
						'Content-Length': '' + message.length
						'Content-Encoding': 'gzip'
				done()

		afterEach ->
			fetchMock.restore()

		it 'should correctly uncompress the body', ->
			request.stream
				baseUrl: 'https://api.resin.io'
				url: '/foo'
			.then (stream) ->
				return rindle.extract(stream)
			.then (data) ->
				m.chai.expect(data).to.equal('Lorem ipsum dolor sit amet')
				m.chai.expect(data.length).to.equal(26)

	describe 'given an gzip endpoint with a content-length and x-transfer-length headers', ->

		beforeEach (done) ->
			message = 'Lorem ipsum dolor sit amet'
			zlib.gzip message, (error, compressedMessage) ->
				return done(error) if error?
				fetchMock.get 'https://api.resin.io/foo',
					status: 200
					sendAsJson: false
					body: compressedMessage
					headers:
						'Content-Type': 'text/plain'
						'X-Transfer-Length': '' + compressedMessage.length
						'Content-Length': '' + message.length
						'Content-Encoding': 'gzip'
				done()

		afterEach ->
			fetchMock.restore()

		it 'should correctly uncompress the body', ->
			request.stream
				baseUrl: 'https://api.resin.io'
				url: '/foo'
			.then (stream) ->
				return rindle.extract(stream)
			.then (data) ->
				m.chai.expect(data).to.equal('Lorem ipsum dolor sit amet')
				m.chai.expect(data.length).to.equal(26)

	describe 'given an endpoint with an invalid content-length header', ->

		beforeEach ->
			message = 'Lorem ipsum dolor sit amet'
			fetchMock.get 'https://api.resin.io/foo',
				status: 200
				body: message
				headers:
					'Content-Length': 'Hello'

		afterEach ->
			fetchMock.restore()

		it 'should become a stream with an undefined length property', ->
			request.stream
				baseUrl: 'https://api.resin.io'
				url: '/foo'
			.then (stream) ->
				m.chai.expect(stream.length).to.be.undefined

	describe 'given an endpoint with a content-type header', ->

		beforeEach ->
			message = 'Lorem ipsum dolor sit amet'
			fetchMock.get 'https://api.resin.io/foo',
				status: 200
				body: message
				headers:
					'Content-Type': 'application/octet-stream'

		afterEach ->
			fetchMock.restore()

		it 'should become a stream with a mime property', ->
			request.stream
				baseUrl: 'https://api.resin.io'
				url: '/foo'
			.then (stream) ->
				m.chai.expect(stream.mime).to.equal('application/octet-stream')
