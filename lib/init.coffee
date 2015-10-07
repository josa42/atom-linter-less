fs = require "fs"
path = require "path"
less = require 'less'
LinterLessProvider = require './linter-less-provider'
packageDeps = require 'atom-package-deps'

module.exports =

  config:
    ignoreUndefinedGlobalVariables:
      type: 'boolean'
      default: false
      description: "Ignore variables marked as global e.g. // global: @fontSize"
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
    includePath:
      type: 'array'
      description: 'Set include paths. Separated by \',\'.'
      default: []
      items:
        type: 'string'
    autoImportFiles:
      type: 'array'
      description: 'Auto import these files before linting. Separated by \',\'.'
      default: []
      items:
        type: 'string'

  activate: ->
    console.log 'activate linter-less' if atom.inDevMode()

    packageDeps.install 'linter-less'

  provideLinter: -> LinterLessProvider
