linterPath = atom.packages.getLoadedPackage("linter").path
Linter = require "#{linterPath}/lib/linter"
fs = require "fs"
path = require "path"
less = require 'less'
{Range} = require 'atom'

class LinterLess extends Linter

  @syntax: 'source.css.less'

  linterName: 'less'

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
      paths: [@cwd, @config('includePath')...]
      filename: filePath
    )

    parser.parse data, (err, tree) =>

      if not err
        try
          tree.toCSS(
            ieCompat: @config 'ieCompatibilityChecks'
            strictUnits: @config 'strictUnits'
            strictMath: @config 'strictMath'
          )
        catch toCssErr
          err = toCssErr

      return callback([]) if not err or err.filename isnt filePath

      lineIdx = Math.max 0, err.line - 1 - lineOffset

      callback([
        line: err.line,
        col: err.column,
        level: 'error',
        message: err.message
        linter: @linterName,
        range: new Range([lineIdx, err.column], [lineIdx, @lineLengthForRow(lineIdx)])
      ])

  lintFile: (filePath, callback) ->
    fs.readFile filePath, 'utf8', (err, data) =>
      return callback([]) if err
      @parseLessFile data, filePath, callback

  config: (key) ->
    atom.config.get "linter-less.#{key}"

module.exports = LinterLess
