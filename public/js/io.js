(function() {
  window.ioApiWrapper = function(socket) {
    return {
      notifyGetStream: function(currentStream) {
        return socket.emit("getStreamItem", function(data) {
          return console.log("emitted getStreamItem");
        });
      },
      newStreamItems: function(currentStream, callback) {
        return socket.on("newStreamItems", function(data) {
          return callback(data);
        });
      },
      vote_post: function(item_id, type) {
        return socket.emit('vote', {
          item_id: item_id,
          type: type
        });
      }
    };
  };

}).call(this);
