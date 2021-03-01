import { bcv_parser } from "../core";
const grammar = require("./grammar");

require("./regexps");
require("./translations");

export = {
    bcv_parser: class extends bcv_parser {
        constructor() {
            super(grammar);
        }
    }
};
