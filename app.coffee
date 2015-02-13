express = require 'express'
morgan = require 'morgan'
_ = require 'lodash'
app = express()

app.use express.static 'public'
app.use morgan 'combined'

bodyParser = require 'body-parser'
parseUrlencoded = bodyParser.urlencoded {extended: false}
app.use(bodyParser.json())

# routes
app.get '/items', (req, res) ->
  db.collection('items').find({}).toArray (err, items) ->
    res.json items

app.get '/items/:id', (req, res) ->
  console.log "id: #{req.params.id}"
  db.collection('items').findOne {_id: new BSON.ObjectID(req.params.id)},
    (err, item) ->
      res.json item

app.post '/items', parseUrlencoded, (req, res) ->
  tags = _.map (req.body.tags.split " "), (name) -> {name: name}
  db.collection('tags').insert tags, (err, tags) ->
    tagsIds = _.map tags, (tag) -> tag._id
    item = req.body
    item.tags = tagsIds
    db.collection('items').insert item, (err, result) ->
      res.status(201).json result

# setup mongodb
BSON = require('mongodb').BSONPure
MongoClient = require('mongodb').MongoClient
Server = require('mongodb').Server
mongoclient = new MongoClient(
  new Server('localhost', 27017, {'native_parser': true}))
db = mongoclient.db 'test'

# startup server
mongoclient.open (err, mongoclient) ->
  throw err if err
  app.listen 8080, ->
    console.log "server started!!"
