#!/usr/bin/env coffee

serialport = require('serialport')
fs = require('fs')
keypress = require('keypress')

class ArduinoOut
  constructor: ->
    @startSerialport()
    @listenKeyevent()

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

  startSerialport: ->
    portName = @getPortname()
    console.log portName
    @sp = new serialport(portName, parser: serialport.parsers.readline('\n'))
    @sp.on 'open', ->
    @sp.on 'data', (data) ->
      console.log data

  listenKeyevent: ->
    keypress(process.stdin)
    process.stdin.on 'keypress', (ch, key) =>
      if key? and key.ctrl and key.name == 'c'
        process.stdin.pause()
        process.exit()

      if key? and key.name == 'h'
        @sp.write 'h'

      if key? and key.name == 'l'
        @sp.write 'l'

    process.stdin.setRawMode(true);
    process.stdin.resume();

new ArduinoOut()

