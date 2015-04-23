# setup mongodb
mongo = require 'mongoskin'
db = mongo.db process.env.DB_URL, {native_parser:true}

# common collection bindings
db.bind 'items'
db.bind('tags').bind
  findByItem: (item, callback) ->
    this.find({_id: {$in: item.tags}}).toArray (err, tags) ->
      callback err, tags

module.exports = db
