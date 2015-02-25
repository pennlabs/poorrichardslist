db = require './db'
_ = require 'lodash'

exports.addItem = (item, tags, callback) ->
  db.collection('tags').insert tags, (err, tags) ->
    tagsIds = _.map tags, (tag) -> tag._id
    item.tags = tagsIds
    db.collection('items').insert item, (err, result) ->
      callback result
