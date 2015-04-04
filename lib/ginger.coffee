module.exports =
  config:
    replaceOriginal:
      title: 'Replace original text by `Gingered` text'
      description: 'Turn on to replace your original text by `Gingered` text'
      type: 'boolean'
      default: false
      order: 1

  activate: (state) ->
    atom.commands.add 'atom-workspace', 'ginger:correct': => @correct()

  deactivate: ->
    @dispatch?.destroy()
    @dispatch = null

  getDispatcher: ->
    unless @dispatch?
      Dispatcher = require './dispatcher'
      @dispatch = new Dispatcher()
    @dispatch

  correct: ->
    @getDispatcher()

    # Get the text from cursor position
    editor = atom.workspace.getActiveTextEditor()
    cursor = editor.getCursors()[0]
    range = cursor.getCurrentLineBufferRange()
    line = cursor.getBufferRow()
    oldText = editor.getTextInBufferRange(range)

    @dispatch.init()

    if oldText == null || oldText.replace(/^\s*|\s*$/g, '') == ''
      @dispatch.addMessage '<b>NOTHING TO GINGER</b>', 'text-warning'
      return

    # Correction
    @dispatch.ginger oldText, (error, text, result, corrections) =>
      if error
        @dispatch.addMessage '<b>ERROR: </b>' + error, 'text-error'
        return

      if text == result
        @dispatch.addMessage '<b>完璧やんけ！ It\'s perfect!</b>', 'text-success'
        return

      if atom.config.get('ginger.replaceOriginal')
        editor.setTextInBufferRange(range, result)

      @dispatch.addMessage text + ' --- <b>Original</b>'
      @dispatch.addMessage result + ' --- <b>Gingered</b>'

      for correction in corrections
        msg = correction.text + ' -> ' + correction.correct
        @dispatch.addLineMessage msg, line + 1, correction.start
