express = require 'express'
morgan = require 'morgan'
twilio = require 'twilio'
bodyParser = require 'body-parser'
config = require './config'

app = express()

parseUrlencoded = bodyParser.urlencoded {extended: false}

BSON = require('mongodb').BSONPure

app.use express.static 'public'
app.use morgan 'combined'
app.set 'views', './public'
app.set 'view engine', 'jade'
app.use bodyParser.urlencoded { extended: true }

# setup mongodb
MongoClient = require('mongodb').MongoClient
Server = require('mongodb').Server
mongoclient = new MongoClient(
  new Server('localhost', 27017, {'native_parser': true}))
db = mongoclient.db 'test'

# in order to drive use - when they click sell an item - I'd suggest
# a paginated view with the photo upload first, and then once the text gets sent
# bring them to the "sell your product page with the rest of the information, so
# that the asynchronous processing is actually useful
app.post '/send', (req, res) ->
  client = new twilio.RestClient(
    config.TWILIO_KEY,
    config.TWILIO_SECRET
  )
  #save number and associate with USER
  toNumber = req.body.phone
  message = 'Take a photo of the item you\'re selling ' +
            'and reply with it here. Standard MMS charges apply.'

  client.sendMessage {
    to: toNumber,
    body: message,
    from: config.TWILIO_NUMBER
  }, (err, messageData) ->
    if (err)
      res.send 'Oops there was an error:('
      console.error err
    else
      res.send 'Message sent! SID: ' + messageData.sid
    return

#create a draft or see if there is an open draft currently using the fromNumber
# what happens if someone has an awful connection, figure out how to fail safe
# maybe tell them their internet is being slow or create a draft when it finally uploads etc
app.post '/message', (req, res) ->
  console.log 'received message'
  twiml = twilio.TwimlResponse

  numMedia = parseInt request.body.NumMedia
  fromNumber = request.body.From

  if numMedia > 0
    i = 0
    while i < numMedia
      mediaUrl = request.body['MediaUrl' + i]
      console.log 'Displaying MediaUrl: ' + mediaUrl
      i++
    twiml.message 'Photo received - continue filling out information
    for your selling item and the photo should load!'
  else
    twiml.message ':( Doesn\'t look like there was a photo in that message.'

  response.type "text/xml"
  response.send twiml.toString


# just use this page to do a test, delete when you build a real form
app.get '/send_photo', (req, res) ->
  res.render 'send_photo'

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
