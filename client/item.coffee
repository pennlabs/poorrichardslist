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

ItemRouter = Backbone.Router.extend
  routes:
    "": "index"
    "items/:id": "show"

  initialize: ->
    @itemList = new ItemList()
    @itemListView = new ItemListView(collection: @itemList)
    $("#item-list").html(@itemListView.el)

  start: ->
    Backbone.history.start({pushState: true})

  index: ->
    @itemList.fetch()

$ ->
  app = new ItemRouter().start()

