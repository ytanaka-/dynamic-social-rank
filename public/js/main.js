(function() {
  $(function() {

    /* Configration & Initialize */
    var Main, httpApi, ioApi, refresh, socket, stream, streamItems, streamItemsView;
    _.templateSettings = {
      interpolate: /\{\{(.+?)\}\}/g
    };
    stream = window.location.pathname.substr(1);
    socket = io.connect("" + location.protocol + "//" + location.hostname + "?stream=" + stream);
    httpApi = httpApiWrapper(stream);
    ioApi = ioApiWrapper(socket);
    window.ioApi = ioApi;
    streamItems = new StreamItems();
    streamItemsView = new StreamItemsView({
      collection: streamItems
    });
    refresh = function(callback) {
      return httpApi.getStreamItemList(function(err, data) {
        var item, newStreamItems, _i, _len, _ref;
        if (err) {
          console.error(err);
          return alert("Initialize Error.Please Reload.");
        }
        newStreamItems = [];
        _ref = data.items;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          item = _ref[_i];
          newStreamItems.push(new StreamItem(item));
        }
        streamItems.reset(newStreamItems);
        if (callback) {
          return callback();
        }
      });
    };
    Main = new Backbone.Marionette.Application();
    Main.addRegions({
      items: '#Items'
    });
    Main.addInitializer(function(options) {
      return Main.items.show(streamItemsView);
    });
    if (!_.isEmpty(stream)) {
      refresh(function() {
        return Main.start();
      });
    }
    socket.on("notifyNewItems", function(data) {
      return refresh();
    });
    return $("form").submit(function() {
      var post_item_url;
      post_item_url = $('#m').val();
      if (post_item_url) {
        socket.emit('post_item', {
          post_item_url: post_item_url
        });
        $('#m').val('');
      }
      return false;
    });
  });

}).call(this);
