App.Views.ListingView = Backbone.View.extend
  id: "listing"
  initialize: (options) ->
    @itemListView = options.itemListView
    @tagListView = options.tagListView
  render: ->
    template = Handlebars.compile($("#listing-template").html())
    @$el.html(template())
    @$el.find("#item-list").html(@itemListView.render().el)
    @$el.find("#tag-list").html(@tagListView.render().el)
    this
