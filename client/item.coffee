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

  render: ->
    template = Handlebars.compile($("#item-list-template").html())
    @$el.html(template())
    this

  addItem: (item) ->
    itemView = new ItemView(model: item)
    @$el.append(itemView.render().el)

# view for items on the show page
ItemShowView = Backbone.View.extend
  initialize: ->
    @listenTo(@model, 'change', @render)

  render: ->
    console.log @model
    template = Handlebars.compile($("#item-show-template").html())
    @$el.html(template(@model.attributes))
    this

ItemFormView = Backbone.View.extend
  events:
    submit: "save"

  render: ->
    template = Handlebars.compile($("#item-form-template").html())
    @$el.html(template())
    this

  save: (e) ->
    e.preventDefault()
    data =
      name: @$('input[name=name]').val()
      desc: @$('input[name=desc]').val()
      price: @$('input[name=price]').val()
      tags: @$('input[name=tags]').val()
    @model.save data,
      success: (model, res, options) ->
        Backbone.history.navigate("#items/#{res[0]._id}", {trigger: true})
      error: (model, xhr, options) ->
        errors = JSON.parse(xhr.responseText).errors
        alert "Item submit errors: #{errors}"


#########
# ROUTER #
#########
ItemRouter = Backbone.Router.extend
  routes:
    "": "index"
    "items/:id": "show"
    "upload": "new"

  initialize: ->
    # nothing yet

  start: ->
    Backbone.history.start()

  index: ->
    items = new Items()
    itemListView = new ItemListView(collection: items)
    $("#container").html(itemListView.render().el)
    items.fetch()

  show: (id) ->
    item = new Item({_id: id})
    item.fetch()
    itemShowView = new ItemShowView(model: item)
    $("#container").html(itemShowView.el)

  new: ->
    item = new Item()
    itemFormView = new ItemFormView(model: item)
    $("#container").html(itemFormView.render().el)

$ ->
  app = new ItemRouter().start()

