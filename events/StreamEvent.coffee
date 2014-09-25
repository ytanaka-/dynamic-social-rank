module.exports.StreamEvent = (app) ->

  async  = require 'async'
  _      = require 'underscore'
  debug  = require('debug')('events/stream')

  Stream = app.get("models").Stream
  Item   = app.get("models").Item
  Vote   = app.get("models").Vote

  ItemEvent = app.get('events').ItemEvent app
  HelperEvent = app.get('events').HelperEvent app

  index: (req,res,next) ->
    stream_title = req.params.stream
    Stream.findByTitle stream_title,(err,stream)->
      if err
        return res.status(500).send err

      if stream is null
        return res.send "該当するストリームが見つかりません"

      return res.render 'stream',
        { stream_title: stream_title }


  # 該当stream(に登録されているitem)をjsonで返す
  list: (req,res,next) ->
    stream_title = req.params.stream
    Stream.findByTitle stream_title,(err,stream)->
      if err
        debug err
        return res.send 400,'Internal Server Error'

      if stream is null
        return res.send 404,'Stream is not Found '

      HelperEvent.createDynamicRank stream,(err,items)->
        if err
          debug err
          return res.send 400,'Internal Server Error'

        return res.json {
          stream_title: stream_title
          items: items
        }


  createStream: (req,res,next) ->
    title = req.params.stream
    description = req.body.description
    if not title or not description
      return res.send "パラメータが空または不正です"
    stream = new Stream
      title: title
      description: description
    stream.save (err)->
      if err
        return res.status(500).send err
      return res.send "ストリーム（#{title}）を作成しました"

  # post_urlとstreamのtitleを元にitemを生成し、DBに登録
  addItemByStream: (req,res,next) ->
    post_item_url = req.body.item_url
    stream_title = req.params.stream
    Stream.findByTitle stream_title,(err,stream)->
      if err
        return res.status(500).send err

      # ストリームが見つからなかったとき
      if stream is null
        return res.send "該当するストリームが見つかりません"

      ItemEvent.addItem post_item_url,stream,(err)->
        return res.send "登録完了"

  getStreamItem: (socket,data,room)->
    stream_title = room
    Stream.findByTitle stream_title,(err,stream)->
      if err
        return debug err

      # ストリームが見つからなかったとき
      if stream is null
        return debug "該当するストリームが見つかりません"

      HelperEvent.createDynamicRank stream,(err,items)->
        if err
          return debug err

        return socket.emit "newStreamItems",
          stream_title: stream_title
          items: items

  # post_urlとstreamのtitleを元にitemを生成し、DBに登録
  addItemBySocket: (socket,io,data,room) ->
    post_item_url = data.post_item_url
    stream_title = room
    Stream.findByTitle stream_title,(err,stream)->
      if err
        return console.log err

      # ストリームが見つからなかったとき
      if stream is null
        return console.log "該当するストリームが見つかりません"

      ItemEvent.addItem post_item_url,stream,(err)->
        if err
          return debug err
        socket.emit "notifyNewItems",null
        return socket.broadcast.to(room).emit "notifyNewItems",null
