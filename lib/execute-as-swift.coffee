{BufferedProcess} = require 'atom'
fs = require 'fs'

module.exports =
  configDefaults:
    swift_path: '/Applications/Xcode6-Beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift'

  activate: ->
    atom.workspaceView.command "execute-as-swift:execute", => @execute()

  execute: ->
    editor = atom.workspace.getActiveEditor()

    # unsaved file returns undefined
    current_file_path = editor.getPath()
    return unless current_file_path
    unless current_file_path.match(/\.swift$/)
      return console.log('The file extention is not matched.')

    output_file_path = "#{atom.project.getPath()}/#{editor.getTitle()}.out"

    # evaluate swift
    command = atom.config.get('execute-as-swift.swift_path')
    args = ["-i", current_file_path]
    stdout = (output) => @write_and_open_file(output_file_path, output)
    stderr = stdout
    process = new BufferedProcess({command, args, stdout, stderr})

  write_and_open_file: (path, output)->
    fs.writeFile(path, output, (err)->
      if err
        console.error(err)

      else
        options = {
          split: 'right'

          # TODO not working??
          activatePane: false
        }

        activePane = atom.workspace.getActivePane()
        atom.workspace.open(path, options).done((newEditor)->
          # options.activatePane seems not to work, so reactivate prev pane.
          activePane.activate()
        )
    )
