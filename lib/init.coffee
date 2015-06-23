fs = require "fs"
path = require "path"
less = require 'less'
LinterLessProvider = require './linter-less-provider'

module.exports =

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

  provideLinter: -> LinterLessProvider
