App.Router = Backbone.Router.extend
  routes:
    "": "index"
    "items/:id": "show"
    "upload": "new"

  start: ->
    Backbone.history.start()

  index: ->
    items = new App.Collections.Items()
    itemListView = new App.Views.ItemListView(collection: items)
    tags = new App.Collections.Tags()
    tagListView = new App.Views.TagListView(collection: tags)
    listingView = new App.Views.ListingView
      itemListView: itemListView
      tagListView: tagListView
      searchBarView: new App.Views.SearchBarView
    $("#container").html(listingView.render().el)
    items.fetch()
    tags.fetch()

  show: (id) ->
    item = new App.Models.Item({_id: id})
    item.fetch()
    itemShowView = new App.Views.ItemShowView(model: item)
    $("#container").html(itemShowView.el)

  new: ->
    item = new App.Models.Item()
    itemFormView = new App.Views.ItemFormView(model: item)
    $("#container").html(itemFormView.render().el)

$ ->
  app = new App.Router().start()

