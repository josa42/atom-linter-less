"use babel"

import fs from "fs"
import path from "path"
import less from 'less'
import LinterLessProvider from './linter-less-provider'

export default {

  config: {
    ignoreUndefinedGlobalVariables: {
      type: 'boolean',
      default: false,
      description: "Ignore variables marked as global e.g. // global: @fontSize"
    },
    ignoreUndefinedVariables: {
      type: 'boolean',
      default: false
    },
    ieCompatibilityChecks: {
      title: 'IE Compatibility Checks',
      type: 'boolean',
      default: true
    },
    strictUnits: {
      type: 'boolean',
      default: false,
      description: `
        Allow mixed units, e.g. 1px+1em or 1px*1px which have units that cannot
        be represented.
      `
    },
    includePath: {
      type: 'array',
      description: 'Set include paths. Separated by \',\'.',
      default: [],
      items: {
        type: 'string'
      }
    }
  },

  activate() {
    if (atom.inDevMode()) {
      console.log('activate linter-less')
    }
    require('atom-package-deps').install('linter-less')
  },

  provideLinter: () => LinterLessProvider
}
