const fs = require("fs");

const src_dir = "src";
// prettier-ignore
const ranges = {
	full: {
		chars: ".",
		data: "en",
		order: ["Gen", "Exod", "Bel", "Phlm", "Lev", "2Thess", "1Thess", "2Kgs", "1Kgs", "EpJer", "Lam", "Num", "Sus", "Sir", "PrMan", "Acts", "Rev", "PrAzar", "SgThree", "2Pet", "1Pet", "Rom", "Song", "Prov", "Wis", "Joel", "Jonah", "Nah", "1John", "2John", "3John", "John", "Josh", "1Esd", "2Esd", "Isa", "2Sam", "1Sam", "2Chr", "1Chr", "Ezra", "Ruth", "Neh", "GkEsth", "Esth", "Job", "Mal", "Matt", "Ps", "Eccl", "Ezek", "Hos", "Obad", "Hag", "Hab", "Mic", "Zech", "Zeph", "Luke", "Jer", "2Cor", "1Cor", "Gal", "Eph", "Col", "2Tim", "1Tim", "Deut", "Titus", "Heb", "Phil", "Dan", "Jude", "2Macc", "3Macc", "4Macc", "1Macc", "Judg", "Mark", "Jas", "Amos", "Tob", "Jdt", "Bar"],
		exclude_langs: ["amf", "awa", "bba", "bqc", "bus", "chr", "dop", "dug", "fue", "fuh", "hil", "hwc", "leb", "mkl", "mqb", "mvc", "mwv", "nds", "pck", "ppl", "qu", "soy", "tmz", "tr", "twi", "udu", "wa", "wol", "yom", "zap"],
		exclude_abbrevs: [
			"1 K", "1. K", "1.K", "1K", "I. K", "I.K", "IK", "I. Ki", "I Ki",
			"2 K", "2. K", "2.K", "2K", "II. K", "II.K", "IIK",
			"Ri", "Bir", // Judg
			"Ca", "En", "Pi bel Chante a", // Song
			"Ai", // Lam
			"Ad", // Obad
			"J", "Iv", "In", // John
			"Nas", // Acts
		],
		post_abbrevs: {
			Lev: ["\u5229"],
			Josh: ["\u66f8"],
			"1Kgs": ["1 Ks", "1. Ks", "I Ks", "I. Ks", "1 Re", "1. Re", "I. Ki", "I Ki"],
			"2Kgs": ["2 Ks", "2. Ks", "II Ks", "II. Ks", "2 Re", "2. Re"],
			Ezra: ["\u62c9"],
			Job: ["\u4f2f"],
			Song: ["Songs", "\u6b4c"],
			Lam: ["La"],
			Mic: ["Mi"],
			Matt: ["\u592a"],
			John: ["Jan", "\u7d04"],
			Acts: ["\u0410\u043F\u043E\u0441\u0442\u043E\u043B"],
			Rev: ["Re"],
			Judg: ["Bir"],
		},
		include_extra_abbrevs: 0
	},
	ascii: {
		chars: "[\x00-\x7f\u2000-\u206F]",
		data: "en",
		order: ["Gen", "Exod", "Bel", "Phlm", "Lev", "2Thess", "1Thess", "2Kgs", "1Kgs", "EpJer", "Lam", "Num", "Sus", "Sir", "PrMan", "Acts", "Rev", "PrAzar", "SgThree", "2Pet", "1Pet", "Rom", "Song", "Prov", "Wis", "Joel", "Jonah", "Nah", "1John", "2John", "3John", "John", "Josh", "Judg", "1Esd", "2Esd", "Isa", "2Sam", "1Sam", "2Chr", "1Chr", "Ezra", "Ruth", "Neh", "GkEsth", "Esth", "Job", "Mal", "Matt", "Ps", "Eccl", "Ezek", "Hos", "Obad", "Hag", "Hab", "Mic", "Zech", "Zeph", "Luke", "Jer", "2Cor", "1Cor", "Gal", "Eph", "Col", "2Tim", "1Tim", "Deut", "Titus", "Heb", "Phil", "Dan", "Jude", "2Macc", "3Macc", "4Macc", "1Macc", "Mark", "Jas", "Amos", "Tob", "Jdt", "Bar"],
		exclude_langs: ["amf", "awa", "bba", "bqc", "bus", "chr", "dop", "dug", "fue", "fuh", "hil", "hwc", "leb", "mkl", "mqb", "mvc", "mwv", "nds", "pck", "ppl", "qu", "soy", "tmz", "tr", "twi", "udu", "wa", "wol", "yom", "zap"],
		exclude_abbrevs: [
			"1 K", "1. K", "1.K", "1K", "I. K", "I.K", "IK", "I. Ki", "I Ki",
			"2 K", "2. K", "2.K", "2K", "II. K", "II.K", "IIK",
			"Ri", "Bir", // Judg
			"Ca", "En", "Pi bel Chante a", // Song
			"Ai", // Lam
			"Ad", // Obad
			"J", "Iv", "In", // John
			"Nas", // Acts
		],
		post_abbrevs: {
			"1Kgs": ["1 Ks", "1. Ks", "I Ks", "I. Ks", "1 Re", "1. Re", "I. Ki", "I Ki"],
			"2Kgs": ["2 Ks", "2. Ks", "II Ks", "II. Ks", "2 Re", "2. Re"],
			Song: ["Songs"],
			Lam: ["La"],
			Mic: ["Mi"],
			John: ["Jan"],
			Rev: ["Re"],
			Judg: ["Bir"],
		},
		include_extra_abbrevs: 0
	},
	asciibg: {
		chars: "[\x00-\x7f\u2000-\u206F]",
		data: "en",
		order: ["Gen", "Exod", "Bel", "Phlm", "Lev", "2Thess", "1Thess", "2Kgs", "1Kgs", "EpJer", "Lam", "Num", "Sus", "Sir", "PrMan", "Acts", "Rev", "PrAzar", "SgThree", "2Pet", "1Pet", "Rom", "Song", "Prov", "Wis", "Joel", "Jonah", "Nah", "1John", "2John", "3John", "John", "Josh", "1Esd", "2Esd", "Isa", "2Sam", "1Sam", "2Chr", "1Chr", "Ezra", "Ruth", "Neh", "GkEsth", "Esth", "Job", "Mal", "Matt", "Ps", "Eccl", "Ezek", "Hos", "Obad", "Hag", "Hab", "Mic", "Zech", "Zeph", "Luke", "Jer", "2Cor", "1Cor", "Gal", "Eph", "Col", "2Tim", "1Tim", "Deut", "Titus", "Heb", "Phil", "Dan", "Jude", "2Macc", "3Macc", "4Macc", "1Macc", "Judg", "Mark", "Jas", "Amos", "Tob", "Jdt", "Bar"],
		exclude_langs: [],
		exclude_abbrevs: [
			"1 K", "1. K", "1.K", "1K", "I. K", "I.K", "IK",
			"2 K", "2. K", "2.K", "2K", "II. K", "II.K", "IIK",
			"Ri", // Judg
			"Ca", "En", "Pi bel Chante a", // Song
			"Ai", // Lam
			"Ad", // Obad
			"J", "Iv", "In", // John
			"Nas", // Acts
			"Su", // Sus
			"Mak", // Eccl
		],
		post_abbrevs: {
			"1Kgs": ["1 Ks", "1. Ks", "I Ks", "I. Ks", "1 Re", "1. Re"],
			"2Kgs": ["2 Ks", "2. Ks", "II Ks", "II. Ks", "2 Re", "2. Re"],
			Song: ["Songs"],
			Lam: ["La"],
			Mic: ["Mi"],
			John: ["Jan"],
			Rev: ["Re"],
			Sus: ["Su"],
			Eccl: ["Mak"],
		},
		include_extra_abbrevs: 1
	},
	fullbg: {
		chars: ".",
		data: "en",
		order: ["Gen", "Exod", "Bel", "Phlm", "Lev", "2Thess", "1Thess", "2Kgs", "1Kgs", "EpJer", "Lam", "Num", "Sus", "Sir", "PrMan", "Acts", "Rev", "PrAzar", "SgThree", "2Pet", "1Pet", "Rom", "Song", "Prov", "Wis", "Joel", "Jonah", "Nah", "1John", "2John", "3John", "John", "Josh", "1Esd", "2Esd", "Isa", "2Sam", "1Sam", "2Chr", "1Chr", "Ezra", "Ruth", "Neh", "GkEsth", "Esth", "Job", "Mal", "Matt", "Ps", "Eccl", "Ezek", "Hos", "Obad", "Hag", "Hab", "Mic", "Zech", "Zeph", "Luke", "Jer", "2Cor", "1Cor", "Gal", "Eph", "Col", "2Tim", "1Tim", "Deut", "Titus", "Heb", "Phil", "Dan", "Jude", "2Macc", "3Macc", "4Macc", "1Macc", "Judg", "Mark", "Jas", "Amos", "Tob", "Jdt", "Bar"],
		exclude_langs: [],
		exclude_abbrevs: [
			"1 K", "1. K", "1.K", "1K", "I. K", "I.K", "IK",
			"2 K", "2. K", "2.K", "2K", "II. K", "II.K", "IIK",
			"Ri", // Judg
			"Ca", "En", "Pi bel Chante a", // Song
			"Ai", // Lam
			"Ad", // Obad
			"J", "Iv", "In", // John
			"Nas", // Acts
		],
		post_abbrevs: {
			Lev: ["\u5229"],
			Josh: ["\u66f8"],
			"1Kgs": ["1 Ks", "1. Ks", "I Ks", "I. Ks", "1 Re", "1. Re"],
			"2Kgs": ["2 Ks", "2. Ks", "II Ks", "II. Ks", "2 Re", "2. Re"],
			Ezra: ["\u62c9"],
			Job: ["\u4f2f"],
			Song: ["Songs", "\u6b4c"],
			Lam: ["La"],
			Mic: ["Mi"],
			Matt: ["\u592a"],
			John: ["Jan", "\u7d04"],
			Acts: ["\u0410\u043F\u043E\u0441\u0442\u043E\u043B"],
			Rev: ["Re"],
		},
		include_extra_abbrevs: 1
	},
};
// prettier-ignore
const lang_priorities = ["en", "es", "de", "pt", "pl", "zh", "ru", "it", "hu", "cs", "uk", "tl", "hr", "sv", "sk", "amf", "tr"];

const range_name = process.argv[2];
if (!range_name || !ranges[range_name]) {
	throw new Error(
		`Need name as first argument: ${Object.keys(ranges).sort().join(", ")}`
	);
}

const range = ranges[range_name];
const abbrevs = get_abbrevs(range);
const [langs, abbrev_osis] = arrange_abbrevs_by_osis();

if (!fs.existsSync(`${src_dir}/${range_name}`)) {
	fs.mkdirSync(`${src_dir}/${range_name}`);
}
const excludes = make_excludes(range);
const order = make_order(range.order);
let [data, used_langs] = make_valid_abbrevs(
	range_name,
	range.data,
	range.chars,
	range.post_abbrevs,
	excludes.exclude_langs,
	excludes.exclude_abbrevs,
	order
);
data += order;
data = data.replace(/(\$UNICODE_BLOCK\t)[^\n]+\n/, (_, $1) => {
	return `${$1}${make_lang_blocks(used_langs)}\n`;
});
data = data.normalize("NFD").normalize("NFC");
fs.writeFileSync(`${src_dir}/${range_name}/data.txt`, data);

function make_excludes(range) {
	const out = {
		exclude_langs: {},
		exclude_abbrevs: {},
	};
	Object.keys(out).forEach((key) => {
		if (range[key] && range[key].length) {
			range[key].forEach((value) => {
				out[key][value] = 1;
			});
		}
	});
	if (Object.keys(range.post_abbrevs).length) {
		Object.keys(range.post_abbrevs).forEach((osis) => {
			range.post_abbrevs[osis].forEach((abbrev) => {
				out.exclude_abbrevs[abbrev] = 1;
			});
		});
	}
	return out;
}

function make_lang_blocks(used_langs) {
	const blocks = {};
	Object.keys(used_langs).forEach((lang) => {
		if (!fs.existsSync(`${src_dir}/${lang}/data.txt`)) {
			return;
		}
		const data = fs.readFileSync(`${src_dir}/${lang}/data.txt`).toString();
		for (const line of data.split("\n")) {
			if (/^\$UNICODE_BLOCK\t/.test(line)) {
				const [, ...blocks_array] = line.split("\t");
				blocks_array.forEach((block) => {
					blocks[block] = blocks[block] ?? "";
					blocks[block] += used_langs[lang];
				});
				break;
			}
		}
	});
	const out = Object.keys(blocks).sort((a, b) => blocks[b] - blocks[a]);
	return out.join("\t");
}

function make_order(langs) {
	if (langs.length) {
		return `=${langs.join("\n=")}\n`;
	}
	let out = "";
	const data = fs.readFileSync(`${src_dir}/${langs}/data.txt`).toString();
	data.split("\n").forEach((line) => {
		if (!/^=/.test(line)) {
			return;
		}
		out += line;
	});
	return out;
}

function make_valid_abbrevs(
	name,
	lang,
	pattern,
	post_abbrevs,
	exclude_langs,
	exclude_abbrevs,
	order
) {
	const data = {};
	const alreadys = {};
	const out = [];
	order = expand_order(order);
	let data_key = "pre";
	const used_langs = {};
	const file_data = fs.readFileSync(`${src_dir}/${lang}/data.txt`).toString();
	file_data.split("\n").forEach((line) => {
		line += "\n";
		if (/^\w/.test(line)) {
			data_key = "post";
			const osis = line.match(/^([\w,]+)\t/)[1];
			if (!abbrev_osis[osis]) {
				return;
			}
			out.push(
				[
					osis,
					...get_matches(
						pattern,
						abbrev_osis[osis],
						exclude_langs,
						exclude_abbrevs,
						used_langs
					),
				].join("\t")
			);
			alreadys[osis] = 1;
		} else if (/^[#=]/.test(line)) {
			// Handle sort order later.
		} else if (/^\*/.test(line)) {
			Object.keys(exclude_abbrevs).forEach((abbrev) => {
				const safe = quote_meta(abbrev);
				line = line.replace(new RegExp(`\\t${safe}(?=[\\t\\n])`, "g"), "");
			});
			line = line.replace(/\t+$/, "");
			data[data_key] += `${line}`;
		} else {
			data[data_key] = data[data_key] ?? "";
			data[data_key] += `${line}`;
		}
	});
	// Get stragglers like "Ezek,Ezra"
	Object.keys(abbrev_osis)
		.sort()
		.forEach((osis) => {
			if (alreadys[osis]) {
				return;
			}
			out.push(
				[
					osis,
					...get_matches(
						pattern,
						abbrev_osis[osis],
						exclude_langs,
						exclude_abbrevs,
						used_langs
					),
				].join("\t")
			);
		});
	if (Object.keys(post_abbrevs).length) {
		Object.keys(post_abbrevs)
			.sort()
			.forEach((osis) => {
				// the comma after osis ensures that it gets treated as a different book
				out.push([`${osis},`, ...post_abbrevs[osis]].join(`\t`));
			});
	}

	check_abbrevs(name, order, out);
	// combining characters are already taken care of in each language's book_names.txt
	let output = `${data.pre}$DEFAULT_TRANS_LANG\t${lang}
$COLLAPSE_COMBINING_CHARACTERS\tfalse
$FORCE_OSIS_ABBREV\tfalse
$LANG_ISOS\t${Object.keys(used_langs).sort().join("\t")}
${out.join("\n")}
${data.post}`;
	output = output.replace(/\n{2,}/g, "\n");
	return [output, used_langs];
}

function expand_order(order) {
	order = order.replace(/[=]/g, "");
	order = order.replace(/^\s+|\s+$/g, "");
	const out = order.split(/\n+/);
	return out;
}

function check_abbrevs(name, order, out) {
	const abbrevs = {};
	const all_abbrevs = {};
	const order_map = {};
	order.forEach((osis) => {
		order_map[osis] = 1;
	});
	const fd = fs.openSync(`${src_dir}/${name}/conflicts.txt`, "w");
	out.forEach((line) => {
		const [osis, ...abbrevs_array] = line.split("\t");
		if (!order_map[osis]) {
			order.push(osis);
		}
		abbrevs_array.forEach((abbrev) => {
			if (all_abbrevs[abbrev]) {
				console.log(`Duplicate: ${abbrev} / ${all_abbrevs[abbrev]} / ${osis}`);
			}
			abbrevs[osis] = abbrevs[osis] ?? [];
			abbrevs[osis].push(abbrev);
			all_abbrevs[abbrev] = osis;
		});
	});
	Object.keys(abbrevs).forEach((osis) => {
		abbrevs[osis].sort((a, b) => b.length - a.length);
		// abbrevs[osis] = abbrevs[osis].map((abbrev) => abbrev.toLowerCase());
	});
	let i = 1;
	while (order.length > 1) {
		const osis = order.shift();
		console.log(`${i}. ${osis}`);
		i++;
		for (const abbrev of abbrevs[osis]) {
			const safe_abbrev = quote_meta(abbrev);
			for (const compare_osis of order) {
				abbrevs[compare_osis] = abbrevs[compare_osis] ?? [];
				for (const compare of abbrevs[compare_osis]) {
					// sorted by length, so there will never be a shorter one
					if (compare.length <= abbrev.length) {
						break;
					}
					if (
						!new RegExp(`(?:^|\\b|[\\s-])${safe_abbrev}(?:[\\s-]|\\b|$)`).test(
							compare
						)
					) {
						continue;
					}
					fs.writeSync(
						fd,
						`${osis}\t${abbrev}\n${compare_osis}\t${compare}\n\n`
					);
					console.log(
						`Conflict:\n         ${osis}:\t${abbrev}\n         ${compare_osis}:\t${compare}`
					);
				}
			}
		}
	}
}

function get_matches(
	pattern,
	abbrevs,
	exclude_langs,
	exclude_abbrevs,
	used_langs
) {
	const out = [];
	abbrevs.forEach((abbrev) => {
		if (!new RegExp(`^${pattern}+$`).test(abbrev)) {
			return;
		}
		if (exclude_abbrevs[abbrev]) {
			return;
		}
		let ok = 0;
		langs[abbrev].forEach((lang) => {
			if (exclude_langs[lang]) {
				return;
			}
			used_langs[lang] = used_langs[lang] ?? 0;
			used_langs[lang]++;
			ok = 1;
		});
		if (ok) {
			out.push(abbrev);
		}
	});
	out.sort((a, b) => b.length - a.length);
	return out;
}

function arrange_abbrevs_by_osis() {
	const out = {};
	const langs = {};
	Object.keys(abbrevs).forEach((abbrev) => {
		let osis = Object.keys(abbrevs[abbrev]);
		if (Object.keys(abbrevs[abbrev]).length > 1) {
			osis = prioritize_lang(abbrev, abbrevs[abbrev]);
		}
		out[osis] = out[osis] ?? [];
		out[osis].push(abbrev);
		Object.keys(abbrevs[abbrev][osis]).forEach((lang) => {
			if (/[^a-z]/.test(lang)) {
				throw new Error(`${lang}\n${abbrev}\n${abbrevs[abbrev]}`);
			}
			langs[abbrev] = langs[abbrev] ?? [];
			langs[abbrev].push(lang);
		});
	});
	return [langs, out];
}

function prioritize_lang(abbrev, ref) {
	for (const lang of lang_priorities) {
		for (const osis of Object.keys(ref)) {
			if (ref[osis][lang]) {
				return osis;
			}
		}
	}
	console.log(`No lang priority for: ${abbrev}`, ref);
	return "";
}

function get_abbrevs(range) {
	const out = {};
	fs.readdirSync(src_dir).forEach((lang) => {
		if (lang.length > 3) {
			return;
		}
		if (!/^\w+$/.test(lang)) {
			return;
		}
		if (!fs.existsSync(`${src_dir}/${lang}/book_names.txt`)) {
			return;
		}
		get_abbrevs_from_file(`${src_dir}/${lang}/book_names.txt`, out, lang);
	});
	if (
		fs.existsSync(`${src_dir}/extra/book_names.txt`) &&
		range.include_extra_abbrevs
	) {
		get_abbrevs_from_file(`${src_dir}/extra/book_names.txt`, out);
	}
	return out;
}

function get_abbrevs_from_file(file, abbrevs, lang) {
	const data = fs.readFileSync(file).toString();
	data.split("\n").forEach((line) => {
		if (/^#/.test(line)) {
			return;
		}
		line = line.replace(/\s+$/, "");
		const [osis, abbrev, ...langs] = line.split("\t");
		if (!osis.length) {
			return;
		}
		if (langs.length) {
			langs.forEach((l) => {
				abbrevs[abbrev] = abbrevs[abbrev] ?? {};
				abbrevs[abbrev][osis] = abbrevs[abbrev][osis] ?? {};
				abbrevs[abbrev][osis][l] = abbrevs[abbrev][osis][l] ?? 0;
				abbrevs[abbrev][osis][l]++;
			});
		} else {
			abbrevs[abbrev] = abbrevs[abbrev] ?? {};
			abbrevs[abbrev][osis] = abbrevs[abbrev][osis] ?? {};
			abbrevs[abbrev][osis][lang] = abbrevs[abbrev][osis][lang] ?? 0;
			abbrevs[abbrev][osis][lang]++;
		}
	});
}

function quote_meta(str) {
	return str.replace(/[[\]{}()*+?.,\\^$|#]/g, "\\$&");
}
