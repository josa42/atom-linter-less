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
    
    parser = new less.Parser (
      verbose: false
      silent: true
      paths: [@cwd]
      filename: filePath
    )
    parser.parse data, (err, tree) =>
      
      return callback([]) if not err or err.filename is not filePath
      
      lineIdx = Math.max 0, err.line - 1
      
      callback([
        line: err.line,
        col: err.column,
        level: 'error',
        message: err.message
        linter: @linterName,
        range: new Range([lineIdx, err.column], [lineIdx, @lineLengthForRow(lineIdx)])
      ])
  
  lintFile: (filePath, callback)->
    fs.readFile filePath, 'utf8', (err, data) =>
      return callback([]) if err
      @parseLessFile data, filePath, callback

module.exports = LinterLess
