# fs = require('fs')
# dummyjson = require('dummy-json')
#
# template = fs.readFileSync('./scripts/item.hbs', {encoding: 'utf8'})
# result = dummyjson.parse(template)
# console.log result

Item = require '../server/item'

item =
  name: "HONG"
  price: 100

tags = [{name: "#fewo"}, {name: "#fiwe"}]

Item.addItem item, tags
