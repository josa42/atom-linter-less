fs = require "fs"
path = require "path"
less = require 'less'

LinterLess =

  grammarScopes: ['source.css.less']

  scope: 'file'

  lintOnFly: true

  config:
    ignoreUndefinedVariables:
      type: 'boolean'
      default: false
    ieCompatibilityChecks:
      title: 'IE Compatibility Checks'
      type: 'boolean'
      default: true
    strictUnits:
      type: 'boolean'
      default: false
      description: """
        Allow mixed units, e.g. 1px+1em or 1px*1px which have units that cannot
        be represented.
      """
    strictMath:
      type: 'boolean'
      default: false
      description: """
        Turn on or off strict math, where in strict mode, math requires
        brackets.
      """
    includePath:
      type: 'array'
      description: 'Set include paths. Separated by \',\'.'
      default: []
      items:
        type: 'string'

  activate: ->
    console.log 'activate linter-less' if atom.inDevMode()

    if not atom.packages.getLoadedPackage 'linter'
      atom.notifications.addError """
        [linter-less] `linter` package not found, please install it
      """

  provideLinter: -> LinterLess

  lint: (textEditor) ->

    return new Promise (resolve, reject) =>

      filePath = textEditor.getPath()
      return resolve([]) unless filePath

      text = textEditor.getText()

      lineOffset = 0;
      variables= [];

      if @getConfig 'ignoreUndefinedVariables'
        for variable in text.match(/@[a-zA-Z0-9_-]+/g)
          lineOffset++
          text = "#{variable}: 0;\n#{text}"

      @parse text, filePath, (err) =>

        return resolve([]) unless err

        lineIdx = err.line - 1 - lineOffset
        colEndIdx = textEditor.lineTextForBufferRow(lineIdx).length

        resolve([
          type: "Error"
          text: err.message
          filePath: err.filename
          range: [[lineIdx, err.column], [lineIdx, colEndIdx]]
        ])

  parse: (text, filePath, callback) ->
    parser = new less.Parser(
      verbose: false
      silent: true
      paths: [@cwd, @getConfig('includePath')...]
      filename: filePath
    )

    parser.parse text, (err, tree) =>
      if not err
        try
          tree.toCSS(
            ieCompat: @getConfig 'ieCompatibilityChecks'
            strictUnits: @getConfig 'strictUnits'
            strictMath: @getConfig 'strictMath'
          )
        catch toCssErr
          err = toCssErr

      callback err

  getConfig: (key) ->
    atom.config.get "linter-less.#{key}"

module.exports = LinterLess
