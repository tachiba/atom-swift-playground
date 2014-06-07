{WorkspaceView} = require 'atom'
ExecuteAsSwift = require '../lib/execute-as-swift'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "ExecuteAsSwift", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('execute-as-swift')

  describe "when the execute-as-swift:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.execute-as-swift')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.workspaceView.trigger 'execute-as-swift:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.execute-as-swift')).toExist()
        atom.workspaceView.trigger 'execute-as-swift:toggle'
        expect(atom.workspaceView.find('.execute-as-swift')).not.toExist()
