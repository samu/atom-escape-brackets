{Point, CompositeDisposable} = require "atom"

module.exports =
  subscriptions: null

  escapableCharacters:
    ')' : true
    ']' : true
    '}' : true
    '"' : true
    "'" : true

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add "atom-text-editor:not(.mini)",
      "atom-escape-brackets:move": (e) => @move(e)

  deactivate: ->
    @subscriptions.dispose()

  move: (e) ->
    if editor = atom.workspace.getActiveTextEditor()
      cursorBufferPosition = editor.getCursorBufferPosition()
      to = new Point(cursorBufferPosition.row, cursorBufferPosition.column + 1)
      nextCharacter = editor.getTextInBufferRange([cursorBufferPosition, to])
      cursors = editor.getCursors()
      if cursors.length == 1 and editor.getLastSelection().isEmpty() and @escapableCharacters[nextCharacter]?
        cursors[0].moveRight()
      else
        e.abortKeyBinding()
    else
      e.abortKeyBinding()
