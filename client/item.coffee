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
    @listenTo App.PubSub, 'tagFilter', @displayItems
    @listenTo App.PubSub, 'displayAll', @displayAll

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

