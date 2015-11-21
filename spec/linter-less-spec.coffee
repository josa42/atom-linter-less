path = require 'path'
{ resetConfig } = require './test-helper'

LinterLessProvider = require '../lib/linter-less-provider'

describe "Lint less", ->
  beforeEach ->
    waitsForPromise -> atom.packages.activatePackage('linter-less')
    resetConfig()

  describe "Unrecognised input", ->
    it 'retuns one error "Unrecognised input"', ->

      waitsForPromise ->
        atom.workspace.open(path.join(__dirname, 'files', 'error-unrecognised-input.less'))
          .then (editor) -> LinterLessProvider.lint(editor)
          .then (messages) ->

            expect(messages.length).toEqual(1)
            expect(messages[0].text).toEqual("Unrecognised input")
            expect(messages[0].range).toEqual([[0, 0], [0, 4]])


  describe "strict units", ->

    it 'retuns no errors', ->

      waitsForPromise ->
        atom.workspace.open(path.join(__dirname, 'files', 'error-strict-units.less'))
          .then (editor) -> LinterLessProvider.lint(editor)
          .then (messages) ->

            expect(messages.length).toEqual(0)

    it 'retuns one error "Incompatible units"', ->

      atom.config.set("linter-less.strictUnits", true)

      waitsForPromise ->
        atom.workspace.open(path.join(__dirname, 'files', 'error-strict-units.less'))
          .then (editor) -> LinterLessProvider.lint(editor)
          .then (messages) ->

            expect(messages.length).toEqual(1)
            expect(messages[0].text).toEqual("
              Incompatible units. Change the units or use the unit function. Bad
              units: 'px' and 'em'.
            ")
            expect(messages[0].range).toEqual([[1, 2], [1, 20]])


  describe "undefined variable @fontSize", ->

    it 'retuns one error "variable @fontSize is undefined"', ->

      waitsForPromise ->
        atom.workspace.open(path.join(__dirname, 'files', 'error-undefined-variable.less'))
          .then (editor) -> LinterLessProvider.lint(editor)
          .then (messages) ->

            expect(messages.length).toEqual(1)
            expect(messages[0].text).toEqual("variable @fontSize is undefined")
            expect(messages[0].range).toEqual([[3, 13], [3, 22]])

    it 'ignores undefined variables', ->

      atom.config.set("linter-less.ignoreUndefinedVariables", true)

      waitsForPromise ->
        atom.workspace.open(path.join(__dirname, 'files', 'error-undefined-variable.less'))
          .then (editor) -> LinterLessProvider.lint(editor)
          .then (messages) ->

            expect(messages.length).toEqual(0)

    it 'ignores undefined global variables', ->

      atom.config.set("linter-less.ignoreUndefinedGlobalVariables", true)

      waitsForPromise ->
        atom.workspace.open(path.join(__dirname, 'files', 'error-undefined-variable.less'))
          .then (editor) -> LinterLessProvider.lint(editor)
          .then (messages) ->

            expect(messages.length).toEqual(0)

    it 'return error "\'<file>\' was not found"', ->

      atom.config.set("linter-less.ignoreUndefinedGlobalVariables", true)

      waitsForPromise ->
        atom.workspace.open(path.join(__dirname, 'files', 'import-missing.less'))
          .then (editor) -> LinterLessProvider.lint(editor)
          .then (messages) ->

            expect(messages.length).toEqual(1)
            expect(messages[0].text.replace(/(Tried -) .*$/, '$1 <paths>'))
              .toEqual("'./icons.css' wasn't found. Tried - <paths>")

    it 'should handle relative imports', ->

      atom.config.set("linter-less.ignoreUndefinedGlobalVariables", true)

      waitsForPromise ->
        atom.workspace.open(path.join(__dirname, 'files', 'success-import.less'))
          .then (editor) -> LinterLessProvider.lint(editor)
          .then (messages) ->

            expect(messages.length).toEqual(0)
