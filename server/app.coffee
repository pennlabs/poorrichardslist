require('dotenv').load()
Item = require './item'
db = require './db'

express = require 'express'

nodemailer = require 'nodemailer';
morgan = require 'morgan'
_ = require 'lodash'
async = require 'async'
cloudinary = require 'cloudinary'
app = express()

smtpTransport = nodemailer.createTransport('SMTP',
  service: 'Gmail'
  auth:
    user: 'poorrichardslist@gmail.com'
    pass: 'poorrichardslist350')


app.use express.static 'public'
app.use morgan 'combined'

bodyParser = require 'body-parser'
parseUrlencoded = bodyParser.urlencoded {extended: false}
app.use(bodyParser.json())

cloudinary.config
  cloud_name: process.env.CLOUD_NAME
  api_key: process.env.CLOUDINARY_API_KEY
  api_secret: process.env.CLOUDINARY_API_SECRET

# routes
app.get '/items', (req, res) ->
  db.items.find({}).sort({_id: -1}).toArray (err, items) ->
    async.map items,
      (item, callback) ->
        if "imageIds" of item
          item.smallImageUrl = cloudinary.utils.url item.imageIds[0], {
            crop: 'fill', width: 533, height: 400 }
        db.tags.findByItem item, (err, tags) ->
          item.tags = tags
          callback null, item
      (err, items) ->
        res.json items

app.get '/items/:id', (req, res) ->
  db.items.findById req.params.id,
    (err, item) ->
      item.detailImageUrls = _.map item.imageIds, (id) ->
        cloudinary.utils.url id, { crop: 'fit', height: 330 }
      db.tags.findByItem item, (err, tags) ->
        item.tags = tags
        res.json item

app.post '/items', parseUrlencoded, (req, res) ->
  item = req.body
  imageIds = req.body.imageIds
  if imageIds and imageIds.length > 0
    preloadedFiles = _.map imageIds, (id) ->
      new cloudinary.PreloadedFile id
    if _.all(preloadedFiles, (pf) -> pf.is_valid())
      item.imageIds = _.map preloadedFiles, (pf) -> pf.identifier()
    else
      throw "Invalid image upload signature"
  if req.body.tags
    tags = _.map (req.body.tags.split " "), (name) -> {name: name}
  else
    tags = []
  Item.addItem item, tags, (result) ->
    res.status(201).json result

app.get '/tags', (req, res) ->
  db.tags.find({}).sort({count: -1}).toArray (err, tags) ->
    async.map tags,
      (tag, callback) ->
        db.items.find({tags: tag._id}).toArray (err, items) ->
          tag.items = _.map items, (item) -> item._id
          callback null, tag
      (err, tags) ->
        res.json tags

app.get '/tags/:id', (req, res) ->
  db.tags.findById req.params.id,
    (err, tag) ->
      res.json tag

app.delete '/tags/:id', (req, res) ->
  db.tags.removeById req.params.id,
    (err, result) ->
      res.json result

app.get '/send', (req, res) ->
  mailOptions = 
    to: req.query.to
    subject: req.query.subject
    text: req.query.text
  console.log mailOptions
  smtpTransport.sendMail mailOptions, (error, response) ->
    if error
      console.log error
      res.end 'error'
    else
      console.log 'Message sent: ' + response.message
      res.end 'sent'
    return
  return



# Returns cloudinary credentials for the client to upload images.
# Credentials timeout in an hour. Example below:
# { timestamp: 1426435407,
#   signature: 'b646d8d486b74a27c88653ddcd0c05cf4d4f282a',
#   api_key:   '162536167369695' }
app.get '/cloudinary', (req, res) ->
  params = cloudinary.utils.build_upload_params {}
  params = cloudinary.utils.process_request_params params, {}
  res.json params

app.listen 8000, ->
  console.log "server started!!"
