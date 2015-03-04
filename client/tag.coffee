# MODELS
App.Models.Tag = Backbone.Model.extend
  urlRoot: "/tags"
  idAttribute: "_id"

# COLLECTIONS
App.Collections.Tags = Backbone.Collection.extend
  model: App.Models.Tag
  url: "/tags"

# VIEWS
App.Views.TagView = Backbone.View.extend
  initialize: ->
    @listenTo(@model, 'change', @render)

  render: ->
    template = Handlebars.compile($("#tag-template").html())
    @$el.html(template(@model.attributes))
    this

App.Views.TagListView = Backbone.View.extend
  initialize: ->
    @listenTo @collection, 'add', @addTag

  render: ->
    template = Handlebars.compile($("#tag-list-template").html())
    @$el.html(template())
    this

  addTag: (tag) ->
    tagView = new App.Views.TagView(model: tag)
    @$el.find("#tag-list").append(tagView.render().el)


