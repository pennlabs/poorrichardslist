express = require 'express'
morgan = require 'morgan'
app = express()

bodyParser = require 'body-parser'
parseUrlencoded = bodyParser.urlencoded {extended: false}

BSON = require('mongodb').BSONPure;

app.use express.static 'public'
app.use morgan 'combined'

# setup mongodb
MongoClient = require('mongodb').MongoClient
Server = require('mongodb').Server
mongoclient = new MongoClient(
  new Server('localhost', 27017, {'native_parser': true}))
db = mongoclient.db 'test'

# routes
app.get '/upload', (req, res) ->
  res.sendFile "#{__dirname}/public/upload.html"

app.get '/items', (req, res) ->
  db.collection('items').find({}).toArray (err, items) ->
    res.json items

app.get '/items/:id', (req, res) ->
  console.log "id: #{req.params.id}"
  db.collection('items').findOne {_id: new BSON.ObjectID(req.params.id)},
    (err, item) ->
      res.json item

app.post '/items', parseUrlencoded, (req, res) ->
  item = req.body
  db.collection('items').insert item, (err, result) ->
    res.status(201).json result

# startup server
mongoclient.open (err, mongoclient) ->
  throw err if err
  app.listen 8080, ->
    console.log "server started!!"
