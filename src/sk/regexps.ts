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
|ver[šs]ov|kapitoly|kapitole|kapitolu|kapitol|hlavy|a[žz]|porov|pozri|alebo|kap|ff|-|a\
|[b-e](?!\\w)\
|$\
)+\
)`, "gi");
// These are the only valid ways to end a potential passage match. The closing parenthesis allows for fully capturing parentheses surrounding translations (ESV**)**. The last one, `[\d\x1f]` needs not to be +; otherwise `Gen5ff` becomes `\x1f0\x1f5ff`, and `adjust_regexp_end` matches the `\x1f5` and incorrectly dangles the ff.
// 'ff09' is a full-width closing parenthesis.
bcv_parser.prototype.regexps.match_end_split = new RegExp(`\
\\d\\W*title\
|\\d\\W*ff(?:[\\s\\xa0*]*\\.)?\
|\\d[\\s\\xa0*]*[b-e](?!\\w)\
|\\x1e(?:[\\s\\xa0*]*[)\\]\\uff09])?\
|[\\d\\x1f]`, "gi");
bcv_parser.prototype.regexps.control = /[\x1e\x1f]/g;
bcv_parser.prototype.regexps.pre_book = "[^A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ]";

bcv_parser.prototype.regexps.first = `(?:Prv[áa]${bcv_parser.prototype.regexps.space}+kniha|Prv[ýy]${bcv_parser.prototype.regexps.space}+list|Prv[áa]|Prv[ýy]|1${bcv_parser.prototype.regexps.space}+k|I|1)\\.?${bcv_parser.prototype.regexps.space}*`;
bcv_parser.prototype.regexps.second = `(?:Druh[áa]${bcv_parser.prototype.regexps.space}+kniha|Druh[ýy]${bcv_parser.prototype.regexps.space}+list|Druh[áa]|Druh[ýy]|2${bcv_parser.prototype.regexps.space}+k|II|2)\\.?${bcv_parser.prototype.regexps.space}*`;
bcv_parser.prototype.regexps.third = `(?:Tretia${bcv_parser.prototype.regexps.space}+kniha|Tretia|Tret[íi]|3${bcv_parser.prototype.regexps.space}+k|III|3)\\.?${bcv_parser.prototype.regexps.space}*`;
bcv_parser.prototype.regexps.range_and = `(?:[&\u2013\u2014-]|(?:porov|pozri|alebo|a)|(?:a[žz]|-))`;
bcv_parser.prototype.regexps.range_only = "(?:[\u2013\u2014-]|(?:a[žz]|-))";
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
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Prv(?:[a\\xE1][\\s\\xa0]*(?:kniha[\\s\\xa0]*Moj[zž]i[sš]|Moj[zž]i[sš])|[y\\xFD][\\s\\xa0]*list[\\s\\xa0]*Moj[zž]i[sš]|[y\\xFD][\\s\\xa0]*Moj[zž]i[sš])ova|K(?:niha|\\.)?[\\s\\xa0]*stvorenia|(?:1(?:[\\s\\xa0]*k)?|I)\\.[\\s\\xa0]*Moj[zž]i[sš]ova|(?:1[\\s\\xa0]*k|I)[\\s\\xa0]*Moj[zž]i[sš]ova|K(?:niha[\\s\\xa0]*p[o\\xF4]|\\.[\\s\\xa0]*p[o\\xF4]|[\\s\\xa0]*p[o\\xF4])vodu|1[\\s\\xa0]*Moj[zž]i[sš]ova|G(?:enezis|n)|Gen|1[\\s\\xa0]*M))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Exod"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Druh(?:[a\\xE1][\\s\\xa0]*(?:kniha[\\s\\xa0]*Moj[zž]i[sš]|Moj[zž]i[sš])|[y\\xFD][\\s\\xa0]*list[\\s\\xa0]*Moj[zž]i[sš]|[y\\xFD][\\s\\xa0]*Moj[zž]i[sš])ova|(?:2(?:[\\s\\xa0]*k)?|II)\\.[\\s\\xa0]*Moj[zž]i[sš]ova|(?:2[\\s\\xa0]*k|II)[\\s\\xa0]*Moj[zž]i[sš]ova|2[\\s\\xa0]*Moj[zž]i[sš]ova|Exodus|Ex(?:od)?|2[\\s\\xa0]*M))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Bel"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:B[e\\xE9]l(?:[\\s\\xa0]*a[\\s\\xa0]*drak)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Lev"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Tret(?:i(?:a[\\s\\xa0]*(?:kniha[\\s\\xa0]*Moj[zž]i[sš]|Moj[zž]i[sš])|[\\s\\xa0]*Moj[zž]i[sš])|\\xED[\\s\\xa0]*Moj[zž]i[sš])ova|(?:III|3(?:[\\s\\xa0]*k)?)\\.[\\s\\xa0]*Moj[zž]i[sš]ova|(?:III|3[\\s\\xa0]*k)[\\s\\xa0]*Moj[zž]i[sš]ova|3[\\s\\xa0]*Moj[zž]i[sš]ova|L(?:evitikus|v)|Lev|3[\\s\\xa0]*M))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Num"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:[SŠ]tvrt[a\\xE1][\\s\\xa0]*(?:kniha[\\s\\xa0]*Moj[zž]i[sš]|Moj[zž]i[sš])ova|(?:4(?:[\\s\\xa0]*k)?|IV)\\.[\\s\\xa0]*Moj[zž]i[sš]ova|(?:4[\\s\\xa0]*k|IV)[\\s\\xa0]*Moj[zž]i[sš]ova|4[\\s\\xa0]*Moj[zž]i[sš]ova|N(?:umeri|m)|Num|4[\\s\\xa0]*M))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Sir"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:K(?:niha[\\s\\xa0]*(?:Sirachov(?:ho[\\s\\xa0]*syn|c(?:ov)?)a|Ekleziastikus)|\\.[\\s\\xa0]*(?:Sirachov(?:ho[\\s\\xa0]*syn|c(?:ov)?)a|Ekleziastikus)|[\\s\\xa0]*(?:Sirachov(?:ho[\\s\\xa0]*syn|c(?:ov)?)a|Ekleziastikus))|Sir(?:achovcova|achovec)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Wis"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:M[u\\xFA]d(?:ros(?:ti?|ť))?|Wis))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Lam"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Pla[cč][\\s\\xa0]*Jeremi[a\\xE1][sš]ov|Jeremi[a\\xE1][sš]ov[\\s\\xa0]*Pla[cč]|K(?:niha[\\s\\xa0]*n[a\\xE1]|\\.[\\s\\xa0]*n[a\\xE1]|[\\s\\xa0]*n[a\\xE1])rekov|[ZŽ]alospevy|[ZŽ]alosp|N[a\\xE1]reky|N[a\\xE1]r|Lam)|(?:Pla[cč]))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["EpJer"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Jeremi[a\\xE1][sš]ov[\\s\\xa0]*list|EpJer))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Rev"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Zj(?:av(?:enie(?:[\\s\\xa0]*(?:Apo[sš]tola[\\s\\xa0]*J[a\\xE1]|sv[a\\xE4]t[e\\xE9]ho[\\s\\xa0]*J[a\\xE1]|J[a\\xE1])na)?)?|v)?|Apokalypsa|Rev))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["PrMan"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Manasesova[\\s\\xa0]*modlitba|PrMan))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Deut"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Piata[\\s\\xa0]*(?:kniha[\\s\\xa0]*Moj[zž]i[sš]|Moj[zž]i[sš])ova|(?:5(?:[\\s\\xa0]*k)?|V)\\.[\\s\\xa0]*Moj[zž]i[sš]ova|D(?:euteron[o\\xF3]mium|t)|(?:5[\\s\\xa0]*k|V)[\\s\\xa0]*Moj[zž]i[sš]ova|5[\\s\\xa0]*Moj[zž]i[sš]ova|Deut|5[\\s\\xa0]*M))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Josh"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:J(?:\\xF3zu(?:ov)?a|o(?:z(?:uova|u[ae])?|šu(?:ov)?a|s(?:u(?:ov)?a|h)))|Iosua))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Judg"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:K\\.?[\\s\\xa0]*sudcov|S(?:udcovia|dc)|Sud(?:cov)?|Judg))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Ruth"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:R(?:uth?|\\xFAt)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Esd"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Prv(?:[a\\xE1][\\s\\xa0]*(?:kniha[\\s\\xa0]*Ezdr[a\\xE1][sš](?:ova)?|Ezdr[a\\xE1][sš](?:ova)?)|[y\\xFD][\\s\\xa0]*list[\\s\\xa0]*Ezdr[a\\xE1][sš](?:ova)?|[y\\xFD][\\s\\xa0]*Ezdr[a\\xE1][sš](?:ova)?)|(?:1(?:[\\s\\xa0]*k)?|I)\\.[\\s\\xa0]*Ezdr[a\\xE1][sš](?:ova)?|(?:1[\\s\\xa0]*k|I)[\\s\\xa0]*Ezdr[a\\xE1][sš](?:ova)?|1(?:[\\s\\xa0]*Ezdr[a\\xE1][sš](?:ova)?|Esd)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Esd"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Druh(?:[a\\xE1][\\s\\xa0]*(?:kniha[\\s\\xa0]*Ezdr[a\\xE1][sš](?:ova)?|Ezdr[a\\xE1][sš](?:ova)?)|[y\\xFD][\\s\\xa0]*list[\\s\\xa0]*Ezdr[a\\xE1][sš](?:ova)?|[y\\xFD][\\s\\xa0]*Ezdr[a\\xE1][sš](?:ova)?)|(?:2(?:[\\s\\xa0]*k)?|II)\\.[\\s\\xa0]*Ezdr[a\\xE1][sš](?:ova)?|(?:2[\\s\\xa0]*k|II)[\\s\\xa0]*Ezdr[a\\xE1][sš](?:ova)?|2(?:[\\s\\xa0]*Ezdr[a\\xE1][sš](?:ova)?|Esd)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Isa"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:I(?:z(?:a[ij][a\\xE1][sš])?|sa)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Sam"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Druh(?:[a\\xE1][\\s\\xa0]*(?:kniha[\\s\\xa0]*)?|(?:[y\\xFD][\\s\\xa0]*list|[y\\xFD])[\\s\\xa0]*)Samuelova|(?:2(?:[\\s\\xa0]*k)?|II)\\.[\\s\\xa0]*Samuelova|(?:2[\\s\\xa0]*k|II)[\\s\\xa0]*Samuelova|2(?:[\\s\\xa0]*Samuelova|[\\s\\xa0]*S(?:am)?|Sam)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Sam"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Prv(?:[a\\xE1][\\s\\xa0]*(?:kniha[\\s\\xa0]*)?|(?:[y\\xFD][\\s\\xa0]*list|[y\\xFD])[\\s\\xa0]*)Samuelova|(?:1(?:[\\s\\xa0]*k)?|I)\\.[\\s\\xa0]*Samuelova|(?:1[\\s\\xa0]*k|I)[\\s\\xa0]*Samuelova|1(?:[\\s\\xa0]*Samuelova|[\\s\\xa0]*S(?:am)?|Sam)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Kgs"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:[SŠ]tvrt[a\\xE1][\\s\\xa0]*(?:kniha[\\s\\xa0]*Kr[a\\xE1][lľ]|Kr[a\\xE1][lľ])ov|Druh[a\\xE1][\\s\\xa0]*(?:kniha[\\s\\xa0]*Kr[a\\xE1][lľ]|Kr[a\\xE1][lľ])ov|(?:Druh[y\\xFD][\\s\\xa0]*list|(?:4[\\s\\xa0]*k|2(?:[\\s\\xa0]*k)?|I[IV]|4)\\.)[\\s\\xa0]*Kr[a\\xE1][lľ]ov|(?:Druh[y\\xFD]|4)[\\s\\xa0]*Kr[a\\xE1][lľ]ov|(?:4[\\s\\xa0]*k|2[\\s\\xa0]*k|I[IV])[\\s\\xa0]*Kr[a\\xE1][lľ]ov|2(?:[\\s\\xa0]*Kr[a\\xE1][lľ]ov|[\\s\\xa0]*Kr[lľ]|[\\s\\xa0]*Kr|Kgs)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Kgs"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Tret(?:i(?:a[\\s\\xa0]*(?:kniha[\\s\\xa0]*Kr[a\\xE1][lľ]|Kr[a\\xE1][lľ])|[\\s\\xa0]*Kr[a\\xE1][lľ])|\\xED[\\s\\xa0]*Kr[a\\xE1][lľ])ov|Prv[a\\xE1][\\s\\xa0]*(?:kniha[\\s\\xa0]*Kr[a\\xE1][lľ]|Kr[a\\xE1][lľ])ov|(?:Prv[y\\xFD][\\s\\xa0]*list|(?:III|3[\\s\\xa0]*k|1(?:[\\s\\xa0]*k)?|[3I])\\.)[\\s\\xa0]*Kr[a\\xE1][lľ]ov|(?:Prv[y\\xFD]|3)[\\s\\xa0]*Kr[a\\xE1][lľ]ov|(?:III|3[\\s\\xa0]*k|1[\\s\\xa0]*k|I)[\\s\\xa0]*Kr[a\\xE1][lľ]ov|1(?:[\\s\\xa0]*Kr[a\\xE1][lľ]ov|[\\s\\xa0]*Kr[lľ]|[\\s\\xa0]*Kr|Kgs)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Chr"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Druh(?:[a\\xE1][\\s\\xa0]*(?:kniha[\\s\\xa0]*(?:Paralipomenon|Kron(?:i(?:ck[a\\xE1]|k)|\\xEDk))|Paralipomenon|Kron(?:i(?:ck[a\\xE1]|k)|\\xEDk))|[y\\xFD][\\s\\xa0]*list[\\s\\xa0]*(?:Paralipomenon|Kron(?:i(?:ck[a\\xE1]|k)|\\xEDk))|[y\\xFD][\\s\\xa0]*Paralipomenon|[y\\xFD][\\s\\xa0]*Kron(?:i(?:ck[a\\xE1]|k)|\\xEDk))|(?:2(?:[\\s\\xa0]*k)?|II)\\.[\\s\\xa0]*(?:Paralipomenon|Kron(?:i(?:ck[a\\xE1]|k)|\\xEDk))|(?:2[\\s\\xa0]*k|II)[\\s\\xa0]*(?:Paralipomenon|Kron(?:i(?:ck[a\\xE1]|k)|\\xEDk))|2(?:[\\s\\xa0]*Paralipomenon|[\\s\\xa0]*Kroni(?:ck[a\\xE1]|k)|[\\s\\xa0]*Kron\\xEDk|[\\s\\xa0]*Kron|[\\s\\xa0]*Krn|Chr)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Chr"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Prv(?:[a\\xE1][\\s\\xa0]*(?:kniha[\\s\\xa0]*(?:Paralipomenon|Kron(?:i(?:ck[a\\xE1]|k)|\\xEDk))|Paralipomenon|Kron(?:i(?:ck[a\\xE1]|k)|\\xEDk))|[y\\xFD][\\s\\xa0]*list[\\s\\xa0]*(?:Paralipomenon|Kron(?:i(?:ck[a\\xE1]|k)|\\xEDk))|[y\\xFD][\\s\\xa0]*Paralipomenon|[y\\xFD][\\s\\xa0]*Kron(?:i(?:ck[a\\xE1]|k)|\\xEDk))|(?:1(?:[\\s\\xa0]*k)?|I)\\.[\\s\\xa0]*(?:Paralipomenon|Kron(?:i(?:ck[a\\xE1]|k)|\\xEDk))|(?:1[\\s\\xa0]*k|I)[\\s\\xa0]*(?:Paralipomenon|Kron(?:i(?:ck[a\\xE1]|k)|\\xEDk))|1(?:[\\s\\xa0]*Paralipomenon|[\\s\\xa0]*Kroni(?:ck[a\\xE1]|k)|[\\s\\xa0]*Kron\\xEDk|[\\s\\xa0]*Kron|[\\s\\xa0]*Krn|Chr)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Ezra"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Ez(?:d(?:r[a\\xE1][sš])?|ra)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Neh"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Neh(?:emi[a\\xE1][sš])?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["GkEsth"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:G(?:r[e\\xE9]cke[\\s\\xa0]*[cč]asti[\\s\\xa0]*knihy[\\s\\xa0]*Ester|kEsth)|Ester[\\s\\xa0]*gr))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Esth"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Est(?:er|h)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Job"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:K(?:niha[\\s\\xa0]*J[o\\xF3]|\\.[\\s\\xa0]*J[o\\xF3]|[\\s\\xa0]*J[o\\xF3])bova|J[o\\xF3]b))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Ps"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:K(?:niha[\\s\\xa0]*[zž]|\\.[\\s\\xa0]*[zž]|[\\s\\xa0]*[zž])almov|[ZŽ]al(?:t[a\\xE1]r|my)|[ZŽ](?:alm)?|Ps))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["PrAzar"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Azarj[a\\xE1][sš]ova[\\s\\xa0]*modlitba|PrAzar))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Prov"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:K(?:niha[\\s\\xa0]*pr[i\\xED]slov[i\\xED]|\\.[\\s\\xa0]*pr[i\\xED]slov[i\\xED]|[\\s\\xa0]*pr[i\\xED]slov[i\\xED])|Pr(?:[i\\xED]slovia|[i\\xED]s|ov)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Eccl"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:K(?:oh(?:elet(?:[\\s\\xa0]*—[\\s\\xa0]*Kazate[lľ])?)?|(?:niha[\\s\\xa0]*kazate[lľ]|\\.[\\s\\xa0]*kazate[lľ]|[\\s\\xa0]*kazate[lľ])ova|azate[lľ]|az)|E(?:kleziastes|ccl)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["SgThree"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Traja[\\s\\xa0]*ml[a\\xE1]denci[\\s\\xa0]*v[\\s\\xa0]*rozp[a\\xE1]lenej[\\s\\xa0]*peci|Piese[nň][\\s\\xa0]*ml[a\\xE1]dencov[\\s\\xa0]*v[\\s\\xa0]*ohnivej[\\s\\xa0]*peci|SgThree))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Song"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:V(?:e[lľ]p(?:iese[nň][\\s\\xa0]*[SŠ]alam[u\\xFA]nova)?|[lľ]p)|Piese[nň][\\s\\xa0]*[SŠ]alam[u\\xFA]nova|P(?:iese[nň][\\s\\xa0]*piesn[i\\xED]|Š)|Pies|Song)|(?:Ve[lľ]piese[nň]|Piese[nň]))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jer"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Jer(?:emi[a\\xE1][sš])?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Ezek"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Ez(?:e(?:chiel|k))?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Dan"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Dan(?:iel)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Hos"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Ho(?:ze[a\\xE1][sš]|s)|Oz(?:e[a\\xE1][sš])?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Joel"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Joel))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Amos"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:[A\\xC1]m(?:os)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Obad"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Ob(?:edi[a\\xE1][sš]|ad(?:i[a\\xE1][sš])?)|Abd(?:i[a\\xE1][sš])?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jonah"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Jon(?:\\xE1[sš]|a[hsš])?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Mic"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Mic(?:h(?:e[a\\xE1][sš])?)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Nah"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:N(?:\\xE1hum|ah(?:um)?)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Hab"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Hab(?:akuk)?|Ab(?:akuk)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Zeph"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Sof(?:oni[a\\xE1][sš])?|Zeph))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Hag"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Hag(?:geus)?|Ag(?:geus|eus)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Zech"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Z(?:ach(?:ari[a\\xE1][sš])?|ech)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Mal"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Mal(?:achi[a\\xE1][sš])?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Matt"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Evanjelium[\\s\\xa0]*Pod[lľ]a[\\s\\xa0]*Mat[u\\xFA][sš]a|M(?:at(?:[u\\xFA][sš]a|t)|at[u\\xFA][sš]|t)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Mark"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Evanjelium[\\s\\xa0]*Pod[lľ]a[\\s\\xa0]*Marka|M(?:ar(?:ka|ek)|ark|k)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Luke"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Evanjelium[\\s\\xa0]*Pod[lľ]a[\\s\\xa0]*Luk[a\\xE1][sš]a|L(?:uk(?:[a\\xE1][sš]a|e)|uk[a\\xE1][sš]|k)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1John"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Prv(?:[a\\xE1][\\s\\xa0]*(?:kniha[\\s\\xa0]*J[a\\xE1]|J[a\\xE1])nov|[y\\xFD][\\s\\xa0]*J[a\\xE1]nov[\\s\\xa0]*list|[y\\xFD][\\s\\xa0]*list[\\s\\xa0]*J[a\\xE1]nov)|(?:1(?:[\\s\\xa0]*k)?|I)\\.[\\s\\xa0]*J[a\\xE1]nov|(?:1[\\s\\xa0]*k|I)[\\s\\xa0]*J[a\\xE1]nov|1(?:[\\s\\xa0]*J[a\\xE1]nov|(?:Joh|[\\s\\xa0]*J)n|[\\s\\xa0]*J))|(?:Prv[y\\xFD][\\s\\xa0]*J[a\\xE1]nov))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2John"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Druh(?:[a\\xE1][\\s\\xa0]*(?:kniha[\\s\\xa0]*J[a\\xE1]|J[a\\xE1])nov|[y\\xFD][\\s\\xa0]*J[a\\xE1]nov[\\s\\xa0]*list|[y\\xFD][\\s\\xa0]*list[\\s\\xa0]*J[a\\xE1]nov)|(?:2(?:[\\s\\xa0]*k)?|II)\\.[\\s\\xa0]*J[a\\xE1]nov|(?:2[\\s\\xa0]*k|II)[\\s\\xa0]*J[a\\xE1]nov|2(?:[\\s\\xa0]*J[a\\xE1]nov|(?:Joh|[\\s\\xa0]*J)n|[\\s\\xa0]*J))|(?:Druh[y\\xFD][\\s\\xa0]*J[a\\xE1]nov))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["3John"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Tret(?:i(?:a[\\s\\xa0]*(?:kniha[\\s\\xa0]*J[a\\xE1]|J[a\\xE1])nov|[\\s\\xa0]*J[a\\xE1]nov[\\s\\xa0]*list)|\\xED[\\s\\xa0]*J[a\\xE1]nov[\\s\\xa0]*list)|(?:III|3(?:[\\s\\xa0]*k)?)\\.[\\s\\xa0]*J[a\\xE1]nov|(?:III|3[\\s\\xa0]*k)[\\s\\xa0]*J[a\\xE1]nov|3(?:[\\s\\xa0]*J[a\\xE1]nov|(?:Joh|[\\s\\xa0]*J)n|[\\s\\xa0]*J))|(?:Tret[i\\xED][\\s\\xa0]*J[a\\xE1]nov))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["John"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Evanjelium[\\s\\xa0]*Pod[lľ]a[\\s\\xa0]*J[a\\xE1]na|J(?:(?:oh)?n|[a\\xE1]na|[a\\xE1]n)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Acts"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Sk(?:utky(?:[\\s\\xa0]*apo[sš]tolov)?)?|Acts))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Rom"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:(?:List[\\s\\xa0]*Rimano|R(?:\\xEDmsky|imsky|imano|i|o))m))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Cor"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Druh(?:[a\\xE1][\\s\\xa0]*(?:kniha[\\s\\xa0]*Korin(?:ťano|t(?:sk[y\\xFD]|ano))|Korin(?:ťano|t(?:sk[y\\xFD]|ano)))|[y\\xFD][\\s\\xa0]*list[\\s\\xa0]*Korin(?:ťano|t(?:sk[y\\xFD]|ano))|[y\\xFD][\\s\\xa0]*Korin(?:ťano|t(?:sk[y\\xFD]|ano)))m|(?:2(?:[\\s\\xa0]*k)?|II)\\.[\\s\\xa0]*Korin(?:ťano|t(?:sk[y\\xFD]|ano))m|(?:2[\\s\\xa0]*k|II)[\\s\\xa0]*Korin(?:ťano|t(?:sk[y\\xFD]|ano))m|2(?:[\\s\\xa0]*Korin(?:ťano|t(?:sk[y\\xFD]|ano))m|(?:[\\s\\xa0]*K|C)or)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Cor"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Prv(?:[a\\xE1][\\s\\xa0]*(?:kniha[\\s\\xa0]*Korin(?:ťano|t(?:sk[y\\xFD]|ano))|Korin(?:ťano|t(?:sk[y\\xFD]|ano)))|[y\\xFD][\\s\\xa0]*list[\\s\\xa0]*Korin(?:ťano|t(?:sk[y\\xFD]|ano))|[y\\xFD][\\s\\xa0]*Korin(?:ťano|t(?:sk[y\\xFD]|ano)))m|(?:1(?:[\\s\\xa0]*k)?|I)\\.[\\s\\xa0]*Korin(?:ťano|t(?:sk[y\\xFD]|ano))m|(?:1[\\s\\xa0]*k|I)[\\s\\xa0]*Korin(?:ťano|t(?:sk[y\\xFD]|ano))m|1(?:[\\s\\xa0]*Korin(?:ťano|t(?:sk[y\\xFD]|ano))m|(?:[\\s\\xa0]*K|C)or)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Gal"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:List[\\s\\xa0]*Gala[tť]anom|Ga(?:latsk[y\\xFD]m|latanom|laťanom|l)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Eph"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:List[\\s\\xa0]*Efezanom|E(?:fezsk[y\\xFD]m|fezanom|ph|f)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Phil"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:List[\\s\\xa0]*Filipanom|Filipsk[y\\xFD]m|Filipanom|Phil|Flp))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Col"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:List[\\s\\xa0]*Kolosanom|Kolosensk[y\\xFD]m|Kolosanom|[CK]ol))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Thess"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Druh(?:[a\\xE1][\\s\\xa0]*(?:kniha[\\s\\xa0]*(?:Tesaloni(?:čano|c(?:ano|k[y\\xFD]))|Sol(?:[u\\xFA]n[cč]ano|[u\\xFA]nsky))|Tesaloni(?:čano|c(?:ano|k[y\\xFD]))|Sol(?:[u\\xFA]n[cč]ano|[u\\xFA]nsky))|[y\\xFD][\\s\\xa0]*list[\\s\\xa0]*(?:Tesaloni(?:čano|c(?:ano|k[y\\xFD]))|Sol(?:[u\\xFA]n[cč]ano|[u\\xFA]nsky))|[y\\xFD][\\s\\xa0]*Tesaloni(?:čano|c(?:ano|k[y\\xFD]))|[y\\xFD][\\s\\xa0]*Sol[u\\xFA]n[cč]ano|[y\\xFD][\\s\\xa0]*Sol[u\\xFA]nsky)m|(?:2(?:[\\s\\xa0]*k)?|II)\\.[\\s\\xa0]*(?:Tesaloni(?:čano|c(?:ano|k[y\\xFD]))|Sol(?:[u\\xFA]n[cč]ano|[u\\xFA]nsky))m|(?:2[\\s\\xa0]*k|II)[\\s\\xa0]*(?:Tesaloni(?:čano|c(?:ano|k[y\\xFD]))|Sol(?:[u\\xFA]n[cč]ano|[u\\xFA]nsky))m|2(?:[\\s\\xa0]*Tesaloni(?:čano|c(?:ano|k[y\\xFD]))m|[\\s\\xa0]*Sol[u\\xFA]n[cč]anom|[\\s\\xa0]*Sol[u\\xFA]nskym|Thess|[\\s\\xa0]*(?:Sol|Tes))))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Thess"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Prv(?:[a\\xE1][\\s\\xa0]*(?:kniha[\\s\\xa0]*(?:Tesaloni(?:čano|c(?:ano|k[y\\xFD]))|Sol(?:[u\\xFA]n[cč]ano|[u\\xFA]nsky))|Tesaloni(?:čano|c(?:ano|k[y\\xFD]))|Sol(?:[u\\xFA]n[cč]ano|[u\\xFA]nsky))|[y\\xFD][\\s\\xa0]*list[\\s\\xa0]*(?:Tesaloni(?:čano|c(?:ano|k[y\\xFD]))|Sol(?:[u\\xFA]n[cč]ano|[u\\xFA]nsky))|[y\\xFD][\\s\\xa0]*Tesaloni(?:čano|c(?:ano|k[y\\xFD]))|[y\\xFD][\\s\\xa0]*Sol[u\\xFA]n[cč]ano|[y\\xFD][\\s\\xa0]*Sol[u\\xFA]nsky)m|(?:1(?:[\\s\\xa0]*k)?|I)\\.[\\s\\xa0]*(?:Tesaloni(?:čano|c(?:ano|k[y\\xFD]))|Sol(?:[u\\xFA]n[cč]ano|[u\\xFA]nsky))m|(?:1[\\s\\xa0]*k|I)[\\s\\xa0]*(?:Tesaloni(?:čano|c(?:ano|k[y\\xFD]))|Sol(?:[u\\xFA]n[cč]ano|[u\\xFA]nsky))m|1(?:[\\s\\xa0]*Tesaloni(?:čano|c(?:ano|k[y\\xFD]))m|[\\s\\xa0]*Sol[u\\xFA]n[cč]anom|[\\s\\xa0]*Sol[u\\xFA]nskym|Thess|[\\s\\xa0]*(?:Sol|Tes))))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Tim"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Druh(?:[a\\xE1][\\s\\xa0]*(?:kniha[\\s\\xa0]*Timotej?|Timotej?)|[y\\xFD][\\s\\xa0]*list[\\s\\xa0]*Timotej?|[y\\xFD][\\s\\xa0]*Timotej?)ovi|(?:2(?:[\\s\\xa0]*k)?|II)\\.[\\s\\xa0]*Timotej?ovi|(?:2[\\s\\xa0]*k|II)[\\s\\xa0]*Timotej?ovi|2(?:[\\s\\xa0]*Timotej?ovi|[\\s\\xa0]*?Tim)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Tim"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Prv(?:[a\\xE1][\\s\\xa0]*(?:kniha[\\s\\xa0]*Timotej?|Timotej?)|[y\\xFD][\\s\\xa0]*list[\\s\\xa0]*Timotej?|[y\\xFD][\\s\\xa0]*Timotej?)ovi|(?:1(?:[\\s\\xa0]*k)?|I)\\.[\\s\\xa0]*Timotej?ovi|(?:1[\\s\\xa0]*k|I)[\\s\\xa0]*Timotej?ovi|1(?:[\\s\\xa0]*Timotej?ovi|[\\s\\xa0]*?Tim)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Titus"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:List[\\s\\xa0]*T[i\\xED]tovi|T(?:[i\\xED]tovi|itus|[i\\xED]t)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Phlm"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:List[\\s\\xa0]*Filem[o\\xF3]novi|Filemonovi|(?:File|(?:Ph|F)l)m))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Heb"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:List[\\s\\xa0]*Hebrejom|Hebrejom|[ZŽ]idom|Hebr?|[ZŽ]id))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jas"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:J(?:a(?:k(?:ubov(?:[\\s\\xa0]*List)?)?|s)|k)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Pet"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Druh(?:[a\\xE1][\\s\\xa0]*(?:kniha[\\s\\xa0]*)?Petrov|[y\\xFD][\\s\\xa0]*Petrov[\\s\\xa0]*list|[y\\xFD][\\s\\xa0]*list[\\s\\xa0]*Petrov|[y\\xFD][\\s\\xa0]*Petrov)|(?:2(?:[\\s\\xa0]*k)?|II)\\.[\\s\\xa0]*Petrov|(?:2[\\s\\xa0]*k|II)[\\s\\xa0]*Petrov|2(?:[\\s\\xa0]*Petrov|(?:[\\s\\xa0]*P|Pe)t)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Pet"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Prv(?:[a\\xE1][\\s\\xa0]*(?:kniha[\\s\\xa0]*)?Petrov|[y\\xFD][\\s\\xa0]*Petrov[\\s\\xa0]*list|[y\\xFD][\\s\\xa0]*list[\\s\\xa0]*Petrov|[y\\xFD][\\s\\xa0]*Petrov)|(?:1(?:[\\s\\xa0]*k)?|I)\\.[\\s\\xa0]*Petrov|(?:1[\\s\\xa0]*k|I)[\\s\\xa0]*Petrov|1(?:[\\s\\xa0]*Petrov|(?:[\\s\\xa0]*P|Pe)t)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jude"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:J(?:\\xFAd(?:ov(?:[\\s\\xa0]*List)?)?|ud(?:ov(?:[\\s\\xa0]*List)?|e)?)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Tob"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Tob(?:i[a\\xE1][sš])?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jdt"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:K(?:niha|\\.)?[\\s\\xa0]*Juditina|J(?:udita|udit|dt)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Bar"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Proroctvo[\\s\\xa0]*Baruchovo|Bar(?:uch)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Sus"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Zuzan[ae]|Sus))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Macc"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Druh(?:[a\\xE1][\\s\\xa0]*(?:kniha[\\s\\xa0]*Ma(?:ch|k)|Ma(?:ch|k))|[y\\xFD][\\s\\xa0]*list[\\s\\xa0]*Ma(?:ch|k)|[y\\xFD][\\s\\xa0]*Ma(?:ch|k))abejcov|(?:2(?:[\\s\\xa0]*k)?|II)\\.[\\s\\xa0]*Ma(?:ch|k)abejcov|(?:2[\\s\\xa0]*k|II)[\\s\\xa0]*Ma(?:ch|k)abejcov|2(?:[\\s\\xa0]*Ma(?:ch|k)abejcov|[\\s\\xa0]*Ma(?:ch|k)|Macc)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["3Macc"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Tret(?:i(?:a[\\s\\xa0]*(?:kniha[\\s\\xa0]*)?|[\\s\\xa0]*)|\\xED[\\s\\xa0]*)Machabejcov|(?:III|3(?:[\\s\\xa0]*k)?)\\.[\\s\\xa0]*Machabejcov|(?:III|3[\\s\\xa0]*k)[\\s\\xa0]*Machabejcov|3(?:[\\s\\xa0]*Machabejcov|[\\s\\xa0]*Mach|Macc|[\\s\\xa0]*Mak)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["4Macc"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:[SŠ]tvrt[a\\xE1][\\s\\xa0]*(?:kniha[\\s\\xa0]*)?Machabejcov|(?:4(?:[\\s\\xa0]*k)?|IV)\\.[\\s\\xa0]*Machabejcov|(?:4[\\s\\xa0]*k|IV)[\\s\\xa0]*Machabejcov|4(?:[\\s\\xa0]*Machabejcov|[\\s\\xa0]*Mach|Macc|[\\s\\xa0]*Mak)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Macc"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Prv(?:[a\\xE1][\\s\\xa0]*(?:kniha[\\s\\xa0]*Mach|Ma(?:ch|k))|(?:[y\\xFD][\\s\\xa0]*list|[y\\xFD])[\\s\\xa0]*Mach)abejcov|(?:1(?:[\\s\\xa0]*k)?|I)\\.[\\s\\xa0]*Machabejcov|(?:1[\\s\\xa0]*k|I)[\\s\\xa0]*Machabejcov|1(?:[\\s\\xa0]*Machabejcov|[\\s\\xa0]*Mach|Macc|[\\s\\xa0]*Mak)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
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
