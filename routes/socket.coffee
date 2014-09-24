module.exports = exports = (app,io,socket,room) ->

  # include events
  Events       = app.get('events')
  HelperEvent  = Events.HelperEvent app
  StreamEvent  = Events.StreamEvent app
  ItemEvent    = Events.ItemEvent app
  VoteEvent    = Events.VoteEvent app

  socket.on "getStreamItem", (data) -> StreamEvent.getStreamItem socket,data,room

  socket.on "post_item", (data) -> StreamEvent.addItemBySocket socket,io,data,room
  socket.on "vote", (data) -> VoteEvent.voteBySocket socket,io,data,room