# setup mongodb
mongo = require 'mongoskin'
db = mongo.db "mongodb://localhost:27017/test", {native_parser:true}

# common collection bindings
db.bind 'items'
db.bind('tags').bind
  findByItem: (item, callback) ->
    this.find({_id: {$in: item.tags}}).toArray (err, tags) ->
      callback err, tags

db.createIndex 'tags', {name: "text"}, (err, indexName) ->
    db.close

module.exports = db
