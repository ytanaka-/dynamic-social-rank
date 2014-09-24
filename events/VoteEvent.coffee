module.exports.VoteEvent = (app) ->
  debug  = require('debug')('events/vote')

  Stream = app.get("models").Stream
  Item   = app.get("models").Item
  Vote   = app.get("models").Vote

  # 命名が微妙すぎる
  voteByHttpRequest: (req,res,next) ->
    stream_title = req.params.stream
    type = req.body.type
    item_id = req.body.item_id
    if not item_id
      return res.send "item_idがありません"

    # ストリームのIDを取得する
    Stream.findByTitle stream_title,(err,stream)->
      if err
        debug err
        return res.status(500).send err

      # ストリームが見つからなかったとき
      if stream is null
        return res.send "該当するストリームが見つかりません"

      vote = new Vote
        item: item_id
        stream: stream._id
        type: type
      vote.save (err)->
        if err
          debug err
          return res.status(500).send err
        return res.send "complete vote"


  voteBySocket: (socket,io,data,room) ->
    item_id = data.item_id
    stream_title = room
    type = data.type

    # ストリームのIDを取得する
    Stream.findByTitle stream_title,(err,stream)->
      if err
        return debug err
      vote = new Vote
        item: item_id
        stream: stream
        type: type
      vote.save (err)->
        if err
          return debug err
        debug "complete vote | room = #{room}"
        socket.emit "notifyNewItems",null
        return socket.broadcast.to(room).emit "notifyNewItems",null

  # typeはup/downのいずれか
  vote: (item_id,stream,type,callback)->
    vote = new Vote
      item: item_id
      stream: stream._id
      type: type
    vote.save (err)->
      if err
        debug err
        return callback err
      callback null