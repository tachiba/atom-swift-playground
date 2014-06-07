ExecuteAsSwiftView = require './execute-as-swift-view'

module.exports =
  executeAsSwiftView: null

  activate: (state) ->
    @executeAsSwiftView = new ExecuteAsSwiftView(state.executeAsSwiftViewState)

  deactivate: ->
    @executeAsSwiftView.destroy()

  serialize: ->
    executeAsSwiftViewState: @executeAsSwiftView.serialize()
