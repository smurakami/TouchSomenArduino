client = require('socket.io-client')

makeDummy = (index) ->
  socket = client.connect('http://localhost:61130')

  socket.on 'connect', ->
    console.log 'yea!!'
    socket.send 'how are you?'

  socket.on 'greeting', (data, fn) ->
    answer = 
      type: 'normal'
      isDummy: true
      index: index
    fn(answer)

  socket.on 'somen', (data) ->
    console.log data
    # そうめん流れる
    width = 45 + 616
    speed = 4.0
    fps = 60
    setTimeout ->
      socket.emit 'somen', data
    , width / (speed * fps) * 1000

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

exports
