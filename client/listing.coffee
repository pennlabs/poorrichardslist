App.Views.ListingView = Backbone.View.extend
  id: "listing"

  initialize: (options) ->
    @itemListView = options.itemListView
    @tagListView = options.tagListView
    @searchBarView = options.searchBarView

  render: ->
    template = Handlebars.compile $("#listing-template").html()
    @$el.html template()
    @$el.find("#listing-search-container").prepend @searchBarView.render().el
    @$el.find("#listing-search-container").append @itemListView.render().el
    @$el.find("#tag-list-container").html @tagListView.render().el
    this
