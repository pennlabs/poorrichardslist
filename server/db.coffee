# setup mongodb
MongoClient = require('mongodb').MongoClient
Server = require('mongodb').Server
mongoclient = new MongoClient(
  new Server('localhost', 27017, {'native_parser': true}))
db = mongoclient.db 'test'

# startup server
mongoclient.open (err, mongoclient) ->
  throw err if err

module.exports = db