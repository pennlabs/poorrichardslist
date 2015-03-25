require('dotenv').load()
Item = require './item'
db = require './db'

BSON = require('mongodb').BSONPure
express = require 'express'
morgan = require 'morgan'
_ = require 'lodash'
async = require 'async'
cloudinary = require 'cloudinary'
app = express()

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
  db.collection('items').find({}).sort({_id: -1}).toArray (err, items) ->
    async.map items,
      (item, callback) ->
        item.smallImageUrl = cloudinary.utils.url item.imageId, {
          crop: 'fit', width: 400, height: 400 }
        callback null, item
      (err, items) ->
        res.json items

app.get '/items/:id', (req, res) ->
  db.collection('items').findOne {_id: new BSON.ObjectID(req.params.id)},
    (err, item) ->
      item.detailImageUrl = cloudinary.utils.url item.imageId, {
        crop: 'fit', height: 330 }
      db.collection('tags').find({_id: {$in: item.tags}}).toArray (err, tags) ->
        item.tags = tags
        res.json item

app.post '/items', parseUrlencoded, (req, res) ->
  item = req.body
  if req.body.imageId
    preloadedFile = new cloudinary.PreloadedFile req.body.imageId
    if preloadedFile.is_valid()
      item.imageId = preloadedFile.identifier()
    else
      throw "Invalid image upload signature"
  if req.body.tags
    tags = _.map (req.body.tags.split " "), (name) -> {name: name}
  else
    tags = []
  Item.addItem item, tags, (result) ->
    res.status(201).json result

app.get '/tags', (req, res) ->
  db.collection('tags').find({}).sort({count: -1}).toArray (err, tags) ->
    async.map tags,
      (tag, callback) ->
        db.collection('items').find({tags: tag._id}).toArray (err, items) ->
          tag.items = _.map items, (item) -> item._id
          callback null, tag
      (err, tags) ->
        res.json tags

app.get '/tags/:id', (req, res) ->
  db.collection('tags').findOne {_id: new BSON.ObjectID(req.params.id)},
    (err, tag) ->
      res.json tag

app.delete '/tags/:id', (req, res) ->
  db.collection('tags').remove {_id: new BSON.ObjectID(req.params.id)},
    (err, result) ->
      res.json result

# Returns cloudinary credentials for the client to upload images.
# Credentials timeout in an hour. Example below:
# { timestamp: 1426435407,
#   signature: 'b646d8d486b74a27c88653ddcd0c05cf4d4f282a',
#   api_key:   '162536167369695' }
app.get '/cloudinary', (req, res) ->
  params = cloudinary.utils.build_upload_params {}
  params = cloudinary.utils.process_request_params params, {}
  res.json params

app.listen 8080, ->
  console.log "server started!!"
