App.Indices.ItemIndex = lunr(->
  @ref '_id'

  # common
  @field 'name'
  @field 'desc'
  @field 'price'

  # textbooks
  @field 'authors'
  @field 'edition'
  @field 'course'

  # sublets
  @field 'location'
  @field 'rent'
  @field 'roomType'
)

App.Views.SearchBarView = Backbone.View.extend
  events:
    "keyup input": "search"

  search: (e) ->
    query = $(e.currentTarget).val()
    if query.length > 2
      results = App.Indices.ItemIndex.search query
      itemIds = _.map results, (r) -> r.ref
      App.PubSub.trigger 'search', itemIds
      @searched = true
    else if @searched
      App.PubSub.trigger 'nosearch'
      @searched = false

  render: ->
    template = Handlebars.compile $("#search-bar-template").html()
    @$el.html template()
    this
