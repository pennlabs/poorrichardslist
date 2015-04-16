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
  className: "tag"

  events:
    "click": "tagToggle"

  initialize: ->
    @listenTo @model, 'change', @render

  render: ->
    template = Handlebars.compile $("#tag-template").html()
    @$el.html template @model.attributes
    this

  tagToggle: (e) ->
    e.preventDefault()
    $(e.currentTarget).toggleClass "selected"

App.Views.TagListView = Backbone.View.extend
  id: "tag-list-render-tags"

  events:
    "click a": "tagFilter"

  initialize: ->
    @listenTo @collection, 'add', @addTag
    @selectedTags = []
    _.bindAll(this, "updateHeight")
    $(window).on 'resize', @updateHeight # left off here

  updateHeight: ->
    @$el.css 'height', $(window).height()

  render: ->
    template = Handlebars.compile $("#tag-list-template").html()
    @$el.html template()
    this

  addTag: (tag) ->
    tagView = new App.Views.TagView(model: tag)
    @$el.append tagView.render().el

  updateSelectedTags: (tag) ->
    if tag in @selectedTags
      @selectedTags = _.filter @selectedTags, (t) -> t isnt tag
    else
      @selectedTags.push tag

  itemsWithAllSelectedTags: ->
    items = @selectedTags[0].attributes.items
    for t in @selectedTags.slice(1)
      items = _.union items, t.attributes.items
    items

  tagFilter: (e) ->
    e.preventDefault()
    tag = @collection.get $(e.currentTarget).data("id")
    @updateSelectedTags tag

    if @selectedTags.length > 0
      App.PubSub.trigger 'tagFilter', @itemsWithAllSelectedTags()
    else
      App.PubSub.trigger 'noTagFilter'
