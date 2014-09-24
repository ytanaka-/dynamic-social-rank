# Model
window.StreamItem = Backbone.Model.extend
  initialize:(attr,opts)->
    this.set "item",attr

# Collection
window.StreamItems = Backbone.Collection.extend StreamItem