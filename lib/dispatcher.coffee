{MessagePanelView, LineMessageView, PlainMessageView} = require 'atom-message-panel'
gingerbread = require 'gingerbread'

module.exports =
class Dispatcher
  constructor: ->
    @messageView = new MessagePanelView
      title: 'Ginger'
    @messageView.attach()

  destroy: =>
    @messageView?.remove()
    @messageView = null

  init: ->
    @messageView.clear()

  ##
  # text
  # callback = (error, text, result, corrections)
  ginger: (text, callback) ->
    gingerbread text, callback

  addMessage: (message, classNm) ->
    @messageView.add new PlainMessageView
      raw: true
      message: message
      className: classNm

  addLineMessage: (message, line, character) ->
    @messageView.add new LineMessageView
      line: line
      character: character
      message: message
