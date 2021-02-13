/* eslint-disable no-continue,no-shadow,babel/new-cap */
const fs = require("fs");

const lang = "en";
const max_length = 100;

const bcv_parser = require(`../../js/${lang}_bcv_parser`).bcv_parser;
const bcv = new bcv_parser();

// prettier-ignore
const possibles = {
  book: get_abbrevs(lang),
  translation: get_translations(),
  number: [...Array(1100).keys()],
  chapter: [...Array(152).keys()],
  verse: [...Array(177).keys()],
  cv_sep: [":", ".", '"', "'", " "],
  range_sep: ["-", "\u2013", "\u2014", "through", "thru", "to"],
  sequence_sep: [",", ";", "/", ":", "&", "-", "\u2013", "\u2014", "~", "and", "compare", "cf", "cf.", "see also", "also", "see", " "],
  title: ["title"],
  in_book_of: ["from the book of", "of the book of", "in the book of"],
  c_explicit: ["chapters", "chapter", "chapts", "chapts.", "chpts", "chpts.", "chapt", "chapt.", "chaps", "chaps.", "chap", "chap.", "chp", "chp.", "chs", "chs.", "cha", "cha.", "ch", "ch."],
  v_explicit: ["verses", "verse", "ver", "ver.", "vss", "vss.", "vs", "vs.", "vv", "vv.", "v", "v."],
  v_letter: ["a", "b", "c", "d", "e"],
  ff: ["ff", "ff."],
  ordinal: ["th", "nd", "st"],
  space: [" ", "\t", "\n", "\u00a0"],
  punctuation: [",", ".", "!", "?", "-", "'", '"', "\u2019"],
  parentheses: ["(", ")", "[", "]", "{", "}"],
  letter: ["f", "g", "h", "n"],
  char_ascii: [...Array(127).keys()],
  char_unicode: Array.from({ length: 65535 - 128 }, (_, i) => 128 + i),
  bcv: "$book$chapter$cv_sep$verse",
  b_range: "$book$range_sep$book",
  translation_sequence: "$translation$sequence_sep$translation",
  bc: "$book$chapter",
  bc_range: "$book$chapter$range_sep$book",
  cb: "$c_explicit$chapter$in_book_of$book",
  c_psalm: "$chapter$ordinal$book",
  cv_psalm: "$chapter$ordinal$book$v_explicit$verse",
};

const options = get_options();
const possible_keys = Object.keys(possibles);
const option_keys = Object.keys(options);
let total_length = 0;
const start_time = new Date();

for (let i = 1, o = 1; o <= 10000000; i = ++o) {
  const my_options = create_options(option_keys);
  bcv.set_options(my_options);
  const text = build_text(possible_keys);
  total_length += text.length;
  if (i % 1000 === 0) {
    const elapsed_time = Math.round((new Date() - start_time) / 1000);
    const bytes_per_second = Math.round(total_length / elapsed_time);
    console.log(
      `${i} ${elapsed_time} sec ${Math.round(
        total_length / 1000000
      )} mb ${bytes_per_second} bps`
    );
  }
  try {
    const results = bcv.parse(text).osis_and_indices();
    for (let p = 0, len = results.length; p < len; p++) {
      const result = results[p];
      if (result.indices[0] >= result.indices[1]) {
        throw result;
      }
    }
  } catch (error) {
    const e = error;
    console.log(e);
    console.log(my_options);
    console.log(text);
    process.exit();
  }
}

function get_abbrevs(lang) {
  const lines = fs
    .readFileSync(`src/${lang}/book_names.txt`)
    .toString()
    .split("\n");
  const out = [];
  for (let j = 0; j < lines.length; j++) {
    const line = lines[j];
    const [, abbrev] = line.split("\t");
    if (abbrev != null) {
      out.push(abbrev);
    }
  }
  return out;
}

function get_translations() {
  // prettier-ignore
  return ["AMP", "ASV", "CEB", "CEV", "ERV", "ESV", "HCSB", "KJV", "MSG", "NAB", "NABRE", "NAS", "NASB", "NIRV", "NIV", "NKJV", "NLT", "NRSV", "RSV", "TNIV"];
}

function get_options() {
  const lines = fs.readFileSync("README.adoc").toString().split("\n");
  const out = {};
  let option = "";
  let go = false;
  let result;
  for (let j = 0; j < lines.length; j++) {
    const line = lines[j];
    if (go && line.match(/^=== /)) {
      break;
    }
    if (line.match(/^=== Options/)) {
      go = true;
    }
    if (!go) {
      continue;
    }
    if ((result = line.match(/^\* `(\w+):/))) {
      option = result[1];
      out[option] = [];
    } else if ((result = line.match(/^\*\* `(\w+)`/))) {
      out[option].push(result[1]);
    }
  }
  // prettier-ignore
  out.passage_existence_strategy = ["b", "bc", "bcv", "bv", "c", "cv", "v", "none"];
  out.include_apocrypha = [true, false];
  return out;
}

function create_options(keys) {
  const out = {};
  for (let j = 0; j < keys.length; j++) {
    const option = keys[j];
    out[option] = get_random_item_from_array(options[option]);
  }
  return out;
}

function get_random_item_from_array(items) {
  return items[Math.floor(Math.random() * items.length)];
}

function build_text(keys) {
  const out = [];
  let rand = Math.random();
  const length = Math.ceil(rand * max_length);
  for (let i = 1; i <= length; i++) {
    let token = make_token(get_random_item_from_array(keys));
    rand = Math.random();
    if (rand >= 0.5) {
      token += get_random_item_from_array(possibles.space);
    }
    out.push(token);
  }
  return out.join("");
}

function make_token(type) {
  const rand = Math.random();
  const possible = possibles[type];
  let token;
  if (typeof possible === "string") {
    token = build_nested_string(possible);
  } else if (type.substr(0, 5) === "char_") {
    token = String.fromCharCode(get_random_item_from_array(possible));
  } else {
    token = get_random_item_from_array(possible);
  }
  if (rand >= 0.5 && type.match(/^translation/)) {
    token = `(${token})`;
  }
  return token;
}

function build_nested_string(text) {
  text = text.replace(/\$(\w+)/g, (_, type) => {
    let match = make_token(type);
    const rand = Math.random();
    if (rand >= 0.5) {
      match += get_random_item_from_array(possibles.space);
    }
    return match;
  });
  return text;
}
