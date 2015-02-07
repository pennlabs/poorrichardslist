Item = Backbone.Model.extend
  urlRoot: "/items"

ItemView = Backbone.View.extend
  initialize: ->
    @listenTo(@model, 'change', @render)

  render: ->
    template = Handlebars.compile($("#item-template").html())
    @$el.html(template(@model.attributes))
    this

ItemList = Backbone.Collection.extend
  model: Item
  url: "/items"

ItemListView = Backbone.View.extend
  initialize: ->
  #   @listenTo(@collection, 'change', @render)
    # @collection.on 'sync', @render, this
    @collection.on 'add', @addItem, this

  # render: ->
    # @collection.forEach @addItem, this

  addItem: (item) ->
    itemView = new ItemView(model: item)
    @$el.append(itemView.render().el)

$ ->
  list = new ItemList()
  listView = new ItemListView(collection: list)
  list.fetch()
  $("#item-list").html(listView.el)

