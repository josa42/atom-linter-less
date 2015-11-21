"use babel"

import { config } from '../lib/init'
import LinterLessProvider from '../lib/linter-less-provider'

export function resetConfig() {
  Object.keys(config).forEach((key) => {
    atom.config.set("linter-less.#{key}", config[key].default)
  })
}

export function lint(filePath) {
  return atom.workspace.open(filePath)
    .then((editor) => LinterLessProvider.lint(editor))
}
