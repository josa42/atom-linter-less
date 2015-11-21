"use babel"

import fs from "fs"
import path from "path"
import less from 'less'

LinterLess = {

  name: "Less",

  grammarScopes: ['source.css.less'],

  scope: 'file',

  lintOnFly: true,

  lint(textEditor) {

    return new Promise((resolve, reject) => {

      filePath = textEditor.getPath()
      if (!filePath) { return resolve([]) }

      text = textEditor.getText()

      lineOffset = 0
      variables = []

      if (this.config('ignoreUndefinedVariables')) {
        for (variable of (text.match(/@[a-zA-Z0-9_-]+/g) || [])) {
          lineOffset++
          text = `${variable}: 0;\n${text}`
        }
      }

      if (this.config('ignoreUndefinedGlobalVariables')) {
        for (line of (text.match(/(^|\n)\/\/\s*global:\s*@[a-zA-Z0-9_-]+/g) || [])) {
          variable = text.match(/@[a-zA-Z0-9_-]+/)
          lineOffset++
          text = `${variable}: 0;\n${text}`
        }
      }

      this.lessParse(text, filePath, (err) => {

        if (!err) { return resolve([]) }

        lineIdx = err.line - 1 - lineOffset
        line = textEditor.lineTextForBufferRow(lineIdx)
        if (line) { colEndIdx = line.length }

        resolve([{
          type: "Error",
          text: err.message,
          filePath: err.filename,
          range: [[lineIdx, err.column], [lineIdx, colEndIdx]]
        }])
      })
    })
  },

  lessParse(text, filePath, callback) {

    cwd = path.dirname(filePath)

    options = {
      verbose: false,
      silent: true,
      paths: [cwd, ...this.config('includePath')],
      filename: filePath,
      ieCompat: this.config('ieCompatibilityChecks'),
      strictUnits: this.config('strictUnits'),
      strictMath: this.config('strictMath')
    }

    less.render(text, options, (error, output) => callback(error))
  },

  config(key) {
    return atom.config.get(`linter-less.${key}`)
  }
}

export default LinterLess
