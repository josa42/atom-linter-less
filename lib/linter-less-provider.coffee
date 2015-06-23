fs = require "fs"
path = require "path"
less = require 'less'

LinterLess =

  grammarScopes: ['source.css.less']

  scope: 'file'

  lintOnFly: true

  lint: (textEditor) ->

    return new Promise (resolve, reject) =>

      filePath = textEditor.getPath()
      return resolve([]) unless filePath

      text = textEditor.getText()

      lineOffset = 0
      variables = []



      if @config 'ignoreUndefinedVariables'
        for variable in (text.match(/@[a-zA-Z0-9_-]+/g) or [])
          lineOffset++
          text = "#{variable}: 0;\n#{text}"

      if @config 'ignoreUndefinedGlobalVariables'
        for line in (text.match(/(^|\n)\/\/\s*global:\s*@[a-zA-Z0-9_-]+/g) or [])
          variable = text.match(/@[a-zA-Z0-9_-]+/)
          lineOffset++
          text = "#{variable}: 0;\n#{text}"


      @lessParse text, filePath, (err) ->

        return resolve([]) unless err

        lineIdx = err.line - 1 - lineOffset
        line = textEditor.lineTextForBufferRow(lineIdx)
        colEndIdx = line.length if line

        resolve([
          type: "Error"
          text: err.message
          filePath: err.filename
          range: [[lineIdx, err.column], [lineIdx, colEndIdx]]
        ])


  lessParse: (text, filePath, callback) ->
    parser = new less.Parser(
      verbose: false
      silent: true
      paths: [@cwd, @config('includePath')...]
      filename: filePath
    )

    parser.parse text, (err, tree) =>
      if not err
        try
          tree.toCSS(
            ieCompat: @config 'ieCompatibilityChecks'
            strictUnits: @config 'strictUnits'
            strictMath: @config 'strictMath'
          )
        catch toCssErr
          err = toCssErr

      callback err

  config: (key) ->
    atom.config.get "linter-less.#{key}"

module.exports = LinterLess
