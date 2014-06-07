{View} = require 'atom'

module.exports =
class ExecuteAsSwiftView extends View
  @content: ->
    @div class: 'execute-as-swift overlay from-top', =>
      @div "The ExecuteAsSwift package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "execute-as-swift:toggle", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log "ExecuteAsSwiftView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
