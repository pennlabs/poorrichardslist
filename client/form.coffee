App.Views.ItemFormView = Backbone.View.extend
  id: "item-form"

  events:
    submit: "save"

  initialize: (options) ->
    credentials = new App.Models.Cloudinary()
    credentials.fetch()
    @uploaderView = new App.Views.ImageUploaderView(model: credentials)

  render: ->
    @$el.html Handlebars.compile($("#item-form-template-main").html())
    @$el.find("#image-uploader").html @uploaderView.render().el
    this

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
