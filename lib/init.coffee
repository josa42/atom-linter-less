module.exports =
  activate: ->
    console.log 'activate linter-less'

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
      description: 'Allow mixed units, e.g. 1px+1em or 1px*1px which have units that cannot be represented.'
    strictMath:
      type: 'boolean'
      default: false
      description: 'Turn on or off strict math, where in strict mode, math requires brackets.'
    includePath:
      type: 'array'
      description: 'Set include paths. Separated by \',\'.'
      default: []
      items:
        type: 'string'
