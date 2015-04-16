# MODELS
App.Models.Item = Backbone.Model.extend
  urlRoot: "/items"
  idAttribute: "_id"
  parse: (response) ->
    if response.type == "sublets"
      response.normalizedTitle = response.location
      response.normalizedPrice = "#{response.rent} / month"
    else
      response.normalizedTitle = response.name
      response.normalizedPrice = response.price
    response

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
    @$el.html template(@model.attributes)
    this

# view for items in list format
App.Views.ItemListView = Backbone.View.extend
  className: "grid photo-content"
  initialize: ->
    @listenTo @collection, 'add', @addItem
    @listenTo App.PubSub, 'search', @setSearchScope
    @listenTo App.PubSub, 'nosearch', @resetSearchScope
    @listenTo App.PubSub, 'tagFilter', @setTagScope
    @listenTo App.PubSub, 'noTagFilter', @resetTagScope
    @searchScope = @allItemIds()
    @tagScope = @allItemIds()

  render: ->
    template = Handlebars.compile $("#item-list-template").html()
    @$el.html template()
    this

  allItemIds: ->
    _.map @collection.models, (item) -> item.id

  setSearchScope: (itemIds) ->
    @searchScope = itemIds
    @displayItems()

  resetSearchScope: ->
    @searchScope = @allItemIds()
    @displayItems()

  setTagScope: (itemIds) ->
    @tagScope = itemIds
    @displayItems()

  resetTagScope: ->
    @tagScope = @allItemIds()
    @displayItems()

  displayItems: ->
    itemIds = _.intersection @searchScope, @tagScope
    items = @collection.filter (item) -> _.contains itemIds, item.id
    @$el.empty()
    @addAll items

  addItem: (item) ->
    App.Indices.ItemIndex.add item.attributes
    @searchScope.push item.id
    @tagScope.push item.id
    itemView = new App.Views.ItemView(model: item)
    @$el.append itemView.render().el

  addAll: (items) ->
    for item in items
      @addItem item

# view for items on the show page
App.Views.ItemShowView = Backbone.View.extend
  initialize: ->
    @listenTo @model, 'change', @render

  render: ->
    template = Handlebars.compile $("#item-show-template").html()
    @$el.html template(@model.attributes)
    subTemplateName = "##{@model.get("type")}-show-template"
    subTemplate = Handlebars.compile $(subTemplateName).html()
    @$el.find(".tags-row").after subTemplate(@model.attributes)
    @$el.find(".image-carousel").slick(
      dots: true
    )
    this
