{ bcv_parser } = require("../core")
grammar = require("./grammar")

require("./regexps")
require("./translations")

module.exports =
    bcv_parser: class extends bcv_parser
        constructor: ->
            super grammar
