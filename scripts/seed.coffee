async = require 'async'
faker = require 'faker'
Item = require '../server/item'

randomNumber = (min, max) ->
  if max?
    faker.random.number {min: min, max: max}
  else
    faker.random.number {min: 1, max: min}

merge = (item, attrs) ->
  for attr, value of attrs
    item[attr] = value

genItem = (type, callback) ->
  item =
    desc: faker.lorem.sentences(randomNumber 8)
    imageIds: ["v1428538897/vhv78skyys4jagxaeww8.jpg"]

  if type in ["goods", "textbooks"]
    merge item,
      name: faker.lorem.sentence()
      price: randomNumber 5, 150
    if type == "textbooks"
      merge item,
        authors: (faker.name.findName() for _ in [1..(randomNumber 4)])
        edition: randomNumber 6
        course: "#{faker.lorem.words 1}#{randomNumber 100, 500}"
  else if type == "sublets"
    merge item,
      location: faker.lorem.sentence()
      rent: randomNumber 5, 150
      roomType: faker.lorem.words 2

  tags = ({name: "##{faker.lorem.words 1}"} for i in [0...(randomNumber 5)])

  Item.addItem item, tags, (item) ->
    console.log item
    callback null

types = ["goods", "textbooks", "sublets"]
genCount = 5

async.each [0...genCount],
  (i, callback) ->
    genItem (faker.random.array_element types), callback
  (err) ->
    process.exit()

