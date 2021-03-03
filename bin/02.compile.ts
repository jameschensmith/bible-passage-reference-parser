import { execSync } from "child_process";
import fs from "fs";

const arg_lang = process.argv[2];

const out_dir = "js";
if (!fs.existsSync(out_dir)) {
	fs.mkdirSync(out_dir);
}

if (arg_lang) {
	compile_lang(arg_lang);
} else {
	fs.readdirSync("src")
		.filter((dir) => dir !== "core")
		.forEach(compile_lang);
}

function compile_lang(lang: string) {
	console.log(`Compiling lang '${lang}'...`);
	execSync(
		`pegjs --format commonjs -o "temp_${lang}_grammar.js" "src/${lang}/grammar.pegjs"`
	);
	add_peg(lang, "");
	fs.rmSync(`temp_${lang}_grammar.js`);
}

function add_peg(lang: string, prefix: string) {
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
	// const new_parseany_integer = `function peg$parseany_integer() {
	//     var res;
	//     if (res = /^[0-9]+/.exec(input.substr(peg$currPos))) {
	//       peg$savedPos = peg$currPos;
	//       peg$currPos += res[0].length;
	//       return {"type": "integer", "value": parseInt(res[0], 10), "indices": [peg$savedPos, peg$currPos - 1]}
	//     } else {
	//       return peg$FAILED;
	//     }
	//   }`;
	const sequence_regex_var = /function peg\$parsesequence_sep\(\) \{\s+var s.+;\s+s0 =.+\s+s1 =.+\s+if \((peg\$c\d+)\.test/.exec(
		peg
	)?.[1];
	if (!sequence_regex_var) {
		throw new Error("No sequence var");
	}
	const escaped_regex = sequence_regex_var.replace(
		/([.\\+*?[^\]$()])/g,
		"\\$1"
	);
	const re = new RegExp(`${escaped_regex} = \\/\\^\\[,([^\\]]+?\\]\\/)`);
	let sequence_regex_value = re.exec(peg)?.[1];
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
	if (!peg.includes('"punctuation_strategy"')) {
		throw new Error("Unreplaced options");
	}

	fs.writeFileSync(`js/${lang}/grammar.js`, peg);
}
