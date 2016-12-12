client = require('socket.io-client')
serialport = require('serialport')
fs = require('fs')
keypress = require('keypress')

main = {}

class SocketManager
  constructor: ->
    socket = client.connect('http://smurakami.com:61130')

    socket.on 'connect', ->
      console.log 'connected!'

    socket.on 'greeting', (data, fn) ->
      answer = 
        type: 'output'
      fn(answer)

    socket.on 'somen', (data) ->
      console.log "somen output! #{data}"
      main.arduino.move()
      setTimeout -> 
        main.arduino.stop()
      , 500

class Arduino
  constructor: ->
    @startSerialport()

  getPortname: ->
    devList = fs.readdirSync('/dev')
    portName = ''
    i = 0
    while i < devList.length
      port = devList[i]
      if port.match(/cu.usbserial|cu.usbmodem/)
        portName = '/dev/' + port
        break
      i++

    console.log devList
    console.log portName

    return portName

  move: ->
    @sp.write 'h'
  stop: ->
    @sp.write 'l'

  startSerialport: ->
    portName = @getPortname()
    console.log portName
    @sp = new serialport(portName, parser: serialport.parsers.readline('\n'))
    @sp.on 'open', ->
    @sp.on 'data', (data) ->
      console.log data

class KeyManager
  constructor: ->
    @listenKeyevent()

  listenKeyevent: ->
    keypress(process.stdin)
    process.stdin.on 'keypress', (ch, key) =>
      if key? and key.ctrl and key.name == 'c'
        process.stdin.pause()
        process.exit()

      if key? and key.name == 'h'
        main.arduino.move()

      if key? and key.name == 'l'
        main.arduino.stop()

    process.stdin.setRawMode(true)
    process.stdin.resume()


main.arduino = new Arduino()
main.socketManager = new SocketManager()
main.keyManager = new KeyManager()


