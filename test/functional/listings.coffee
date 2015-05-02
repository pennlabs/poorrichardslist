process.env.NODE_ENV = 'test'
app = require '../../server/app.coffee'
Browser = require 'zombie'

describe 'listings page', ->
  before ->
    this.server = app.listen '1234'
    this.browser = new Browser site: 'http://localhost:1234'

  before (done) ->
    this.browser.visit '/', done

  it 'successfully loads', ->
    this.browser.assert.success()

  after (done) ->
    this.server.close done
