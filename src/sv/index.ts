import { bcv_parser as base_bcv_parser } from "../core";
const grammar = require("./grammar");

require("./regexps");
require("./translations");

export class bcv_parser extends base_bcv_parser {
	constructor() {
		super(grammar);
	}
}
