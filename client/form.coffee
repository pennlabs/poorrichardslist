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
      desc: @$('textarea[name=desc]').val()
      price: @$('input[name=price]').val()
      tags: @$('input[name=tags]').val()
      imageIds: @$('input[name=image-id]').map(() -> $(this).val()).toArray()
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
    @$el.find("#tags").tokenInput("tagsearch");
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
      desc: @$('textarea[name=desc]').val()
      price: @$('input[name=price]').val()
      tags: @$('input[name=tags]').val()
      edition: @$('input[name=edition]').val()
      course: @$('input[name=course]').val()
      authors: @$('input[name=authors]').val()
      imageIds: @$('input[name=image-id]').map(() -> $(this).val()).toArray()
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
      location: @$('input[name=location]').val()
      desc: @$('textarea[name=desc]').val()
      rent: @$('input[name=rent]').val()
      tags: @$('input[name=tags]').val()
      roomType: @$('input[name=room-type]').val()
      imageIds: @$('input[name=image-id]').map(() -> $(this).val()).toArray()
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
