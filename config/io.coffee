#
# socket.io用のイベント設定
#

module.exports = (app, server) ->
  debug = require('debug')('config/io')
  async = require 'async'
  _     = require 'underscore'
  path = require 'path'


  # setup socket.io
  io = (require 'socket.io').listen server

  # Connection Start and Routing Setup
  io.sockets.on "connection", (socket) ->
    console.log "socket.io connected from client--------"

    room = socket.handshake.query.stream
    console.log "connect at #{room}"

    ## 同じストリームを見ているクライアント毎にroomで分ける
    socket.join room

    socket.once 'disconnect', ->
      console.log "disconnect at #{room}"
      socket.leave room

    # on Error
    socket.on "error", (exc)->
      debug exc

    # Use Router
    (require path.resolve('routes','socket')) app,io,socket,room