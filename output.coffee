client = require('socket.io-client')


socket = client.connect('http://localhost:61130')

socket.on 'connect', ->
  console.log 'yea!!'
  socket.send 'how are you?'

socket.on 'greeting', (data, fn) ->
	answer = 
		type: 'output'
	fn(answer)

socket.on 'somen', (data) ->
	console.log "somen output! #{data}"


