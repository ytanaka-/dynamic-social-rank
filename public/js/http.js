(function() {
  window.httpApiWrapper = function(currentStream) {
    return {
      getStreamItemList: function(callback) {
        return $.getJSON("/" + currentStream + "/list").success(function(data) {
          return callback(null, data);
        }).error(function(err) {
          return callback(err, null);
        });
      }
    };
  };

}).call(this);
