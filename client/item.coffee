 # MODELS
App.Models.Item = Backbone.Model.extend
  urlRoot: "/items"
  idAttribute: "_id"

# COLLECTIONS
App.Collections.Items = Backbone.Collection.extend
  model: App.Models.Item
  url: "/items"

#########
# VIEWS #
#########

# default view for an item
App.Views.ItemView = Backbone.View.extend
  initialize: ->
    @listenTo @model, 'change', @render

  render: ->
    template = Handlebars.compile($("#item-template").html())
    @$el.html(template(@model.attributes))
    this

# view for items in list format
App.Views.ItemListView = Backbone.View.extend
  initialize: ->
    @listenTo @collection, 'add', @addItem
    @listenTo App.PubSub, 'search', @displayItems
    @listenTo App.PubSub, 'unsearch', @displayAll

  render: ->
    template = Handlebars.compile($("#item-list-template").html())
    @$el.html(template())
    this

  displayItems: (itemIds) ->
    items = @collection.filter (item) -> _.contains itemIds, item.id
    @$el.empty()
    @addAll items

  displayAll: ->
    @$el.empty()
    @addAll @collection.models

  addItem: (item) ->
    App.Indices.ItemIndex.add(item.attributes)
    itemView = new App.Views.ItemView(model: item)
    @$el.append(itemView.render().el)

  addAll: (items) ->
    for item in items
      @addItem item

# view for items on the show page
App.Views.ItemShowView = Backbone.View.extend
  initialize: ->
    @listenTo(@model, 'change', @render)

  render: ->
    template = Handlebars.compile($("#item-show-template").html())
    @$el.html(template(@model.attributes))
    this

App.Views.ItemFormView = Backbone.View.extend
  id: "item-form"

  initialize: (options) ->
    @model = options.model
    @type = options.type
    
  events:
    submit: "save"

  render: ->
    template = Handlebars.compile($("#item-form-template-main").html())
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
    "upload(/:type)": "new"

  initialize: ->
    # nothing yet

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

  new: (type) ->
    item = new App.Models.Item()
    itemFormView = new App.Views.ItemFormView(model: item, type: type)
    $("#container").html(itemFormView.render().el)

$ ->
  app = new ItemRouter().start()

