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
|(?:subt[íi]tulo|t[íi]tulo|tít)(?![a-z])\
|y${bcv_parser.prototype.regexps.space}+siguientes|y(?!${bcv_parser.prototype.regexps.space}+sig)|y${bcv_parser.prototype.regexps.space}+sig|vers[íi]culos|cap[íi]tulos|vers[íi]culo|cap[íi]tulo|caps|vers|cap|ver|vss|vs|vv|á|v\
|[a-e](?!\\w)\
|$\
)+\
)`, "gi");
// These are the only valid ways to end a potential passage match. The closing parenthesis allows for fully capturing parentheses surrounding translations (ESV**)**. The last one, `[\d\x1f]` needs not to be +; otherwise `Gen5ff` becomes `\x1f0\x1f5ff`, and `adjust_regexp_end` matches the `\x1f5` and incorrectly dangles the ff.
// 'ff09' is a full-width closing parenthesis.
bcv_parser.prototype.regexps.match_end_split = new RegExp(`\
\\d\\W*(?:subt[íi]tulo|t[íi]tulo|tít)\
|\\d\\W*(?:y${bcv_parser.prototype.regexps.space}+siguientes|y${bcv_parser.prototype.regexps.space}+sig)(?:[\\s\\xa0*]*\\.)?\
|\\d[\\s\\xa0*]*[a-e](?!\\w)\
|\\x1e(?:[\\s\\xa0*]*[)\\]\\uff09])?\
|[\\d\\x1f]`, "gi");
bcv_parser.prototype.regexps.control = /[\x1e\x1f]/g;
bcv_parser.prototype.regexps.pre_book = "[^A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ]";

bcv_parser.prototype.regexps.first = `(?:1\.?[ºo]|1|I|Primero?)\\.?${bcv_parser.prototype.regexps.space}*`;
bcv_parser.prototype.regexps.second = `(?:2\.?[ºo]|2|II|Segundo)\\.?${bcv_parser.prototype.regexps.space}*`;
bcv_parser.prototype.regexps.third = `(?:3\.?[ºo]|3|III|Tercero?)\\.?${bcv_parser.prototype.regexps.space}*`;
bcv_parser.prototype.regexps.range_and = `(?:[&\u2013\u2014-]|y(?!${bcv_parser.prototype.regexps.space}+sig)|á)`;
bcv_parser.prototype.regexps.range_only = "(?:[\u2013\u2014-]|á)";
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
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:G(?:[e\\xE9](?:n(?:esis)?)?|n)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Exod"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:[E\\xC9]x(?:o(?:do?)?|d)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Bel"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Bel(?:[\\s\\xa0]*y[\\s\\xa0]*el[\\s\\xa0]*(?:Serpiente|Drag[o\\xF3]n))?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Lev"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:L(?:ev(?:[i\\xED]tico)?|v)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Num"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:N(?:[u\\xFA](?:m(?:eros)?)?|m)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Sir"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Ec(?:lesi[a\\xE1]stico|clus)|Si(?:r(?:[a\\xE1]cides|[a\\xE1]cida)|r(?:[a\\xE1]c)?)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Wis"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:S(?:ab(?:idur[i\\xED]a)?|b)|Wis))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Lam"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:L(?:a(?:m(?:[ei]ntaciones?)?)?|m)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["EpJer"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:La[\\s\\xa0]*Carta[\\s\\xa0]*de[\\s\\xa0]*Jerem[i\\xED]as|Carta[\\s\\xa0]*de[\\s\\xa0]*Jerem[i\\xED]as|Carta[\\s\\xa0]*Jerem[i\\xED]as|(?:Carta[\\s\\xa0]*|Ep)Jer))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Rev"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:El[\\s\\xa0]*Apocalipsis|Apocalipsis|Ap(?:oc)?|Rev))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["PrMan"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:La[\\s\\xa0]*Oraci[o\\xF3]n[\\s\\xa0]*de[\\s\\xa0]*Manas[e\\xE9]s|Oraci[o\\xF3]n[\\s\\xa0]*de[\\s\\xa0]*Manas[e\\xE9]s|(?:Or\\.?[\\s\\xa0]*|Pr)Man))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Deut"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:D(?:ueteronomio|eu(?:t(?:[eo]rono?mio|rono?mio)?)?|t)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Josh"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Jos(?:u[e\\xE9]|h)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Judg"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:J(?:u(?:e(?:c(?:es)?)?|dg)|c)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Ruth"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:R(?:u(?:th?)?|t)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Esd"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Primero?[\\s\\xa0]*Esdras|(?:1(?:\\.[o\\xBA]|[o\\xBA])|I)\\.[\\s\\xa0]*Esdras|(?:1(?:\\.[o\\xBA]?|[o\\xBA])|I)[\\s\\xa0]*Esdras|1(?:[\\s\\xa0]*Esdras|[\\s\\xa0]*Esdr?|Esd)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Esd"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Segundo[\\s\\xa0]*Esdras|(?:2(?:\\.[o\\xBA]|[o\\xBA])|II)\\.[\\s\\xa0]*Esdras|(?:2(?:\\.[o\\xBA]?|[o\\xBA])|II)[\\s\\xa0]*Esdras|2(?:[\\s\\xa0]*Esdras|[\\s\\xa0]*Esdr?|Esd)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Isa"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Is(?:a(?:[i\\xED]as)?)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Sam"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:2[\\s\\xa0]*Sm)|(?:Segundo[\\s\\xa0]*Samuel|(?:2(?:\\.[o\\xBA]|[o\\xBA])|II)\\.[\\s\\xa0]*Samuel|(?:2(?:\\.[o\\xBA]?|[o\\xBA])|II)[\\s\\xa0]*Samuel|2(?:[\\s\\xa0]*Samuel|[\\s\\xa0]*S(?:am?)?|Sam)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Sam"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:1[\\s\\xa0]*Sm)|(?:Primero?[\\s\\xa0]*Samuel|(?:1(?:\\.[o\\xBA]|[o\\xBA])|I)\\.[\\s\\xa0]*Samuel|(?:1(?:\\.[o\\xBA]?|[o\\xBA])|I)[\\s\\xa0]*Samuel|1(?:[\\s\\xa0]*Samuel|[\\s\\xa0]*S(?:am?)?|Sam)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Kgs"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Segundo[\\s\\xa0]*Reyes|(?:2(?:\\.[o\\xBA]|[o\\xBA])|II)\\.[\\s\\xa0]*Reyes|(?:2(?:\\.[o\\xBA]?|[o\\xBA])|II)[\\s\\xa0]*Reyes|2(?:[\\s\\xa0]*R(?:(?:e(?:ye?|e)?|ye?)?s|e(?:ye?|e)?|ye?)?|Kgs)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Kgs"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Primero?[\\s\\xa0]*Reyes|(?:1(?:\\.[o\\xBA]|[o\\xBA])|I)\\.[\\s\\xa0]*Reyes|(?:1(?:\\.[o\\xBA]?|[o\\xBA])|I)[\\s\\xa0]*Reyes|1(?:[\\s\\xa0]*R(?:(?:e(?:ye?|e)?|ye?)?s|e(?:ye?|e)?|ye?)?|Kgs)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Chr"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Segundo[\\s\\xa0]*Cr[o\\xF3]nicas|(?:2(?:\\.[o\\xBA]|[o\\xBA])|II)\\.[\\s\\xa0]*Cr[o\\xF3]nicas|(?:2(?:\\.[o\\xBA]?|[o\\xBA])|II)[\\s\\xa0]*Cr[o\\xF3]nicas|2(?:[\\s\\xa0]*Cr[o\\xF3]nicas|[\\s\\xa0]*Cr(?:[o\\xF3]n?)?|Chr)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Chr"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Primer(?:o[\\s\\xa0]*Cr[o\\xF3]|[\\s\\xa0]*Cr[o\\xF3])nicas|(?:1(?:\\.[o\\xBA]|[o\\xBA])|I)\\.[\\s\\xa0]*Cr[o\\xF3]nicas|(?:1(?:\\.[o\\xBA]?|[o\\xBA])|I)[\\s\\xa0]*Cr[o\\xF3]nicas|1(?:[\\s\\xa0]*Cr[o\\xF3]nicas|[\\s\\xa0]*Cr(?:[o\\xF3]n?)?|Chr)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Ezra"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:E(?:sd(?:r(?:as)?)?|zra)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Neh"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Ne(?:h(?:em[i\\xED]as)?)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["GkEsth"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Est(?:er[\\s\\xa0]*(?:\\([Gg]riego\\)|[Gg]riego)|[\\s\\xa0]*Gr)|GkEsth))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Esth"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Es(?:t(?:er|h)?)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Job"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Jo?b))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Ps"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:S(?:al(?:m(?:os?)?)?|lm?)|Ps))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["PrAzar"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Oraci[o\\xF3]n[\\s\\xa0]*de[\\s\\xa0]*Azar[i\\xED]as|C[a\\xE1]ntico[\\s\\xa0]*de[\\s\\xa0]*Azar[i\\xED]as|(?:Or[\\s\\xa0]*|Pr)Azar|Azar[i\\xED]as|Or[\\s\\xa0]*Az))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Prov"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Provebios)|(?:P(?:r(?:o(?:bv?erbios|verbios|v(?:erbio)?)?|(?:e?verbio|vbo?)s|e?verbio|vbo|vb?)?|or?verbios|v)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Eccl"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Ec(?:c(?:l(?:es(?:i(?:a(?:st(?:i(?:c[e\\xE9]|[e\\xE9])s|[e\\xE9]s|[e\\xE9])|t(?:[e\\xE9]s|[e\\xE9]))|i(?:s?t[e\\xE9]s|s?t[e\\xE9]))|(?:s[ai][ai]|a[ai])s?t[e\\xE9]s|(?:s[ai][ai]|a[ai])s?t[e\\xE9])?)?)?|l(?:es(?:i(?:a(?:st(?:i(?:c[e\\xE9]|[e\\xE9])s|[e\\xE9]s|[e\\xE9])|t(?:[e\\xE9]s|[e\\xE9]))|i(?:s?t[e\\xE9]s|s?t[e\\xE9]))|(?:s[ai][ai]|a[ai])s?t[e\\xE9]s|(?:s[ai][ai]|a[ai])s?t[e\\xE9])?)?)?|Qo))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["SgThree"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:El[\\s\\xa0]*(?:Himno[\\s\\xa0]*de[\\s\\xa0]*los[\\s\\xa0]*(?:Tres[\\s\\xa0]*J[o\\xF3]venes[\\s\\xa0]*(?:Hebre|Jud[i\\xED])|3[\\s\\xa0]*J[o\\xF3]venes[\\s\\xa0]*(?:Hebre|Jud[i\\xED]))|Canto[\\s\\xa0]*de[\\s\\xa0]*los[\\s\\xa0]*(?:Tres[\\s\\xa0]*J[o\\xF3]venes[\\s\\xa0]*(?:Hebre|Jud[i\\xED])|3[\\s\\xa0]*J[o\\xF3]venes[\\s\\xa0]*(?:Hebre|Jud[i\\xED])))os|SgThree|Ct[\\s\\xa0]*3[\\s\\xa0]*J[o\\xF3])|(?:Canto[\\s\\xa0]*de[\\s\\xa0]*los[\\s\\xa0]*(?:Tres[\\s\\xa0]*J[o\\xF3]venes(?:[\\s\\xa0]*(?:Hebre|Jud[i\\xED])os)?|3[\\s\\xa0]*J[o\\xF3]venes(?:[\\s\\xa0]*(?:Hebre|Jud[i\\xED])os)?)|(?:Himno[\\s\\xa0]*de[\\s\\xa0]*los[\\s\\xa0]*Tres[\\s\\xa0]*J[o\\xF3]venes[\\s\\xa0]*Jud[i\\xED]o|(?:Himno[\\s\\xa0]*de[\\s\\xa0]*los[\\s\\xa0]*Tres[\\s\\xa0]*J[o\\xF3]|Tres[\\s\\xa0]*J[o\\xF3]|3[\\s\\xa0]*J[o\\xF3])vene)s|Himno[\\s\\xa0]*de[\\s\\xa0]*los[\\s\\xa0]*3[\\s\\xa0]*J[o\\xF3]venes(?:[\\s\\xa0]*(?:Hebre|Jud[i\\xED])os)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Song"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:El[\\s\\xa0]*Cantar[\\s\\xa0]*de[\\s\\xa0]*los[\\s\\xa0]*Cantares|Cantare?[\\s\\xa0]*de[\\s\\xa0]*los[\\s\\xa0]*Cantares|C(?:antares|n?t)|Cant?|Song))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jer"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:J(?:er(?:e(?:m[i\\xED]as?)?)?|r)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Ezek"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Ez(?:i[ei]qui?el|e(?:[ei]qui?el|qu(?:i[ae]|e)l|qu?|k)?|iqui?el|q)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Dan"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:D(?:a(?:n(?:iel)?)?|[ln])))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Hos"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Os(?:eas)?|Hos))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Joel"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:J(?:oel?|l)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Amos"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Am(?:[o\\xF3]s?|s)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Obad"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Ab(?:d(?:[i\\xED]as)?)?|Obad))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jonah"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:J(?:on(?:\\xE1s|a[hs])?|ns)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Mic"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:M(?:i(?:q(?:ueas)?|c)?|q)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Nah"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:N(?:a(?:h(?:[u\\xFA]m?)?)?|h)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Hab"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Hab(?:bac[au]c|ac[au]c|c)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Zeph"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:S(?:o(?:f(?:on[i\\xED]as)?)?|f)|Zeph))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Hag"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:H(?:ag(?:geo|eo)?|g)|Ag(?:eo)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Zech"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Z(?:a(?:c(?:ar(?:[i\\xED]as)?)?)?|ech)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Mal"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:M(?:al(?:a(?:qu(?:[i\\xED]as)?)?)?|l)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Matt"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:E(?:l[\\s\\xa0]*E)?vangelio[\\s\\xa0]*de[\\s\\xa0]*Mateo|San[\\s\\xa0]*Mateo|M(?:ateo|(?:at|a)?t)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Macc"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:2[\\s\\xa0]*Mc)|(?:Segundo[\\s\\xa0]*Mac(?:cab(?:be(?:eos?|os?)|e(?:eos?|os?))|ab(?:be(?:eos?|os?)|e(?:eos?|os?)))|(?:2(?:\\.[o\\xBA]|[o\\xBA])|II)\\.[\\s\\xa0]*Mac(?:cab(?:be(?:eos?|os?)|e(?:eos?|os?))|ab(?:be(?:eos?|os?)|e(?:eos?|os?)))|(?:2(?:\\.[o\\xBA]?|[o\\xBA])|II)[\\s\\xa0]*Mac(?:cab(?:be(?:eos?|os?)|e(?:eos?|os?))|ab(?:be(?:eos?|os?)|e(?:eos?|os?)))|2(?:[\\s\\xa0]*Macc?ab(?:be(?:eos?|os?)|e(?:eos?|os?))|[\\s\\xa0]*M(?:acc?)?|Macc)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["3Macc"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:3[\\s\\xa0]*Mc)|(?:Tercer(?:o[\\s\\xa0]*Mac(?:cab(?:be(?:eos?|os?)|e(?:eos?|os?))|ab(?:be(?:eos?|os?)|e(?:eos?|os?)))|[\\s\\xa0]*Mac(?:cab(?:be(?:eos?|os?)|e(?:eos?|os?))|ab(?:be(?:eos?|os?)|e(?:eos?|os?))))|(?:III|3(?:\\.[o\\xBA]|[o\\xBA]))\\.[\\s\\xa0]*Mac(?:cab(?:be(?:eos?|os?)|e(?:eos?|os?))|ab(?:be(?:eos?|os?)|e(?:eos?|os?)))|(?:III|3(?:\\.[o\\xBA]?|[o\\xBA]))[\\s\\xa0]*Mac(?:cab(?:be(?:eos?|os?)|e(?:eos?|os?))|ab(?:be(?:eos?|os?)|e(?:eos?|os?)))|3(?:[\\s\\xa0]*Macc?ab(?:be(?:eos?|os?)|e(?:eos?|os?))|[\\s\\xa0]*M(?:acc?)?|Macc)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["4Macc"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:4[\\s\\xa0]*Mc)|(?:Cuarto[\\s\\xa0]*Mac(?:cab(?:be(?:eos?|os?)|e(?:eos?|os?))|ab(?:be(?:eos?|os?)|e(?:eos?|os?)))|(?:4(?:\\.[o\\xBA]|[o\\xBA])|IV)\\.[\\s\\xa0]*Mac(?:cab(?:be(?:eos?|os?)|e(?:eos?|os?))|ab(?:be(?:eos?|os?)|e(?:eos?|os?)))|(?:4(?:\\.[o\\xBA]?|[o\\xBA])|IV)[\\s\\xa0]*Mac(?:cab(?:be(?:eos?|os?)|e(?:eos?|os?))|ab(?:be(?:eos?|os?)|e(?:eos?|os?)))|4(?:[\\s\\xa0]*Macc?ab(?:be(?:eos?|os?)|e(?:eos?|os?))|[\\s\\xa0]*M(?:acc?)?|Macc)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Macc"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:1[\\s\\xa0]*Mc)|(?:Primer(?:o[\\s\\xa0]*Mac(?:cab(?:be(?:eos?|os?)|e(?:eos?|os?))|ab(?:be(?:eos?|os?)|e(?:eos?|os?)))|[\\s\\xa0]*Mac(?:cab(?:be(?:eos?|os?)|e(?:eos?|os?))|ab(?:be(?:eos?|os?)|e(?:eos?|os?))))|(?:1(?:\\.[o\\xBA]|[o\\xBA])|I)\\.[\\s\\xa0]*Mac(?:cab(?:be(?:eos?|os?)|e(?:eos?|os?))|ab(?:be(?:eos?|os?)|e(?:eos?|os?)))|(?:1(?:\\.[o\\xBA]?|[o\\xBA])|I)[\\s\\xa0]*Mac(?:cab(?:be(?:eos?|os?)|e(?:eos?|os?))|ab(?:be(?:eos?|os?)|e(?:eos?|os?)))|1(?:[\\s\\xa0]*Macc?ab(?:be(?:eos?|os?)|e(?:eos?|os?))|[\\s\\xa0]*M(?:acc?)?|Macc)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Mark"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Mark)|(?:E(?:l[\\s\\xa0]*E)?vangelio[\\s\\xa0]*de[\\s\\xa0]*Marcos|San[\\s\\xa0]*Marcos|M(?:a?rcos|arc?|rc?|c)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Luke"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:E(?:l[\\s\\xa0]*E)?vangelio[\\s\\xa0]*de[\\s\\xa0]*Lucas|San[\\s\\xa0]*Lucas|L(?:ucas|uke|uc?|c)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1John"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:(?:Primer(?:o[\\s\\xa0]*(?:San[\\s\\xa0]*J[au][au]|J[au][au])|[\\s\\xa0]*(?:San[\\s\\xa0]*J[au][au]|J[au][au]))|(?:1(?:\\.[o\\xBA]|[o\\xBA])|I)\\.[\\s\\xa0]*(?:San[\\s\\xa0]*J[au][au]|J[au][au])|(?:1(?:\\.[o\\xBA]?|[o\\xBA])|I)[\\s\\xa0]*(?:San[\\s\\xa0]*J[au][au]|J[au][au])|1(?:[\\s\\xa0]*San[\\s\\xa0]*J[au][au]|[\\s\\xa0]*J[au][au]|Joh|[\\s\\xa0]*J))n))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2John"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:(?:Segundo[\\s\\xa0]*(?:San[\\s\\xa0]*J[au][au]|J[au][au])|(?:2(?:\\.[o\\xBA]|[o\\xBA])|II)\\.[\\s\\xa0]*(?:San[\\s\\xa0]*J[au][au]|J[au][au])|(?:2(?:\\.[o\\xBA]?|[o\\xBA])|II)[\\s\\xa0]*(?:San[\\s\\xa0]*J[au][au]|J[au][au])|2(?:[\\s\\xa0]*San[\\s\\xa0]*J[au][au]|[\\s\\xa0]*J[au][au]|Joh|[\\s\\xa0]*J))n))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["3John"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:(?:Tercer(?:o[\\s\\xa0]*(?:San[\\s\\xa0]*J[au][au]|J[au][au])|[\\s\\xa0]*(?:San[\\s\\xa0]*J[au][au]|J[au][au]))|(?:III|3(?:\\.[o\\xBA]|[o\\xBA]))\\.[\\s\\xa0]*(?:San[\\s\\xa0]*J[au][au]|J[au][au])|(?:III|3(?:\\.[o\\xBA]?|[o\\xBA]))[\\s\\xa0]*(?:San[\\s\\xa0]*J[au][au]|J[au][au])|3(?:[\\s\\xa0]*San[\\s\\xa0]*J[au][au]|[\\s\\xa0]*J[au][au]|Joh|[\\s\\xa0]*J))n))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["John"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:(?:El[\\s\\xa0]*Evangelio[\\s\\xa0]*de[\\s\\xa0]*J[au][au]|San[\\s\\xa0]*Jua|Joh|J[au][au]|J)n))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Acts"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Los[\\s\\xa0]*Hechos(?:[\\s\\xa0]*de[\\s\\xa0]*los[\\s\\xa0]*Ap[o\\xF3]stoles)?|Hechos(?:[\\s\\xa0]*de[\\s\\xa0]*los[\\s\\xa0]*Ap[o\\xF3]stoles)?|H(?:ech?|ch|c)|Acts))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Rom"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:R(?:o(?:m(?:anos?|s)?|s)?|m(?:ns?|s)?)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Cor"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:2[\\s\\xa0]*Corini)|(?:Segundo[\\s\\xa0]*Corintios|(?:2(?:\\.[o\\xBA]|[o\\xBA])|II)\\.[\\s\\xa0]*Corintios|(?:2(?:\\.[o\\xBA]?|[o\\xBA])|II)[\\s\\xa0]*Corintios|2(?:[\\s\\xa0]*Corintios|[\\s\\xa0]*Co(?:r(?:in(?:ti?)?)?)?|Cor)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Cor"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:1[\\s\\xa0]*Corini)|(?:Primero?[\\s\\xa0]*Corintios|(?:1(?:\\.[o\\xBA]|[o\\xBA])|I)\\.[\\s\\xa0]*Corintios|(?:1(?:\\.[o\\xBA]?|[o\\xBA])|I)[\\s\\xa0]*Corintios|1(?:[\\s\\xa0]*Corintios|[\\s\\xa0]*Co(?:r(?:in(?:ti?)?)?)?|Cor)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Gal"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:G[a\\xE1](?:l(?:at(?:as)?)?)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Eph"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:E(?:f(?:es(?:ios)?)?|ph)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Phil"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:F(?:il(?:i(?:p(?:enses)?)?)?|lp)|Phil))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Col"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Col(?:os(?:enses)?)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Thess"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Segundo[\\s\\xa0]*Tesaloni[cs]enses?|(?:2(?:\\.[o\\xBA]|[o\\xBA])|II)\\.[\\s\\xa0]*Tesaloni[cs]enses?|(?:2(?:\\.[o\\xBA]?|[o\\xBA])|II)[\\s\\xa0]*Tesaloni[cs]enses?|2(?:[\\s\\xa0]*Tesaloni[cs]enses?|(?:[\\s\\xa0]*T(?:hes)?|Thes|[\\s\\xa0]*Te)s)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Thess"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Primer(?:o[\\s\\xa0]*Tesaloni[cs]enses?|[\\s\\xa0]*Tesaloni[cs]enses?)|(?:1(?:\\.[o\\xBA]|[o\\xBA])|I)\\.[\\s\\xa0]*Tesaloni[cs]enses?|(?:1(?:\\.[o\\xBA]?|[o\\xBA])|I)[\\s\\xa0]*Tesaloni[cs]enses?|1(?:[\\s\\xa0]*Tesaloni[cs]enses?|(?:[\\s\\xa0]*T(?:hes)?|Thes|[\\s\\xa0]*Te)s)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Tim"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Segundo[\\s\\xa0]*Timoteo|(?:2(?:\\.[o\\xBA]|[o\\xBA])|II)\\.[\\s\\xa0]*Timoteo|(?:2(?:\\.[o\\xBA]?|[o\\xBA])|II)[\\s\\xa0]*Timoteo|2(?:[\\s\\xa0]*Timoteo|[\\s\\xa0]*Tim?|(?:Ti|[\\s\\xa0]*T)m)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Tim"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Primero?[\\s\\xa0]*Timoteo|(?:1(?:\\.[o\\xBA]|[o\\xBA])|I)\\.[\\s\\xa0]*Timoteo|(?:1(?:\\.[o\\xBA]?|[o\\xBA])|I)[\\s\\xa0]*Timoteo|1(?:[\\s\\xa0]*Timoteo|[\\s\\xa0]*Tim?|(?:Ti|[\\s\\xa0]*T)m)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Titus"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:T(?:i(?:t(?:us|o)?)?|t)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Phlm"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:F(?:ilem(?:[o\\xF3]n)?|lmn?|mn)|Phlm))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Heb"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:He(?:b(?:r(?:eo?)?s|re[er]s|r[or][eor]?s|[eo](?:[eor][eor]?)?s|r(?:eo)?)?)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jas"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:S(?:ant(?:iago)?|tg?)|Jas))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Pet"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:2(?:Pet|[\\s\\xa0]*Pd))|(?:Segundo[\\s\\xa0]*(?:San[\\s\\xa0]*)?Pedro|(?:2(?:\\.[o\\xBA]|[o\\xBA])|II)\\.[\\s\\xa0]*(?:San[\\s\\xa0]*)?Pedro|(?:2(?:\\.[o\\xBA]?|[o\\xBA])|II)[\\s\\xa0]*(?:San[\\s\\xa0]*)?Pedro|2[\\s\\xa0]*(?:San[\\s\\xa0]*Pedro|P(?:edro|ed?)?)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Pet"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:1(?:Pet|[\\s\\xa0]*Pd))|(?:Primer(?:o[\\s\\xa0]*(?:San[\\s\\xa0]*)?|[\\s\\xa0]*(?:San[\\s\\xa0]*)?)Pedro|(?:1(?:\\.[o\\xBA]|[o\\xBA])|I)\\.[\\s\\xa0]*(?:San[\\s\\xa0]*)?Pedro|(?:1(?:\\.[o\\xBA]?|[o\\xBA])|I)[\\s\\xa0]*(?:San[\\s\\xa0]*)?Pedro|1[\\s\\xa0]*(?:San[\\s\\xa0]*Pedro|P(?:edro|ed?)?)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jude"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:San[\\s\\xa0]*Judas|J(?:u?das|ude|u?d)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Tob"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:T(?:ob(?:it?|t)?|b)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jdt"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:J(?:udi?|di?)t))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Bar"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Ba(?:r(?:uc)?)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Sus"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Sus(?:ana)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Hab", "Hag"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Ha))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Heb", "Hab"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Hb))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jonah", "Job", "Josh", "Joel"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Jo))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jude", "Judg"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Ju))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Matt", "Mark", "Mal"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Ma))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Phil", "Phlm"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Fil))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
	];
	// Short-circuit the look if we know we want all the books.
	if ((include_apocrypha === true) && (case_sensitive === "none")) { return books; }
	// Filter out books in the Apocrypha if we don't want them. `Array.map` isn't supported below IE9.
	const out = [];
	for (const book of books) {
		if ((include_apocrypha === false) && (book.apocrypha != null) && (book.apocrypha === true)) { continue; }
		if (case_sensitive === "books") {
			book.regexp = new RegExp(book.regexp.source, "g");
		}
		out.push(book);
	}
	return out;
};

// Default to not using the Apocrypha
bcv_parser.prototype.regexps.books = bcv_parser.prototype.regexps.get_books(false, "none");
