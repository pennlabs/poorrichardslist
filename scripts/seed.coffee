async = require 'async'
faker = require 'faker'
Item = require '../server/item'
db = require '../server/db'

randomNumber = (min, max) ->
  if max?
    faker.random.number {min: min, max: max}
  else
    faker.random.number {min: 1, max: min}

merge = (item, attrs) ->
  for attr, value of attrs
    item[attr] = value

images =
  "textbooks":
    [["v1429150233/tb1-1_cguz1s.jpg",
     "v1429150233/tb1-2_tme0qf.jpg"],
    ["v1429150446/00G0G_4kQ9qpxClhA_600x450_awuzjt.jpg",
     "v1429150446/00r0r_eVjDxNHBkUv_600x450_swxza4.jpg"],
    ["v1429150446/00l0l_kxJlCfucFfu_600x450_uvw3x9.jpg",
     "v1429150446/00s0s_kzkezlsQBek_600x450_nq1ipl.jpg",
     "v1429150447/00505_4NMIlp8nOMw_600x450_witond.jpg"],
    ["v1429150447/01111_bwmeazUDzlv_600x450_uok8g1.jpg"],
    ["v1429150446/00B0B_jIRblqGBDFt_600x450_j7lxuf.jpg"]]
  "goods":
    [["v1429150926/01616_hkV3z71rNme_600x450_fovf7t.jpg",
     "v1429150926/01111_cPvrkYcIfI1_600x450_jbrpnc.jpg",
     "v1429150926/00K0K_h8p4lF8g3oO_600x450_xvx8tx.jpg"],
    ["v1429150926/01616_hkV3z71rNme_600x450_fovf7t.jpg",
     "v1429150926/01111_cPvrkYcIfI1_600x450_jbrpnc.jpg",
     "v1429150926/00K0K_h8p4lF8g3oO_600x450_xvx8tx.jpg"]]
  "sublets":
    [["v1429151147/00l0l_grG6OLE9lYd_600x450_ts5orl.jpg",
     "v1429151143/00505_3dcEFQozx07_600x450_m8fdrb.jpg",
     "v1429151143/00G0G_l48PAZzYqMi_600x450_lurvxn.jpg"],
     ["v1429151147/00l0l_grG6OLE9lYd_600x450_ts5orl.jpg",
     "v1429151143/00505_3dcEFQozx07_600x450_m8fdrb.jpg",
     "v1429151143/00G0G_l48PAZzYqMi_600x450_lurvxn.jpg"]]

genItem = (type, callback) ->
  console.log images[type]
  console.log faker.random.array_element images[type]

  item =
    type: type
    desc: faker.lorem.sentences(randomNumber 8)
    imageIds: faker.random.array_element images[type]

  if type in ["goods", "textbooks"]
    merge item,
      name: faker.lorem.sentence()
      price: randomNumber 5, 150
    if type == "textbooks"
      merge item,
        authors: (faker.name.findName() for _ in [1..(randomNumber 4)])
        edition: randomNumber 6
        course: "#{(faker.lorem.words 1).slice(0,4)}#{randomNumber 100, 500}"
  else if type == "sublets"
    merge item,
      location: faker.lorem.sentence()
      rent: randomNumber 5, 150
      roomType: (faker.lorem.words 2).join(" ")

  tags = ({name: "##{faker.lorem.words 1}"} for i in [0...(randomNumber 5)])

  Item.addItem item, tags, (item) ->
    console.log item
    callback null

# remove all existing item and tag data
db.items.remove {}, (err, result) ->
  console.log "removed #{result} items"
db.tags.remove {}, (err, result) ->
  console.log "removed #{result} tags"

# create item and tag data, then exit
types = ["goods", "textbooks", "sublets"]
genCount = 20
async.each [0...genCount],
  (i, callback) ->
    genItem (faker.random.array_element types), callback
  (err) ->
    process.exit()

