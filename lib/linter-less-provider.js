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

      const filePath = textEditor.getPath()
      if (!filePath) { return resolve([]) }

      let text = textEditor.getText()
      let lineOffset = 0

      if (this.config('ignoreUndefinedVariables')) {
        for (let variable of (text.match(/@[a-zA-Z0-9_-]+/g) || [])) {
          lineOffset++
          text = `${variable}: 0;\n${text}`
        }
      }

      if (this.config('ignoreUndefinedGlobalVariables')) {
        for (line of (text.match(/(^|\n)\/\/\s*global:\s*@[a-zA-Z0-9_-]+/g) || [])) {
          let variable = text.match(/@[a-zA-Z0-9_-]+/)
          lineOffset++
          text = `${variable}: 0;\n${text}`
        }
      }

      this.lessParse(text, filePath, (err) => {

        if (!err) { return resolve([]) }

        let colEndIdx = 0
        let lineIdx = err.line - 1 - lineOffset
        let line = textEditor.lineTextForBufferRow(lineIdx)

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

    this.getOptions(filePath)
      .then((options) => {
        less.render(text, options, (error, output) => callback(error))
      })
  },

  config(key) {
    return atom.config.get(`linter-less.${key}`)
  },

  option(rc, key, confKey = null) {
    confKey = confKey || key

    if (rc[key] !== undefined) {
      return rc[key]
    }
    return this.config(confKey)
  },

  getOptions(filePath) {
    return this.getRcContent(filePath)
      .then((rc) => {

        const cwd = path.dirname(filePath)

        const options = {
          verbose: false,
          silent: true,
          paths: [cwd, ...this.config('includePath'), ...(rc.paths || [])],
          filename: filePath,
          ieCompat: this.option(rc, 'ieCompat', 'ieCompatibilityChecks'),
          strictUnits: this.option(rc, 'strictUnits')
        }

        return options
      })
  },

  getRcContent(filePath) {

    return new Promise((resolve, reject) => {

      if (this.config('ignoreLessrc')) {
        return resolve({})
      }

      const rcPath = this.getRcPath(filePath)

      if (!rcPath) { return resolve({}) }

      const dirPath = path.dirname(rcPath)

      fs.readFile(rcPath, 'utf8', function (err, data) {
        if (err) { return reject(err) }

        try {
          const rc = JSON.parse(data)
          rc.paths = (rc.paths || []).map((p) => path.resolve(dirPath, p))
          resolve(rc)

        } catch(ex) {
          resolve({})
        }
      })
    })
  },

  getRcPath(currentPath) {

    let lastPath
    while (currentPath && lastPath !== currentPath) {
      lastPath = currentPath
      currentPath = path.dirname(currentPath)

      let rcPath = path.join(currentPath, '.lessrc')

      if (fs.existsSync(rcPath)) {
        return rcPath
      }
    }

    return null
  }
}

export default LinterLess
