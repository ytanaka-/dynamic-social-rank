(function() {
  window.StreamItemView = Backbone.Marionette.ItemView.extend({
    template: "#streamItemTemplate",
    events: {
      "click .up-button": "upvote",
      "click .down-button": "downvote"
    },
    upvote: function() {
      return window.ioApi.vote_post(this.model.attributes._id, "up");
    },
    downvote: function() {
      return window.ioApi.vote_post(this.model.attributes._id, "down");
    }
  });

  window.StreamItemsView = Backbone.Marionette.CollectionView.extend({
    childView: StreamItemView
  });

}).call(this);
