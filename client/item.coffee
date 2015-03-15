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
    @$el.html template(@model.attributes)
    this

# view for items in list format
App.Views.ItemListView = Backbone.View.extend
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
    this

App.Views.ItemFormView = Backbone.View.extend
  id: "item-form"

  initialize: (options) ->
    @type = options.type
    credentials = new App.Models.Cloudinary()
    credentials.fetch()
    @uploaderView = new App.Views.ImageUploaderView(model: credentials)

  render: ->
    @$el.html Handlebars.compile($("#item-form-template-main").html())
    if @type == "goods"
      goodsFormView = new App.Views.GoodsFormView(
          model: @model, uploaderView: @uploaderView)
      @$el.find("#type-form").html goodsFormView.render().el
    else if @type =="textbooks"
      textbooksFormView = new App.Views.TextbooksFormView(
          model: @model, uploaderView: @uploaderView)
      @$el.find("#type-form").html textbooksFormView.render().el
      @$el.find("#type-form").addClass('textbooks-adjust')
    else if @type == "sublets"
      subletsFormView = new App.Views.SubletsFormView(
          model: @model, uploaderView: @uploaderView)
      @$el.find("#type-form").html subletsFormView.render().el
    if @type
      @$el.find("#select-instruction").addClass('form-hide-text')
    this

App.Views.GoodsFormView = Backbone.View.extend
  id: "goods-form"

  events:
    submit: "save"

  initialize: (options) ->
    @uploaderView = options.uploaderView

  save: (e) ->
    e.preventDefault()
    data =
      name: @$('input[name=name]').val()
      desc: @$('input[name=desc]').val()
      price: @$('input[name=price]').val()
      tags: @$('input[name=tags]').val()
      imageId: @$('input[name=image-id]').val()
      type: 'goods'
    @model.save data,
      success: (model, res, options) ->
        Backbone.history.navigate "#items/#{res[0]._id}", {trigger: true}
      error: (model, xhr, options) ->
        errors = JSON.parse(xhr.responseText).errors
        alert "Item submit errors: #{errors}"

  render: ->
    @$el.html Handlebars.compile $("#goods-form-template").html()
    @$el.find("#image-uploader").html @uploaderView.render().el
    this

App.Views.TextbooksFormView = Backbone.View.extend
  id: "textbooks-form"

  events:
    submit: "save"

  initialize: (options) ->
    @uploaderView = options.uploaderView

  save: (e) ->
    e.preventDefault()
    data =
      name: @$('input[name=name]').val()
      desc: @$('input[name=desc]').val()
      price: @$('input[name=price]').val()
      tags: @$('input[name=tags]').val()
      course: @$('input[name=course]').val()
      authors: @$('input[name=authors]').val()
      imageId: @$('input[name=image-id]').val()
      type: 'textbooks'
    @model.save data,
      success: (model, res, options) ->
        Backbone.history.navigate "#items/#{res[0]._id}", {trigger: true}
      error: (model, xhr, options) ->
        errors = JSON.parse(xhr.responseText).errors
        alert "Item submit errors: #{errors}"

  render: ->
    @$el.html Handlebars.compile $("#textbooks-form-template").html()
    @$el.find("#image-uploader").html @uploaderView.render().el
    this

App.Views.SubletsFormView = Backbone.View.extend
  id: "sublets-form"

  events:
    submit: "save"

  initialize: (options) ->
    @uploaderView = options.uploaderView

  save: (e) ->
    e.preventDefault()
    data =
      name: @$('input[name=name]').val()
      desc: @$('input[name=desc]').val()
      price: @$('input[name=price]').val()
      tags: @$('input[name=tags]').val()
      roomType: @$('input[name=room-type]').val()
      imageId: @$('input[name=image-id]').val()
      type: 'sublets'
    @model.save data,
      success: (model, res, options) ->
        Backbone.history.navigate "#items/#{res[0]._id}", {trigger: true}
      error: (model, xhr, options) ->
        errors = JSON.parse(xhr.responseText).errors
        alert "Item submit errors: #{errors}"

  render: ->
    @$el.html Handlebars.compile $("#sublets-form-template").html()
    @$el.find("#image-uploader").html @uploaderView.render().el
    this
