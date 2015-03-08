App.Indices.ItemIndex = lunr(->
  @field 'name'
  @field 'desc'
  @field 'price'
  @ref '_id'
)
