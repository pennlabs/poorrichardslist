App.Models.Cloudinary = Backbone.Model.extend
  urlRoot: "/cloudinary"

App.Views.ImageUploaderView = Backbone.View.extend
  events:
    "cloudinarydone .cloudinary-fileupload": "preview"

  initialize: ->
    @listenTo @model, 'change', @render

  preview: (e, data) ->
    @$el.find(".preview").append $.cloudinary.image(
      data.result.public_id,
      format: data.result.format
      version: data.result.version
      crop: 'fit'
      width: 300
      height: 300)
    return true

  render: ->
    template = Handlebars.compile $("#image-uploader-template").html()
    @$el.html template @model.attributes
    @$el.find(".cloudinary-fileupload").cloudinary_fileupload()
    this

