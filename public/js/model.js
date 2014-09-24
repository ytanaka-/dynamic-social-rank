(function() {
  window.StreamItem = Backbone.Model.extend({
    initialize: function(attr, opts) {
      return this.set("item", attr);
    }
  });

  window.StreamItems = Backbone.Collection.extend(StreamItem);

}).call(this);
