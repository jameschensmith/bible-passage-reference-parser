import { bcv_parser } from "../core";

bcv_parser.prototype.regexps.space = "[\\s\\xa0]";
/*
 * - Line 1		- Beginning of string or not in the middle of a word or immediately following another book. Only count a book if it's part of a sequence: `Matt5John3` is OK, but not `1Matt5John3`
 * - Lines 3-13	- inverted book/chapter (cb)
 * - Line 11	- no plurals here since it's a single chapter
 * - Line 14	- book
 * - Line 16	- special Psalm chapters
 * - Line 18	- could be followed by a number
 * - Line 20	- a-e allows 1:1a
 * - Line 21	- or the end of the string
 */
bcv_parser.prototype.regexps.escaped_passage = new RegExp(`\
(?:^|[^\\x1f\\x1e\\dA-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])\
(\
(?:\
(?:ch(?:apters?|a?pts?\\.?|a?p?s?\\.?)?\\s*\
\\d+\\s*(?:[\\u2013\\u2014\\-]|through|thru|to)\\s*\\d+\\s*\
(?:from|of|in)(?:\\s+the\\s+book\\s+of)?\\s*)\
|(?:ch(?:apters?|a?pts?\\.?|a?p?s?\\.?)?\\s*\
\\d+\\s*\
(?:from|of|in)(?:\\s+the\\s+book\\s+of)?\\s*)\
|(?:\\d+(?:th|nd|st)\\s*\
ch(?:apter|a?pt\\.?|a?p?\\.?)?\\s*\
(?:from|of|in)(?:\\s+the\\s+book\\s+of)?\\s*)\
)?\
\\x1f(\\d+)(?:/\\d+)?\\x1f\
(?:\
/\\d+\\x1f\
|[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014]\
|title(?![a-z])\
|kapitlerne|kapitel|vers|kap|ff|og|jf|-|v\
|[a-e](?!\\w)\
|$\
)+\
)`, "gi");
// These are the only valid ways to end a potential passage match. The closing parenthesis allows for fully capturing parentheses surrounding translations (ESV**)**. The last one, `[\d\x1f]` needs not to be +; otherwise `Gen5ff` becomes `\x1f0\x1f5ff`, and `adjust_regexp_end` matches the `\x1f5` and incorrectly dangles the ff.
// 'ff09' is a full-width closing parenthesis.
bcv_parser.prototype.regexps.match_end_split = new RegExp(`\
\\d\\W*title\
|\\d\\W*ff(?:[\\s\\xa0*]*\\.)?\
|\\d[\\s\\xa0*]*[a-e](?!\\w)\
|\\x1e(?:[\\s\\xa0*]*[)\\]\\uff09])?\
|[\\d\\x1f]`, "gi");
bcv_parser.prototype.regexps.control = /[\x1e\x1f]/g;
bcv_parser.prototype.regexps.pre_book = "[^A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ]";

bcv_parser.prototype.regexps.first = `(?:Første|1)\\.?${bcv_parser.prototype.regexps.space}*`;
bcv_parser.prototype.regexps.second = `(?:Anden|2)\\.?${bcv_parser.prototype.regexps.space}*`;
bcv_parser.prototype.regexps.third = `(?:Tredje|3)\\.?${bcv_parser.prototype.regexps.space}*`;
bcv_parser.prototype.regexps.range_and = `(?:[&\u2013\u2014-]|(?:og|jf)|-)`;
bcv_parser.prototype.regexps.range_only = "(?:[\u2013\u2014-]|-)";
// Each book regexp should return two parenthesized objects: an optional preliminary character and the book itself.
bcv_parser.prototype.regexps.get_books = (include_apocrypha: boolean, case_sensitive: string) => {
	const books = [
		{
			osis: ["Ps"],
			apocrypha: true,
			extra: "2",
			/*
			 * - Don't match a preceding \d like usual because we only want to match a valid OSIS, which will never have a preceding digit.
			 * - Always followed by ".1"; the regular Psalms parser can handle `Ps151` on its own.
			 * - Case-sensitive because we only want to match a valid OSIS.
			 */
			regexp: /(\b)(Ps151)(?=\.1)/g
		},
		{
			osis: ["Gen"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:F\\xF8rste[\\s\\xa0]*Mos(?:ebog)?|1\\.[\\s\\xa0]*Mos(?:ebog)?|1[\\s\\xa0]*Mos(?:ebog)?|Gen(?:esis)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Exod"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Anden[\\s\\xa0]*Mos(?:ebog)?|2\\.[\\s\\xa0]*Mos(?:ebog)?|2[\\s\\xa0]*Mos(?:ebog)?|Exod(?:us)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Bel"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Bel(?:[\\s\\xa0]*og[\\s\\xa0]*Dragen)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Lev"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Tredje[\\s\\xa0]*Mos(?:ebog)?|3\\.[\\s\\xa0]*Mos(?:ebog)?|Lev(?:iticus)?|3[\\s\\xa0]*Mos(?:ebog)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Num"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Fjerde[\\s\\xa0]*Mos(?:ebog)?|4\\.[\\s\\xa0]*Mos(?:ebog)?|4[\\s\\xa0]*Mos(?:ebog)?|Num(?:eri)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Sir"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Sir(?:ak(?:s[\\s\\xa0]*Bog)?)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Wis"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Visdommen(?:s[\\s\\xa0]*Bog)?|Wis))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Lam"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Klag(?:es(?:angene)?)?|Lam))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["EpJer"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Jeremias['’][\\s\\xa0]*Brev|EpJer))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Rev"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Joh(?:annes(?:['’][\\s\\xa0]*[A\\xC5]benbaring|apokalypsen)|s(?:\\.[\\s\\xa0]*[A\\xC5]|[\\s\\xa0]*[A\\xC5])benbaring)|(?:\\xC5benbaringsbo|A(?:benbaringsbo|abenbarin))gen|[A\\xC5]benbaringen|Apokalypsen|Rev|[A\\xC5]b))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["PrMan"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:(?:Manasses[\\s\\xa0]*B\\xF8|PrMa)n))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Deut"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:(?:Femte|5\\.?)[\\s\\xa0]*Mosebog|Deut(?:eronomium)?|(?:Femte|5\\.?)[\\s\\xa0]*Mos))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Josh"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Jos(?:va(?:s[\\s\\xa0]*Bog|bog(?:en)?)|ua|h)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Judg"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Dom(?:mer(?:bogen)?)?|Judg))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Ruth"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Rut(?:h(?:s[\\s\\xa0]*Bog)?)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Esd"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Tredje[\\s\\xa0]*Esdrasbog|F\\xF8rste[\\s\\xa0]*Esdrasbog|[13]\\.[\\s\\xa0]*Esdrasbog|[13][\\s\\xa0]*Esdrasbog|1Esd))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Esd"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Fjerde[\\s\\xa0]*Esdrasbog|(?:Anden|[24]\\.)[\\s\\xa0]*Esdrasbog|[24][\\s\\xa0]*Esdrasbog|2Esd))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Isa"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Es(?:ajas(?:['’][\\s\\xa0]*Bog)?)?|(?:Jesai|Is)a))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Sam"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Anden[\\s\\xa0]*(?:Kongerigernes[\\s\\xa0]*Bog|Sam(?:uelsbog|uel)?)|2(?:\\.[\\s\\xa0]*(?:Kongerigernes[\\s\\xa0]*Bog|Sam(?:uelsbog|uel)?)|[\\s\\xa0]*(?:Kongerigernes[\\s\\xa0]*Bog|Sam(?:uelsbog|uel)?)|Sam)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Sam"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:F\\xF8rste[\\s\\xa0]*(?:Kongerigernes[\\s\\xa0]*Bog|Sam(?:uelsbog|uel)?)|1(?:\\.[\\s\\xa0]*(?:Kongerigernes[\\s\\xa0]*Bog|Sam(?:uelsbog|uel)?)|[\\s\\xa0]*(?:Kongerigernes[\\s\\xa0]*Bog|Sam(?:uelsbog|uel)?)|Sam)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Kgs"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Fjerde[\\s\\xa0]*Kongerigernes[\\s\\xa0]*Bog|4\\.[\\s\\xa0]*Kongerigernes[\\s\\xa0]*Bog|4[\\s\\xa0]*Kongerigernes[\\s\\xa0]*Bog|(?:Anden|2\\.?)[\\s\\xa0]*Kongebog|(?:Anden|2\\.?)[\\s\\xa0]*Kong|2Kgs))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Kgs"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Tredje[\\s\\xa0]*Kongerigernes[\\s\\xa0]*Bog|3\\.[\\s\\xa0]*Kongerigernes[\\s\\xa0]*Bog|3[\\s\\xa0]*Kongerigernes[\\s\\xa0]*Bog|(?:F\\xF8rste|1\\.?)[\\s\\xa0]*Kongebog|(?:F\\xF8rste|1\\.?)[\\s\\xa0]*Kong|1Kgs))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Chr"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Anden[\\s\\xa0]*Kr(?:\\xF8n(?:ikebog)?|on)|2(?:\\.[\\s\\xa0]*Kr(?:\\xF8n(?:ikebog)?|on)|[\\s\\xa0]*Kr(?:\\xF8n(?:ikebog)?|on)|Chr)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Chr"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:F\\xF8rste[\\s\\xa0]*Kr(?:\\xF8n(?:ikebog)?|on)|1(?:\\.[\\s\\xa0]*Kr(?:\\xF8n(?:ikebog)?|on)|[\\s\\xa0]*Kr(?:\\xF8n(?:ikebog)?|on)|Chr)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Ezra"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Ezra(?:s[\\s\\xa0]*Bog)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Neh"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Neh(?:emias(?:’[\\s\\xa0]*Bog)?)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["GkEsth"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:GkEsth))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Esth"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Est(?:er(?:s[\\s\\xa0]*Bog)?|h)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Job"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Job(?:s[\\s\\xa0]*Bog)?|Hiob))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Ps"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:S(?:alme(?:rne(?:s[\\s\\xa0]*Bog)?)?|l)|Ps))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["PrAzar"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Azarjas[\\s\\xa0]*[Bb]\\xF8n|PrAzar))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Prov"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Ordsp(?:rogene(?:s[\\s\\xa0]*Bog)?)?|Prov))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Eccl"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Pr(?:\\xE6d(?:ikeren(?:s[\\s\\xa0]*Bog)?)?|ad)|Eccl))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["SgThree"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:De[\\s\\xa0]*(?:tre[\\s\\xa0]*m\\xE6nds[\\s\\xa0]*l|Tre[\\s\\xa0]*M\\xE6nds[\\s\\xa0]*L)ovsang|SgThree))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Song"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:S(?:alomons[\\s\\xa0]*H\\xF8jsa|o)ng|H(?:\\xF8jsangen|\\xF8js|ojs)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jer"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Jer(?:emias(?:['’][\\s\\xa0]*Bog)?)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Ezek"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Ez(?:ek(?:iel(?:s’?[\\s\\xa0]*Bog)?)?)?|Hezechiel))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Dan"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Dan(?:iel(?:s[\\s\\xa0]*Bog)?)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Hos"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Hos(?:eas(?:’[\\s\\xa0]*Bog)?)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Joel"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Joel(?:s[\\s\\xa0]*Bog)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Amos"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Am(?:os(?:['’][\\s\\xa0]*Bog)?)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Obad"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Obad(?:ias(?:['’][\\s\\xa0]*Bog)?)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jonah"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Jon(?:a(?:s(?:['’][\\s\\xa0]*Bog)?|h))?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Mic"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Mi(?:ka(?:s(?:[\\s\\xa0]*Bog)?)?|c)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Nah"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Nah(?:um(?:s[\\s\\xa0]*Bog)?)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Hab"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Hab(?:akkuk(?:s[\\s\\xa0]*Bog)?)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Zeph"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Ze(?:fanias’[\\s\\xa0]*Bog|f(?:anias)?|ph)|Sef(?:anias['’][\\s\\xa0]*Bog)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Hag"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Hag(?:g(?:aj(?:s[\\s\\xa0]*Bog)?)?)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Zech"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Z(?:ak(?:arias(?:['’][\\s\\xa0]*Bog)?)?|ech)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Mal"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Mal(?:akias(?:’[\\s\\xa0]*Bog)?)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Matt"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Matt(?:h\\xE6us(?:evangeliet)?|\\xE6usevangeliet)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Mark"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Mark(?:us(?:evangeliet)?)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Luke"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:L(?:uk(?:as(?:evangeliet)?|e)?|k)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1John"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:1John)|(?:Johannes(?:['’][\\s\\xa0]*(?:F\\xF8rste|1\\.)[\\s\\xa0]*|['’][\\s\\xa0]*1[\\s\\xa0]*)Brev|F\\xF8rste[\\s\\xa0]*Joh(?:annes(?:['’][\\s\\xa0]*B|b)rev)?|1\\.[\\s\\xa0]*Joh(?:annes(?:['’][\\s\\xa0]*B|b)rev)?|1[\\s\\xa0]*Joh(?:annes(?:['’][\\s\\xa0]*B|b)rev)?)|(?:(?:F\\xF8rste|1\\.?)[\\s\\xa0]*Johannes))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2John"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:2John)|(?:Johannes['’][\\s\\xa0]*Andet[\\s\\xa0]*Brev|Ande(?:n[\\s\\xa0]*Joh(?:annes(?:['’][\\s\\xa0]*Brev|brev)?)?|t[\\s\\xa0]*Johannesbrev)|2\\.[\\s\\xa0]*Joh(?:annes(?:['’][\\s\\xa0]*Brev|brev)?)?|2[\\s\\xa0]*Joh(?:annes(?:['’][\\s\\xa0]*Brev|brev)?)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["3John"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:3John)|(?:(?:Tredje[\\s\\xa0]*Johannes['’]|3(?:\\.[\\s\\xa0]*Johannes['’]|[\\s\\xa0]*Johannes['’]))[\\s\\xa0]*Brev|Johannes['’][\\s\\xa0]*(?:Tredje|3\\.?)[\\s\\xa0]*Brev|(?:Tredje|3\\.?)[\\s\\xa0]*Johannesbrev|(?:Tredje|3\\.?)[\\s\\xa0]*Joh)|(?:(?:Tredje|3\\.?)[\\s\\xa0]*Johannes))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["John"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Joh(?:annes(?:evangeliet)?|n)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Acts"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:A(?:p(?:ostlenes[\\s\\xa0]*Gerninger|\\.G|[Gg])|cts)|Gerninger))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Rom"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Paulus['’][\\s\\xa0]*Brev[\\s\\xa0]*til[\\s\\xa0]*Romerne|Rom(?:erbrevet|erne)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Cor"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Paulus['’][\\s\\xa0]*Andet[\\s\\xa0]*Brev[\\s\\xa0]*til[\\s\\xa0]*Korintherne|Ande(?:t[\\s\\xa0]*Korinth|n[\\s\\xa0]*Korinth?)erbrev|2(?:\\.[\\s\\xa0]*Korinth?erbrev|[\\s\\xa0]*Korinth?erbrev|Cor)|(?:Anden|2\\.?)[\\s\\xa0]*Korinterne|(?:Anden|2\\.?)[\\s\\xa0]*Kor))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Cor"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Paulus['’][\\s\\xa0]*(?:F\\xF8rste|1\\.?)[\\s\\xa0]*Brev[\\s\\xa0]*til[\\s\\xa0]*Korintherne|F\\xF8rste[\\s\\xa0]*Korinth?erbrev|(?:F\\xF8rste|1\\.?)[\\s\\xa0]*Korinterne|1(?:\\.[\\s\\xa0]*Korinth?erbrev|[\\s\\xa0]*Korinth?erbrev|Cor)|(?:F\\xF8rste|1\\.?)[\\s\\xa0]*Kor))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Gal"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Paulus['’][\\s\\xa0]*Brev[\\s\\xa0]*til[\\s\\xa0]*Galaterne|Brevet[\\s\\xa0]*til[\\s\\xa0]*Galaterne|Gal(?:aterbrevet|aterne)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Eph"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Paulus['’][\\s\\xa0]*Brev[\\s\\xa0]*til[\\s\\xa0]*Efeserne|E(?:feserbrevet|feserne|ph|f)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Phil"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:P(?:aulus['’][\\s\\xa0]*Brev[\\s\\xa0]*til[\\s\\xa0]*Filipperne|hil)|Fil(?:ipperbrevet|ipperne)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Col"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Paulus['’][\\s\\xa0]*Brev[\\s\\xa0]*til[\\s\\xa0]*Kolossenserne|Kolossenser(?:brevet|n)|Kol|Col))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Thess"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Paulus['’][\\s\\xa0]*Andet[\\s\\xa0]*Brev[\\s\\xa0]*til[\\s\\xa0]*Thessalonikerne|Ande[nt][\\s\\xa0]*Thessalonikerbrev|2(?:\\.[\\s\\xa0]*Thessalonikerbrev|[\\s\\xa0]*Thessalonikerbrev|Thess)|(?:Anden|2\\.?)[\\s\\xa0]*Tessalonikerne|(?:Anden|2\\.?)[\\s\\xa0]*Thess))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Thess"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Paulus['’][\\s\\xa0]*(?:F\\xF8rste|1\\.?)[\\s\\xa0]*Brev[\\s\\xa0]*til[\\s\\xa0]*Thessalonikerne|F\\xF8rste[\\s\\xa0]*Thessalonikerbrev|(?:F\\xF8rste|1\\.?)[\\s\\xa0]*Tessalonikerne|1(?:\\.[\\s\\xa0]*Thessalonikerbrev|[\\s\\xa0]*Thessalonikerbrev|Thess)|(?:F\\xF8rste|1\\.?)[\\s\\xa0]*Thess))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Tim"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Paulus['’][\\s\\xa0]*Andet[\\s\\xa0]*Brev[\\s\\xa0]*til[\\s\\xa0]*Timotheus|Ande(?:t[\\s\\xa0]*Timoth|n[\\s\\xa0]*Timoth?)eusbrev|2(?:\\.[\\s\\xa0]*Timoth?eusbrev|[\\s\\xa0]*Timoth?eusbrev|Tim)|Anden[\\s\\xa0]*Tim(?:oteus)?|2(?:\\.[\\s\\xa0]*Tim(?:oteus)?|[\\s\\xa0]*Tim(?:oteus)?)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Tim"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Paulus['’][\\s\\xa0]*(?:F\\xF8rste|1\\.?)[\\s\\xa0]*Brev[\\s\\xa0]*til[\\s\\xa0]*Timotheus|F\\xF8rste[\\s\\xa0]*Timoth?eusbrev|1(?:\\.[\\s\\xa0]*Timoth?eusbrev|[\\s\\xa0]*Timoth?eusbrev|Tim)|F\\xF8rste[\\s\\xa0]*Tim(?:oteus)?|1(?:\\.[\\s\\xa0]*Tim(?:oteus)?|[\\s\\xa0]*Tim(?:oteus)?)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Titus"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Paulus['’][\\s\\xa0]*Brev[\\s\\xa0]*til[\\s\\xa0]*Titus|Tit(?:usbrevet|us)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Phlm"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:P(?:aulus['’][\\s\\xa0]*Brev[\\s\\xa0]*til[\\s\\xa0]*Filemon|hlm)|F(?:ilemonbrevet|ilem(?:on)?|lm)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Heb"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Brevet[\\s\\xa0]*til[\\s\\xa0]*Hebr\\xE6erne|Heb(?:r\\xE6erbrevet|r\\xE6erne|r)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jas"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Ja(?:k(?:ob(?:s(?:brevet|[\\s\\xa0]*Brev))?)?|s)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Pet"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Peters[\\s\\xa0]*Andet[\\s\\xa0]*Brev|(?:Ande[nt]|2\\.?)[\\s\\xa0]*Petersbrev|Anden[\\s\\xa0]*Pet(?:er)?|2(?:\\.[\\s\\xa0]*Pet(?:er)?|[\\s\\xa0]*Pet(?:er)?)|2Pet))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Pet"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Peters[\\s\\xa0]*(?:F\\xF8rste|1\\.?)[\\s\\xa0]*Brev|(?:F\\xF8rste|1\\.?)[\\s\\xa0]*Petersbrev|F\\xF8rste[\\s\\xa0]*Pet(?:er)?|1(?:\\.[\\s\\xa0]*Pet(?:er)?|[\\s\\xa0]*Pet(?:er)?)|1Pet))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jude"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Jud(?:as(?:brevet|['’][\\s\\xa0]*Brev)?|e)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Tob"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Tob(?:it(?:s[\\s\\xa0]*Bog)?)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jdt"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:J(?:udit(?:s[\\s\\xa0]*Bog)?|dt)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Bar"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Bar(?:uk(?:s[\\s\\xa0]*Bog)?)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Sus"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Sus(?:anna)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Macc"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Anden[\\s\\xa0]*Makk(?:ab\\xE6erbog)?|2(?:\\.[\\s\\xa0]*Makk(?:ab\\xE6erbog)?|[\\s\\xa0]*Makk(?:ab\\xE6erbog)?|Macc)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["3Macc"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Tredje[\\s\\xa0]*Makk(?:ab\\xE6erbog)?|3(?:\\.[\\s\\xa0]*Makk(?:ab\\xE6erbog)?|[\\s\\xa0]*Makk(?:ab\\xE6erbog)?|Macc)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["4Macc"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Fjerde[\\s\\xa0]*Makk(?:ab\\xE6erbog)?|4(?:\\.[\\s\\xa0]*Makk(?:ab\\xE6erbog)?|[\\s\\xa0]*Makk(?:ab\\xE6erbog)?|Macc)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Macc"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:F\\xF8rste[\\s\\xa0]*Makk(?:ab\\xE6erbog)?|1(?:\\.[\\s\\xa0]*Makk(?:ab\\xE6erbog)?|[\\s\\xa0]*Makk(?:ab\\xE6erbog)?|Macc)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
	];
	// Short-circuit the look if we know we want all the books.
	if ((include_apocrypha) && (case_sensitive === "none")) { return books; }
	// Filter out books in the Apocrypha if we don't want them. `Array.map` isn't supported below IE9.
	const out = [];
	for (const book of books) {
		if ((!include_apocrypha) && (book.apocrypha != null) && (book.apocrypha)) { continue; }
		if (case_sensitive === "books") {
			book.regexp = new RegExp(book.regexp.source, "g");
		}
		out.push(book);
	}
	return out;
};

// Default to not using the Apocrypha
bcv_parser.prototype.regexps.books = bcv_parser.prototype.regexps.get_books(false, "none");
