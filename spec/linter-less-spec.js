'use babel'

import path from 'path'
import { resetConfig, lint } from './test-helper'
import LinterLessProvider from '../lib/linter-less-provider'

describe('Lint less', () => {
  beforeEach(() => {
    resetConfig()
    waitsForPromise(() => atom.packages.activatePackage('linter-less'))
  })

  describe('Unrecognised input', () => {

    it('retuns one error "Unrecognised input"', () => {
      waitsForPromise(() =>
        lint(path.join(__dirname, 'files', 'error-unrecognised-input.less'))
          .then((messages) => {
            expect(messages.length).toEqual(1)
            expect(messages[0].text).toEqual('Unrecognised input')
            expect(messages[0].range).toEqual([[0, 0], [0, 4]])
          })
      )
    })
  })

  describe('strict units', () => {

    it('retuns no errors', () => {
      waitsForPromise(() =>
        lint(path.join(__dirname, 'files', 'error-strict-units.less'))
          .then((messages) => expect(messages.length).toEqual(0))
      )
    })

    it('retuns one error "Incompatible units"', () => {
      atom.config.set('linter-less.strictUnits', true)
      waitsForPromise(() =>
        lint(path.join(__dirname, 'files', 'error-strict-units.less'))
          .then((messages) => {
            expect(messages.length).toEqual(1)
            expect(messages[0].text).toEqual(
              'Incompatible units. Change the units or use the unit function. Bad units: \'px\' and \'em\'.'
            )
            expect(messages[0].range).toEqual([[1, 2], [1, 20]])
          })
      )
    })
  })

  describe('mixins', () => {

    it('ignores undefined mixins', () => {
      waitsForPromise(() =>
        lint(path.join(__dirname, 'files', 'error-undefined-mixins.less'))
          .then((messages) => console.log(messages) || expect(messages.length).toEqual(0))
      )
    })

    it('report undefined mixins', () => {
      atom.config.set('linter-less.ignoreUndefinedMixins', false)
      waitsForPromise(() =>
        lint(path.join(__dirname, 'files', 'error-undefined-mixins.less'))
          .then((messages) => {
            expect(messages.length).toEqual(1)
            expect(messages[0].text).toEqual('.first-mixin-class is undefined')
            expect(messages[0].range).toEqual([[1, 2], [1, 23]])
          })
      )
    })
  })

  describe('undefined variable @fontSize', () => {

    it('retuns one error "variable @fontSize is undefined"', () => {
      atom.config.set('linter-less.ignoreUndefinedVariables', false)
      waitsForPromise(() =>
        lint(path.join(__dirname, 'files', 'error-undefined-variable.less'))
          .then((messages) => {
            expect(messages.length).toEqual(1)
            expect(messages[0].text).toEqual('variable @fontSize is undefined')
            expect(messages[0].range).toEqual([[3, 13], [3, 22]])
          })

      )
    })

    it('ignores undefined variables', () => {
      waitsForPromise(() =>
        lint(path.join(__dirname, 'files', 'error-undefined-variable.less'))
          .then((messages) => expect(messages.length).toEqual(0))
      )
    })

    it('ignores undefined global variables', () => {
      atom.config.set('linter-less.ignoreUndefinedGlobalVariables', true)
      waitsForPromise(() =>
        lint(path.join(__dirname, 'files', 'error-undefined-variable.less'))
          .then((messages) => expect(messages.length).toEqual(0))
      )
    })

    it('return error "\'<file>\' was not found"', () => {
      atom.config.set('linter-less.ignoreUndefinedGlobalVariables', true)
      waitsForPromise(() =>
        lint(path.join(__dirname, 'files', 'import-missing.less'))
          .then((messages) => {
            expect(messages.length).toEqual(1)
            expect(messages[0].text.replace(/(Tried -) .*$/, '$1 <paths>'))
              .toEqual('\'./icons.css\' wasn\'t found. Tried - <paths>')
          })
      )
    })

    it('should handle relative imports', () => {
      atom.config.set('linter-less.ignoreUndefinedGlobalVariables', true)
      waitsForPromise(() =>
        lint(path.join(__dirname, 'files', 'success-import.less'))
          .then((messages) => expect(messages.length).toEqual(0))
      )
    })
  })

  describe('lessrc config', () => {

    it('retuns one error and respect lessrc.strictUnits', () => {
      waitsForPromise(() =>
        lint(path.join(__dirname, 'files', 'lessrc', 'test.less'))
          .then((messages) => {
            expect(messages.length).toEqual(1)
          })
      )
    })

    it('retuns no errors and ignores invalid lessrc', () => {
      waitsForPromise(() =>
        lint(path.join(__dirname, 'files', 'lessrc-invalid', 'test.less'))
          .then((messages) => {
            expect(messages.length).toEqual(0)
          })
      )
    })

    it('retuns no errors if import from lessrc.paths', () => {
      waitsForPromise(() =>
        lint(path.join(__dirname, 'files', 'lessrc', 'test-import.less'))
          .then((messages) => {
            expect(messages.length).toEqual(0)
          })
      )
    })

    it('retuns one error if ignoreLessrc is true', () => {
      atom.config.set('linter-less.ignoreLessrc', true)
      waitsForPromise(() =>
        lint(path.join(__dirname, 'files', 'lessrc', 'test-import.less'))
          .then((messages) => {
            expect(messages.length).toEqual(1)
          })
      )
    })
  })
})
