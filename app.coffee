express = require 'express'
app = express()

app.use express.static('public')

MongoClient = require('mongodb').MongoClient
Server = require('mongodb').Server
mongoclient = new MongoClient(
  new Server('localhost', 27017, {'native_parser': true}))
db = mongoclient.db 'test'

mongoclient.open (err, mongoclient) ->
  throw err if err
  app.listen 8080, ->
    console.log "server started!!"
