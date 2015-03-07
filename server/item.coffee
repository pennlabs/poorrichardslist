db = require './db'
_ = require 'lodash'
async = require 'async'

addTagOrIncrementCount = (tag, callback) ->
  db.collection('tags').update tag, {$inc: {count: 1}}, {upsert: true},
    (err, result) ->
      db.collection('tags').findOne tag, (err, result) ->
        callback null, result._id

exports.addItem = (item, tags, callback) ->
  async.map tags, addTagOrIncrementCount, (err, tagIds) ->
    item.tags = tagIds
    db.collection('items').insert item, (err, result) ->
      callback result