# linter-less

[![Test](https://github.com/josa42/atom-linter-less/workflows/Main/badge.svg?branch=master)](https://github.com/josa42/atom-linter-less/actions?query=workflow%3AMain)
[![Plugin installs!](https://img.shields.io/apm/dm/linter-less.svg?style=flat-square)](https://atom.io/packages/linter-less)
[![Package version!](https://img.shields.io/apm/v/linter-less.svg?style=flat-square)](https://atom.io/packages/linter-less)
![Project: Not maintained](https://img.shields.io/badge/Project-Not_maintained-red.svg)

This plugin for [Linter](https://github.com/atom-community/linter) provides an interface to [less](http://lesscss.org).

---

**Note: the repository is not maintained. If you would like to take over, please open an issue!**

---

## Configuration

* **Ignore undefined global variables:** Ignore variables marked as global e.g. `// global: @fontSize`
* **Ignore undefined variables**
* **Ignore undefined mixins**
* **IE Compatibility Checks**
* **Strict Math:** Turn on or off strict math, where in strict mode, math requires brackets.
* **Strict Units:** Disallow mixed units, e.g. `1px+1em` or `1px*1px` which have units that cannot be represented.
* **Ignore .lessrc configutation file**

See also: [lesscss.org](http://lesscss.org/usage/#command-line-usage).

## Configuration File (`.lessrc`)

```JSON
{
  "paths": [],
  "ieCompat": true,
  "strictUnits": false
}
```
