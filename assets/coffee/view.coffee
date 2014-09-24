window.StreamItemView = Backbone.Marionette.ItemView.extend
  template:"#streamItemTemplate"
  events:
    "click .up-button":"upvote"
    "click .down-button":"downvote"

  upvote:->
    window.ioApi.vote_post @model.attributes._id,"up"

  downvote:->
    window.ioApi.vote_post @model.attributes._id,"down"

window.StreamItemsView = Backbone.Marionette.CollectionView.extend
  childView:StreamItemView