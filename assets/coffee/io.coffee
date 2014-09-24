window.ioApiWrapper = (socket)->

  notifyGetStream: (currentStream)->
    socket.emit "getStreamItem",(data)->
      console.log "emitted getStreamItem"

  newStreamItems: (currentStream,callback)->
    socket.on "newStreamItems",(data)->
      callback data

  vote_post: (item_id,type) ->
    socket.emit 'vote',
    {
      item_id: item_id
      type: type
    }