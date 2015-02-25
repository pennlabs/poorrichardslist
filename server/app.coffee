Item = require './item'
db = require './db'

BSON = require('mongodb').BSONPure
express = require 'express'
morgan = require 'morgan'
_ = require 'lodash'
app = express()

app.use express.static '../public'
app.use morgan 'combined'

bodyParser = require 'body-parser'
parseUrlencoded = bodyParser.urlencoded {extended: false}
app.use(bodyParser.json())

# routes
app.get '/items', (req, res) ->
  db.collection('items').find({}).sort({_id: -1}).toArray (err, items) ->
    res.json items

app.get '/items/:id', (req, res) ->
  db.collection('items').findOne {_id: new BSON.ObjectID(req.params.id)},
    (err, item) ->
      db.collection('tags').find({_id: {$in: item.tags}}).toArray (err, tags) ->
        item.tags = tags
        res.json item

app.post '/items', parseUrlencoded, (req, res) ->
  item = req.body
  tags = _.map (req.body.tags.split " "), (name) -> {name: name}
  Item.addItem item, tags, (result) ->
    res.status(201).json result

app.listen 8080, ->
  console.log "server started!!"
