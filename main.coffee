#!/usr/bin/env coffee

String.prototype.times = (n) ->
  s = ''
  for i in [0...n]
    s += this
  return s

serialport = require('serialport')
fs = require('fs')
# notifier = require('node-notifier')

# find Arduino port
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

# begin listening...
sp = new serialport(portName, parser: serialport.parsers.readline('\n'))

isHigh = false

sp.on 'open', ->
  console.log 'open'
  setInterval ->
    if isHigh
      sp.write 'h'
    else
      sp.write 'l'


    isHigh = not isHigh
  , 1000


sp.on 'data', (data) ->
  console.log data
