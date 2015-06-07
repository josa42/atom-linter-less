fs = require "fs"
path = require "path"
less = require 'less'

LinterLess =

  scopes: ['source.css.less']

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

  lint: (textEditor, textBuffer) ->

    return new Promise (resolve, reject) =>

      filePath = textEditor.getPath()
      return resolve() unless filePath

      @parseLessFile textBuffer.cachedText, filePath, resolve

  parseLessFile: (data, filePath, callback) ->

    lineOffset = 0;
    variables= [];

    if @config 'ignoreUndefinedVariables'
      for variable in data.match(/@[a-zA-Z0-9_-]+/g)
        lineOffset++
        data = "#{variable}: 0;\n#{data}"


    parser = new less.Parser(
      verbose: false
      silent: true
      paths: [@cwd, @getConfig('includePath')...]
      filename: filePath
    )

    parser.parse data, (err, tree) =>

      if not err
        try
          tree.toCSS(
            ieCompat: @getConfig 'ieCompatibilityChecks'
            strictUnits: @getConfig 'strictUnits'
            strictMath: @getConfig 'strictMath'
          )
        catch toCssErr
          err = toCssErr

      return callback([]) if not err or err.filename isnt filePath

      callback([
        type: "Error"
        message: err.message
        position: [[err.line, err.column], [err.line, err.column]]
      ])

  getConfig: (key) ->
    atom.config.get "linter-less.#{key}"

module.exports = LinterLess
