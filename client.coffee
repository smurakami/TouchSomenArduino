client = require('socket.io-client')

socket = client.connect('http://localhost:61130')

socket.on 'connect', ->
  console.log 'yea!!'
  socket.send 'how are you?'

socket.on 'greeting', (data, fn) ->
  answer = 
    type: 'normal'
  fn(answer)

socket.on 'somen', (data) ->
  console.log data
  # そうめん流れる
  setTimeout ->
    socket.emit 'somen', data
  , 1000


keypress = require('keypress')
keypress(process.stdin)

process.stdin.on 'keypress', (ch, key) ->
  if key? and key.ctrl and key.name == 'c'
    process.stdin.pause()
    process.exit()

  console.log "got keypress: #{key.name}"
  if key? and key.name == 's'
    socket.emit 'somen', {}

process.stdin.setRawMode(true);
process.stdin.resume();

