"use babel"

import fs from "fs"
import path from "path"
import less from 'less'
import LinterLessProvider from './linter-less-provider'
import { install } from 'atom-package-deps'

export default {

  config: {
    ignoreUndefinedGlobalVariables: {
      description: "Ignore variables marked as global e.g. `// global: @fontSize`",
      type: 'boolean',
      default: false
    },
    ignoreUndefinedVariables: {
      type: 'boolean',
      default: true
    },
    ignoreUndefinedMixins: {
      type: 'boolean',
      default: true
    },
    ieCompatibilityChecks: {
      title: 'IE Compatibility Checks',
      type: 'boolean',
      default: true
    },
    strictUnits: {
      description: `Disallow mixed units, e.g. \`1px+1em\` or \`1px*1px\` which
                    have units that cannot be represented.`,
      type: 'boolean',
      default: false
    },
    includePath: {
      description: 'Set include paths. Separated by \',\'.',
      type: 'array',
      items: { type: 'string' },
      default: []
    },
    ignoreLessrc: {
      title: 'Ignore .lessrc configutation file',
      type: 'boolean',
      default: false
    }
  },

  activate() {
    if (!atom.inSpecMode()) {
      install('linter-less')
    }
  },

  provideLinter: () => LinterLessProvider
}
