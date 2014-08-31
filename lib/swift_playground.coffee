{BufferedProcess} = require 'atom'
fs = require 'fs'

module.exports =
  configDefaults:
    xcode_path: '/Applications/Xcode6-Beta.app'

  activate: ->
    atom.workspaceView.command "swift-playground:execute", => @execute()

  execute: ->
    editor = atom.workspace.getActiveEditor()

    # unsaved file returns undefined
    current_file_path = editor.getPath()
    return unless current_file_path
    unless current_file_path.match(/\.swift$/)
      return console.log('The file extention is not matched.')

    output_file_path = "#{atom.project.getPath()}/#{editor.getTitle()}.out"

    # evaluate swift
    xcode = atom.config.get('swift-playground.xcode_path')
    command = "#{xcode}/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift"
    args = ["-sdk", "#{xcode}/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.10.sdk", current_file_path]
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
        }

        activePane = atom.workspace.getActivePane()
        atom.workspace.open(path, options).done((newEditor)->
            activePane.activate()
        )
    )
