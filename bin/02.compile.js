const { execSync } = require("child_process");
const fs = require("fs");

const lang = process.argv[2];

if (lang) {
  compile(lang);
} else {
  fs.readdirSync("src")
    .filter((dir) => dir !== "core")
    .forEach(compile);
}

function compile(lang) {
  console.log(`Compiling lang '${lang}'...`);
  execSync(
    `pegjs --format globals --export-var grammar -o "temp_${lang}_grammar.js" "src/${lang}/grammar.pegjs"`
  );
  add_pegjs_global(`temp_${lang}_grammar.js`);
  console.log("Joining...");
  execSync(
    `cat "src/core/bcv_parser.coffee" "src/core/bcv_passage.coffee" "src/core/bcv_utils.coffee" "src/${lang}/translations.coffee" "src/${lang}/regexps.coffee" | coffee --no-header --compile --stdio > "js/${lang}_bcv_parser.js"`
  );
  add_peg(lang, "");
  // compile_closure();
  fs.rmSync(`temp_${lang}_grammar.js`);
}

function add_peg(lang, prefix) {
  let peg = fs.readFileSync(`temp_${prefix}${lang}_grammar.js`).toString();

  // Ideally, it would `return res[0].split("");`, but this is faster, and PEG.js doesn't care.
  const new_parsespace = `function peg$parsespace() {
      var res;
      if (res = /^[\\s\\xa0*]+/.exec(input.substr(peg$currPos))) {
        peg$currPos += res[0].length;
        return [];
      }
      return peg$FAILED;
    }`;
  const new_parseinteger = `function peg$parseinteger() {
      var res;
      if (res = /^[0-9]{1,3}(?!\\d|,000)/.exec(input.substr(peg$currPos))) {
        peg$savedPos = peg$currPos;
        peg$currPos += res[0].length;
        return {"type": "integer", "value": parseInt(res[0], 10), "indices": [peg$savedPos, peg$currPos - 1]}
      } else {
        return peg$FAILED;
      }
    }`;
  const new_parseany_integer = `function peg$parseany_integer() {
      var res;
      if (res = /^[0-9]+/.exec(input.substr(peg$currPos))) {
        peg$savedPos = peg$currPos;
        peg$currPos += res[0].length;
        return {"type": "integer", "value": parseInt(res[0], 10), "indices": [peg$savedPos, peg$currPos - 1]}
      } else {
        return peg$FAILED;
      }
    }`;
  const sequence_regex_var = peg.match(
    /function peg\$parsesequence_sep\(\) \{\s+var s.+;\s+s0 =.+\s+s1 =.+\s+if \((peg\$c\d+)\.test/
  )[1];
  if (!sequence_regex_var) {
    throw new Error("No sequence var");
  }
  const escaped_regex = sequence_regex_var.replace(
    /([\.\\\+\*\?\[\^\]\$\(\)])/g,
    "\\$1"
  );
  const re = new RegExp(`${escaped_regex} = \\/\\^\\[,([^\\]]+?\\]\\/)`);
  let sequence_regex_value = peg.match(re)[1];
  if (!sequence_regex_value) {
    throw new Error("No sequence value");
  }
  sequence_regex_value = `/^[${sequence_regex_value}`;
  const new_options_check = `if ("punctuation_strategy" in options && options.punctuation_strategy === "eu") {
      peg$parsecv_sep = peg$parseeu_cv_sep;
      ${sequence_regex_var} = ${sequence_regex_value};
    }`;

  peg = peg.replace(
    /function peg\$parsespace\(\) \{(?:(?:.|\n)(?!return s0))*?.return s0;\s*\}/,
    new_parsespace
  );
  peg = peg.replace(
    /function peg\$parseinteger\(\) \{(?:(?:.|\n)(?!return s0))*?.return s0;\s*\}/,
    new_parseinteger
  );
  // peg = peg.replace(
  //   /function peg\$parseany_integer\(\) \{(?:(?:.|\n)(?!return s0))*?.return s0;\s*\}/,
  //   new_parseany_integer
  // );
  peg = peg.replace(/(function text\(\) \{)/, `${new_options_check}\n\n    $1`);
  peg = peg.replace(/ \\t\\r\\n\\xa0/gi, "\\s\\xa0");
  peg = peg.replace(/ \\\\t\\\\r\\\\n\\\\xa0/gi, "\\\\s\\\\xa0");
  // if (/parse(?:space|integer|any_integer)\(\) \{\s+var s/i.test(peg)) {
  //   throw new Error(`Unreplaced PEG space: ${peg}`);
  // }
  if (!/"punctuation_strategy"/.test(peg)) {
    throw new Error("Unreplaced options");
  }

  merge_file(`js/#PREFIX${lang}_bcv_parser.js`, peg, prefix);
}

function merge_file(file, peg, prefix) {
  if (prefix && prefix !== "") {
    prefix += "/";
  }
  const src_file = file.replace(/#PREFIX/, "");
  let joined = fs.readFileSync(src_file).toString();
  const prev = joined;
  joined = joined.replace(/(\s*\}\)\.call\(this\);\s*)$/, `\n${peg}$1`);
  if (prev === joined) {
    throw new Error("PEG not successfully added");
  }
  const dest_file = file.replace(/#PREFIX/, prefix);
  fs.writeFileSync(dest_file, joined);
}

function compile_closure() {
  console.log("Minifying...");
  // print `node template_closure.js $lang`;
}

function add_pegjs_global(filename) {
  let data = fs.readFileSync(filename).toString();
  data = `var grammar;\n${data}`;
  data = data.replace(/\broot\.grammar/, "grammar");
  fs.writeFileSync(filename, data);
}
