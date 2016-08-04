Promise = require('bluebird')
m = require('mochainon')
nock = require('nock')
zlib = require('zlib')
PassThrough = require('stream').PassThrough
token = require('resin-token')
settings = require('resin-settings-client')
rindle = require('rindle')
request = require('../lib/request')

describe 'Request (stream):', ->

	beforeEach ->
		token.remove()

	describe 'given a simple endpoint that responds with an error', ->

		beforeEach ->
			nock(settings.get('apiUrl')).get('/foo').reply(400, 'Something happened')

		afterEach ->
			nock.cleanAll()

		it 'should reject with the error message', ->
			promise = request.stream
				method: 'GET'
				url: '/foo'

			m.chai.expect(promise).to.be.rejectedWith('Something happened')

		it 'should have the status code in the error object', (done) ->
			request.stream
				method: 'GET'
				url: '/foo'
			.catch (error) ->
				m.chai.expect(error.statusCode).to.equal(400)
				done()

	describe 'given a simple endpoint that responds with a string', ->

		beforeEach ->
			nock(settings.get('apiUrl')).get('/foo').reply(200, 'Lorem ipsum dolor sit amet')

		afterEach ->
			nock.cleanAll()

		it 'should be able to pipe the response', (done) ->
			request.stream
				method: 'GET'
				url: '/foo'
			.then(rindle.extract).then (data) ->
				m.chai.expect(data).to.equal('Lorem ipsum dolor sit amet')
			.nodeify(done)

		it 'should be able to pipe the response after a delay', (done) ->
			request.stream
				method: 'GET'
				url: '/foo'
			.then (stream) ->
				return Promise.delay(200).return(stream)
			.then (stream) ->
				pass = new PassThrough()
				stream.pipe(pass)

				rindle.extract(pass).then (data) ->
					m.chai.expect(data).to.equal('Lorem ipsum dolor sit amet')
				.nodeify(done)

	describe 'given multiple endpoints', ->

		beforeEach ->
			nock(settings.get('apiUrl'))
				.get('/foo').reply(200, 'GET')
				.post('/foo').reply(200, 'POST')
				.put('/foo').reply(200, 'PUT')
				.patch('/foo').reply(200, 'PATCH')
				.delete('/foo').reply(200, 'DELETE')

		afterEach ->
			nock.cleanAll()

		describe 'given no method option', ->

			it 'should default to GET', (done) ->
				request.stream
					url: '/foo'
				.then(rindle.extract).then (data) ->
					m.chai.expect(data).to.equal('GET')
				.nodeify(done)

	describe 'given an gzip endpoint with a x-transfer-length header', ->

		beforeEach (done) ->
			message = 'Lorem ipsum dolor sit amet'
			zlib.gzip message, (error, compressedMessage) ->
				return done(error) if error?
				nock(settings.get('apiUrl'))
					.get('/foo')
					.reply 200, compressedMessage,
						'X-Transfer-Length': String(compressedMessage.length)
						'Content-Length': undefined
						'Content-Encoding': 'gzip'
				done()

		afterEach ->
			nock.cleanAll()

		it 'should correctly uncompress the body', (done) ->
			request.stream
				url: '/foo'
			.then (stream) ->
				return rindle.extract(stream)
			.then (data) ->
				m.chai.expect(data).to.equal('Lorem ipsum dolor sit amet')
				m.chai.expect(data.length).to.equal(26)
			.nodeify(done)

		it 'should set no .length property', (done) ->
			request.stream
				url: '/foo'
			.then (stream) ->
				m.chai.expect(stream.length).to.be.undefined
			.nodeify(done)

	describe 'given an gzip endpoint with a content-length header', ->

		beforeEach (done) ->
			message = 'Lorem ipsum dolor sit amet'
			zlib.gzip message, (error, compressedMessage) ->
				return done(error) if error?
				nock(settings.get('apiUrl'))
					.get('/foo')
					.reply 200, compressedMessage,
						'Content-Length': String(message.length)
						'Content-Encoding': 'gzip'
				done()

		afterEach ->
			nock.cleanAll()

		it 'should correctly uncompress the body', (done) ->
			request.stream
				url: '/foo'
			.then (stream) ->
				return rindle.extract(stream)
			.then (data) ->
				m.chai.expect(data).to.equal('Lorem ipsum dolor sit amet')
				m.chai.expect(data.length).to.equal(26)
			.nodeify(done)

	describe 'given an gzip endpoint with a content-length and x-transfer-length headers', ->

		beforeEach (done) ->
			message = 'Lorem ipsum dolor sit amet'
			zlib.gzip message, (error, compressedMessage) ->
				return done(error) if error?
				nock(settings.get('apiUrl'))
					.get('/foo')
					.reply 200, compressedMessage,
						'X-Transfer-Length': String(compressedMessage.length)
						'Content-Length': String(message.length)
						'Content-Encoding': 'gzip'
				done()

		afterEach ->
			nock.cleanAll()

		it 'should correctly uncompress the body', (done) ->
			request.stream
				url: '/foo'
			.then (stream) ->
				return rindle.extract(stream)
			.then (data) ->
				m.chai.expect(data).to.equal('Lorem ipsum dolor sit amet')
				m.chai.expect(data.length).to.equal(26)
			.nodeify(done)

	describe 'given an endpoint with an invalid content-length header', ->

		beforeEach ->
			message = 'Lorem ipsum dolor sit amet'
			nock(settings.get('apiUrl'))
				.get('/foo').reply(200, message, 'Content-Length': 'Hello')

		afterEach ->
			nock.cleanAll()

		it 'should become a stream with an undefined length property', (done) ->
			request.stream
				url: '/foo'
			.then (stream) ->
				m.chai.expect(stream.length).to.be.undefined
			.nodeify(done)

	describe 'given an endpoint with a content-type header', ->

		beforeEach ->
			message = 'Lorem ipsum dolor sit amet'
			nock(settings.get('apiUrl'))
				.get('/foo').reply(200, message, 'Content-Type': 'application/octet-stream')

		afterEach ->
			nock.cleanAll()

		it 'should become a stream with a mime property', (done) ->
			request.stream
				url: '/foo'
			.then (stream) ->
				m.chai.expect(stream.mime).to.equal('application/octet-stream')
			.nodeify(done)
