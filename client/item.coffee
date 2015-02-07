# MODELS
Item = Backbone.Model.extend
  urlRoot: "/items"
  idAttribute: "_id"

# COLLECTIONS
Items = Backbone.Collection.extend
  model: Item
  url: "/items"


#########
# VIEWS #
#########

# default view for an item
ItemView = Backbone.View.extend
  
  initialize: ->
    @listenTo(@model, 'change', @render)

  render: ->
    template = Handlebars.compile($("#item-template").html())
    @$el.html(template(@model.attributes))
    this


# view for items in list format
ItemListView = Backbone.View.extend
  initialize: ->
    @listenTo @collection, 'add', @addItem

  addItem: (item) ->
    itemView = new ItemView(model: item)
    @$el.append(itemView.render().el)


# view for items on the show page
ItemShowView = Backbone.View.extend
  initialize: -> 
    @listenTo(@model, 'change', @render)

  render: ->
    console.log @model
    template = Handlebars.compile($("#show-template").html())
    @$el.html(template(@model.attributes))
    this


#########
# ROUTER #
#########
ItemRouter = Backbone.Router.extend
  routes:
    "": "index"
    "items/:id": "show"

  initialize: ->
    # nothing yet
    
  start: ->
    Backbone.history.start()

  index: ->
    items = new Items()
    itemListView = new ItemListView(collection: items)
    $("#container").html(itemListView.el)
    items.fetch()

  show: (id) ->
    item = new Item({_id: id})
    item.fetch()
    itemShowView = new ItemShowView(model: item)
    $("#container").html(itemShowView.el)

$ ->
  app = new ItemRouter().start()

