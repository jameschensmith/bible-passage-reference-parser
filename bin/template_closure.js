const fs = require("fs");
const closure = require("../lib/closure");

const lang = process.argv[2];
const code_to_compile = fs.readFileSync(`../js/${lang}_bcv_parser.js`);

closure.compile(code_to_compile, (err, code) => {
  if (err) throw err;
  fs.writeFile(`../js/${lang}_bcv_parser.min.js`, code);

  const smaller = Math.round((1 - code.length / code_to_compile.length) * 100);
  console.log("Closure compiled (%d% smaller)", smaller);
});
