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
(?:^|[^\\x1f\\x1e\\dA-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])\
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
|ابواب|آیات|باب|آیت|ff|تا|،|؛|۔\
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
bcv_parser.prototype.regexps.pre_book = "[^A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ]";

bcv_parser.prototype.regexps.first = `(?:اوّل|[۱1]|1)\\.?${bcv_parser.prototype.regexps.space}*`;
bcv_parser.prototype.regexps.second = `(?:دوم|[۲2]|2)\\.?${bcv_parser.prototype.regexps.space}*`;
bcv_parser.prototype.regexps.third = `(?:تیسرا|[۳3]|3)\\.?${bcv_parser.prototype.regexps.space}*`;
bcv_parser.prototype.regexps.range_and = `(?:[&\u2013\u2014-]|(?:،|؛|۔)|تا)`;
bcv_parser.prototype.regexps.range_only = "(?:[\u2013\u2014-]|تا)";
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
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:پ(?:َیدای|یدا[ئی]|يدائ)ش|pīdāyiš|Gen))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Exod"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:خ(?:ُرُ|ر)وج|ḫurūj|Exod))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Bel"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Bel))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Lev"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:احبار|iḥbār|Lev))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Num"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:گِ?نتی|gintī|Num))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Sir"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Sir))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Wis"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Wis))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Lam"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:نَ?وحہ|nūḥ\\xE2|Lam))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["EpJer"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:EpJer))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Rev"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ی(?:ُو(?:[\\s\\xa0]*حنّا[\\s\\xa0]*عارِف[\\s\\xa0]*کا[\\s\\xa0]*مُ|حنا[\\s\\xa0]*عارف[\\s\\xa0]*کا[\\s\\xa0]*م)|و[\\s\\xa0]*حنا[\\s\\xa0]*عارف[\\s\\xa0]*کا[\\s\\xa0]*م)کاشفہ|yūḥannā[\\s\\xa0]*ʿārif[\\s\\xa0]*kā[\\s\\xa0]*mukāšaf\\xE2|مُکاشفہ|مکاشفہ|Rev))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["PrMan"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:PrMan))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Deut"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ا(?:ِستِثنا|ستثناء)|istis̱nā|استثنا|Deut))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Josh"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:یشُ?وع|yašūʿ|Josh))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Judg"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ق(?:ُضاۃ|ضا[ةہۃ])|qużāh|Judg))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Ruth"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:رُ?وت|Ruth|rūt))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Esd"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])((?:1Esd))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Esd"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])((?:2Esd))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Isa"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:yasaʿyāh|ی(?:عس|سع)یاہ|Isa))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Sam"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])((?:دوم(?:۔سموا|[\\s\\xa0\\x2D]*سموئ)یل|2(?:[\\s\\xa0]*samūʾīl|۔سموایل|[\\s\\xa0]*سموئیل|\\-?سموئیل|Sam)|(?:2\\.|۲)(?:۔سموا|[\\s\\xa0\\x2D]*سموئ)یل))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Sam"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])((?:اوّل(?:(?:۔سموا|\\-?سموئ)ی|[\\s\\xa0]*سموئ[يی])ل|1(?:[\\s\\xa0]*samūʾīl|(?:۔سموا|\\-?سموئ)یل|[\\s\\xa0]*سموئ[يی]ل|Sam)|(?:1\\.|۱)(?:(?:۔سموا|\\-?سموئ)ی|[\\s\\xa0]*سموئ[يی])ل))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Kgs"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])((?:دوم(?:\\-?سلاطِ|[\\s\\xa0۔]*سلاط)ین|(?:2\\.|۲)(?:\\-?سلاطِ|[\\s\\xa0۔]*سلاط)ین|2(?:[\\s\\xa0]*salāṭīn|\\-?سلاطِین|[\\s\\xa0۔]*سلاطین|Kgs)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Kgs"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])((?:اوّل(?:\\-?سلاطِ|[\\s\\xa0۔]*سلاط)ین|(?:1\\.|۱)(?:\\-?سلاطِ|[\\s\\xa0۔]*سلاط)ین|1(?:[\\s\\xa0]*salāṭīn|\\-?سلاطِین|[\\s\\xa0۔]*سلاطین|Kgs)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Chr"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])((?:دوم(?:\\-?[\\s\\xa0]*توارِ|(?:[\\s\\xa0]*تو[\\s\\xa0]*|۔تو)ار)یخ|(?:2\\.|۲)(?:\\-?[\\s\\xa0]*توارِ|(?:[\\s\\xa0]*تو[\\s\\xa0]*|۔تو)ار)یخ|2(?:\\-?[\\s\\xa0]*توارِیخ|[\\s\\xa0]*tavārīḫ|(?:[\\s\\xa0]*تو[\\s\\xa0]*|۔تو)اریخ|Chr)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Chr"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])((?:اوّل(?:\\-?توارِ|[\\s\\xa0۔]*توار)یخ|(?:1\\.|۱)(?:\\-?توارِ|[\\s\\xa0۔]*توار)یخ|1(?:[\\s\\xa0]*tavārīḫ|\\-?توارِیخ|[\\s\\xa0۔]*تواریخ|Chr)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Ezra"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:عز[\\s\\xa0]*?را|ʿizrā|Ezra))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Neh"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:niḥimyāh|نحمیاہ|Neh))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["GkEsth"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:GkEsth))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Esth"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ایستر|āstar|Esth|آستر))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Job"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ای(?:ُّ|ّ)?وب|(?:ayyū|Jo)b))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Ps"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:زبُ?ور|zabūr|زبُو|Ps))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["PrAzar"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:PrAzar))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Prov"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:اَ?مثال|ams̱āl|Prov))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Eccl"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:واعِ?ظ|vāʿẓ|Eccl))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["SgThree"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:SgThree))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Song"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ġazalu[\\s\\xa0]*l\\-?ġazalāt|غزلُ?[\\s\\xa0]*الغزلات|Song))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jer"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:yirmayāh|یرمِ?یاہ|Jer))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Ezek"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ḥiziqīʾīl|ح(?:ِزقی[\\s\\xa0]*|زقی[\\s\\xa0‌]*)ایل|Ezek))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Dan"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:دانی(?:[\\s\\xa0‌]*ای|ا)ل|dānīʾīl|Dan))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Hos"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ہو(?:[\\s\\xa0]*سیعاہ|سیع(?:َِ)?)|hūsīʿ|Hos))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Joel"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:یُ?وایل|(?:yōʾī|Joe)l))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Amos"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:عامُ?وس|(?:ʿāmō|Amo)s))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Obad"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ʿabadiyāh|عبدیاہ|Obad))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jonah"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ی(?:ُوناہ|ونس)|yūnas|Jonah))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Mic"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:مِ?یکاہ|mīkāh|Mic))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Nah"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:نا(?:[\\s\\xa0]*حُ|حُ?)وم|nāḥūm|Nah))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Hab"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ḥabaqqūq|حبق(?:ُّ|ّ)?وق|Hab))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Zeph"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ṣafaniyāh|صفنیاہ|Zeph))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Hag"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ḥajjai|حج(?:َّی|يّ|ی)|Hag))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Zech"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:zakariyāh|زکریاہ?|Zech))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Mal"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:malākī|ملاکی|Mal))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Matt"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:mattī[\\s\\xa0]*kī[\\s\\xa0]*injīl|متّ?ی[\\s\\xa0]*کی[\\s\\xa0]*انجیل|متّ?ی|Matt))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Mark"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:marqus[\\s\\xa0]*kī[\\s\\xa0]*injīl|مرقُ?س[\\s\\xa0]*کی[\\s\\xa0]*انجیل|مرقس|Mark))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Luke"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ل(?:ُوقا(?:[\\s\\xa0]*کی[\\s\\xa0]*انجیل)?|وقا(?:[\\s\\xa0]*کی[\\s\\xa0]*انجیل)?)|lūqā[\\s\\xa0]*kī[\\s\\xa0]*injīl|Luke))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2John"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])((?:yūḥannā[\\s\\xa0]*kā[\\s\\xa0]*dūsrā[\\s\\xa0]*ʿām[\\s\\xa0]*ḫaṭ|ی(?:ُوحنّا[\\s\\xa0]*کا[\\s\\xa0]*دوسرا[\\s\\xa0]*عام|وحن(?:ا[\\s\\xa0]*کا[\\s\\xa0]*دوسرا[\\s\\xa0]*عام|ّا[\\s\\xa0]*کا[\\s\\xa0]*دوسرا))[\\s\\xa0]*خط|دوم(?:\\-?یُوحنّ|[\\s\\xa0]*یُ?وحنّ|۔یوحن)ا|(?:2\\.|۲)(?:\\-?یُوحنّ|[\\s\\xa0]*یُ?وحنّ|۔یوحن)ا|2(?:\\-?یُوحنّا|[\\s\\xa0]*یُ?وحنّا|۔یوحنا|John)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["3John"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])((?:yūḥannā[\\s\\xa0]*kā[\\s\\xa0]*tīsrā[\\s\\xa0]*ʿām[\\s\\xa0]*ḫaṭ|ی(?:ُوحنّا[\\s\\xa0]*کا[\\s\\xa0]*تیسرا[\\s\\xa0]*عام|وحن(?:ا[\\s\\xa0]*کا[\\s\\xa0]*تیسرا[\\s\\xa0]*عام|ّا[\\s\\xa0]*کا[\\s\\xa0]*(?:تیسرا|3\\.|3|۳)))[\\s\\xa0]*خط|تیسرا(?:\\-?یُوحنّ|[\\s\\xa0]*یُ?وحنّ|۔یوحن)ا|(?:3\\.|۳)(?:\\-?یُوحنّ|[\\s\\xa0]*یُ?وحنّ|۔یوحن)ا|3(?:\\-?یُوحنّا|[\\s\\xa0]*یُ?وحنّا|۔یوحنا|John)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1John"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])((?:yūḥannā[\\s\\xa0]*kā[\\s\\xa0]*pahlā[\\s\\xa0]*ʿām[\\s\\xa0]*ḫaṭ|ی(?:ُوحنّ|وحنّ?)ا[\\s\\xa0]*کا[\\s\\xa0]*پہلا[\\s\\xa0]*عام[\\s\\xa0]*خط|اوّل(?:\\-?یُوحنّ|[\\s\\xa0]*یُ?وحنّ|۔یوحن)ا|(?:1\\.|۱)(?:\\-?یُوحنّ|[\\s\\xa0]*یُ?وحنّ|۔یوحن)ا|1(?:\\-?یُوحنّا|[\\s\\xa0]*یُ?وحنّا|۔یوحنا|John)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["John"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ی(?:ُوحنّ|وحن)ا[\\s\\xa0]*کی[\\s\\xa0]*انجیل|yūḥannā[\\s\\xa0]*kī[\\s\\xa0]*injīl|ی(?:ُوحنّ|وحن)ا|John))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Acts"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:رسُ?ولوں[\\s\\xa0]*کے[\\s\\xa0]*اعمال|rasūlōṅ[\\s\\xa0]*ke[\\s\\xa0]*aʿmāl|یوحنا[\\s\\xa0]*کے[\\s\\xa0]*اعمال|رسولوں|اَعمال|اعمال|Acts))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Rom"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ر(?:ومیوں(?:[\\s\\xa0]*کے[\\s\\xa0]*نام[\\s\\xa0]*(?:پولس[\\s\\xa0]*رسول[\\s\\xa0]*)?کا[\\s\\xa0]*خط)?|ُومِیوں)|rōmiyōṅ[\\s\\xa0]*ke[\\s\\xa0]*nām[\\s\\xa0]*kā[\\s\\xa0]*ḫaṭ|Rom))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Cor"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])((?:ک(?:رنتھ(?:ِیُوں[\\s\\xa0]*کے[\\s\\xa0]*نام[\\s\\xa0]*پولس[\\s\\xa0]*رسول|یوں[\\s\\xa0]*کے[\\s\\xa0]*نام)|ُرِنتھِیوں[\\s\\xa0]*کے[\\s\\xa0]*نام)[\\s\\xa0]*کا[\\s\\xa0]*دوسرا[\\s\\xa0]*خط|kurintʰiyōṅ[\\s\\xa0]*ke[\\s\\xa0]*nām[\\s\\xa0]*kā[\\s\\xa0]*dūsrā[\\s\\xa0]*ḫaṭ|دوم(?:\\-?کُرِنتھِی|[\\s\\xa0]*کرنتھ(?:ِیُ|ی)|[\\s\\xa0]*کُرنتھِی|۔کرنتھی)وں|(?:2\\.|۲)(?:\\-?کُرِنتھِی|[\\s\\xa0]*کرنتھ(?:ِیُ|ی)|[\\s\\xa0]*کُرنتھِی|۔کرنتھی)وں|2(?:\\-?کُرِنتھِیوں|[\\s\\xa0]*کرنتھ(?:ِیُ|ی)وں|[\\s\\xa0]*کُرنتھِیوں|۔کرنتھیوں|Cor)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Cor"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])((?:ک(?:رنتھ(?:ِیُوں[\\s\\xa0]*کے[\\s\\xa0]*نام[\\s\\xa0]*پولس[\\s\\xa0]*رسول|یوں[\\s\\xa0]*کے[\\s\\xa0]*نام)|ُرِنتھِیوں[\\s\\xa0]*کے[\\s\\xa0]*نام)[\\s\\xa0]*کا[\\s\\xa0]*پہلا[\\s\\xa0]*خط|kurintʰiyōṅ[\\s\\xa0]*ke[\\s\\xa0]*nām[\\s\\xa0]*kā[\\s\\xa0]*pahlā[\\s\\xa0]*ḫaṭ|اوّل(?:\\-?کُرِنتھِی|[\\s\\xa0]*کرنتھِیُ|[\\s\\xa0]*کُرنتھِی|۔کرنتھی)وں|(?:1\\.|۱)(?:\\-?کُرِنتھِی|[\\s\\xa0]*کرنتھِیُ|[\\s\\xa0]*کُرنتھِی|۔کرنتھی)وں|1(?:\\-?کُرِنتھِیوں|[\\s\\xa0]*کرنتھِیُوں|[\\s\\xa0]*کُرنتھِیوں|۔کرنتھیوں|Cor)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Gal"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:گلت(?:یوں(?:[\\s\\xa0]*کے[\\s\\xa0]*نام[\\s\\xa0]*(?:پولُس[\\s\\xa0]*رسول[\\s\\xa0]*)?کا[\\s\\xa0]*خط)?|ِیوں(?:[\\s\\xa0]*کے[\\s\\xa0]*نام[\\s\\xa0]*کا[\\s\\xa0]*خط)?)|galatiyōṅ[\\s\\xa0]*ke[\\s\\xa0]*nām[\\s\\xa0]*kā[\\s\\xa0]*ḫaṭ|Gal))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Eph"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ا(?:فسیوں(?:[\\s\\xa0]*کے[\\s\\xa0]*نام[\\s\\xa0]*(?:پو[\\s\\xa0]*لس[\\s\\xa0]*رسول[\\s\\xa0]*)?کا[\\s\\xa0]*خط)?|ِف(?:ِسِیوں[\\s\\xa0]*کے[\\s\\xa0]*نام[\\s\\xa0]*کا[\\s\\xa0]*خط|سِ?یوں))|ifisiyōṅ[\\s\\xa0]*ke[\\s\\xa0]*nām[\\s\\xa0]*kā[\\s\\xa0]*ḫaṭ|Eph))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Phil"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ف(?:ِل(?:ِپ(?:ّیُوں(?:[\\s\\xa0]*کے[\\s\\xa0]*نام[\\s\\xa0]*پو[\\s\\xa0]*لس[\\s\\xa0]*رسُول[\\s\\xa0]*کا[\\s\\xa0]*خط)?|ِّیوں[\\s\\xa0]*کے[\\s\\xa0]*نام[\\s\\xa0]*کا[\\s\\xa0]*خط)|پّیوں)|لپیوں(?:[\\s\\xa0]*کے[\\s\\xa0]*نام[\\s\\xa0]*کا[\\s\\xa0]*خط)?)|filippiyōṅ[\\s\\xa0]*ke[\\s\\xa0]*nām[\\s\\xa0]*kā[\\s\\xa0]*ḫaṭ|Phil))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Col"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ک(?:ُل(?:ِسّیوں(?:[\\s\\xa0]*کے[\\s\\xa0]*نام[\\s\\xa0]*پولُس[\\s\\xa0]*رسُول[\\s\\xa0]*کا[\\s\\xa0]*خط)?|ُسِّیوں[\\s\\xa0]*کے[\\s\\xa0]*نام[\\s\\xa0]*کا[\\s\\xa0]*خط|س[ِّ]یوں)|لسیوں(?:[\\s\\xa0]*کے[\\s\\xa0]*نام[\\s\\xa0]*کا[\\s\\xa0]*خط)?)|kulussiyōṅ[\\s\\xa0]*ke[\\s\\xa0]*nām[\\s\\xa0]*kā[\\s\\xa0]*ḫaṭ|Col))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Thess"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])((?:تھ(?:سلنیک(?:وں[\\s\\xa0]*کے[\\s\\xa0]*نام[\\s\\xa0]*پو[\\s\\xa0]*لس[\\s\\xa0]*رسول[\\s\\xa0]*کا|یوں[\\s\\xa0]*کے[\\s\\xa0]*نام[\\s\\xa0]*کا[\\s\\xa0]*)|ِسّلُنیکیوں[\\s\\xa0]*کے[\\s\\xa0]*نام[\\s\\xa0]*کا[\\s\\xa0]*)دوسرا[\\s\\xa0]*خط|tʰissalunīkiyōṅ[\\s\\xa0]*ke[\\s\\xa0]*nām[\\s\\xa0]*kā[\\s\\xa0]*dūsrā[\\s\\xa0]*ḫaṭ|دوم(?:\\-?تھِسّلُنیکی|[\\s\\xa0]*تھِسلُنیکی|(?:[\\s\\xa0]*تھسّ|۔تھس)لنیکی|[\\s\\xa0]*تھسلنیک)وں|(?:2\\.|۲)(?:\\-?تھِسّلُنیکی|[\\s\\xa0]*تھِسلُنیکی|(?:[\\s\\xa0]*تھسّ|۔تھس)لنیکی|[\\s\\xa0]*تھسلنیک)وں|2(?:\\-?تھِسّلُنیکیوں|[\\s\\xa0]*تھِسلُنیکیوں|(?:[\\s\\xa0]*تھسّ|۔تھس)لنیکیوں|[\\s\\xa0]*تھسلنیکوں|Thess)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Thess"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])((?:تھ(?:س(?:ّلنیکیوں[\\s\\xa0]*کے[\\s\\xa0]*نام[\\s\\xa0]*پولس[\\s\\xa0]*رسول|لنیکیوں[\\s\\xa0]*کے[\\s\\xa0]*نام)|ِسّلُنیکیوں[\\s\\xa0]*کے[\\s\\xa0]*نام)[\\s\\xa0]*کا[\\s\\xa0]*پہلا[\\s\\xa0]*خط|tʰissalunīkiyōṅ[\\s\\xa0]*ke[\\s\\xa0]*nām[\\s\\xa0]*kā[\\s\\xa0]*pahlā[\\s\\xa0]*ḫaṭ|اوّل(?:\\-?تھِسّلُ|[\\s\\xa0]*تھِسلُ|(?:[\\s\\xa0]*تھسّ|۔تھس)ل)نیکیوں|(?:1\\.|۱)(?:\\-?تھِسّلُ|[\\s\\xa0]*تھِسلُ|(?:[\\s\\xa0]*تھسّ|۔تھس)ل)نیکیوں|1(?:\\-?تھِسّلُنیکیوں|[\\s\\xa0]*تھِسلُنیکیوں|(?:[\\s\\xa0]*تھسّ|۔تھس)لنیکیوں|Thess)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Tim"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])((?:ت(?:ی(?:ِمُتھِیُس[\\s\\xa0]*کے[\\s\\xa0]*نام[\\s\\xa0]*پولس[\\s\\xa0]*رسول|متھیس[\\s\\xa0]*کے[\\s\\xa0]*نام)|ِیمُتھِیُس[\\s\\xa0]*کے[\\s\\xa0]*نام)[\\s\\xa0]*کا[\\s\\xa0]*دوسرا[\\s\\xa0]*خط|tīmutʰiyus[\\s\\xa0]*ke[\\s\\xa0]*nām[\\s\\xa0]*kā[\\s\\xa0]*dūsrā[\\s\\xa0]*ḫaṭ|دوم(?:\\-?تِیمُتھِیُ|[\\s\\xa0]*ت(?:ی(?:ِمُتھِیُ|مِتھُی)|ِیمُتھِیُ)|۔تیمتھی)س|(?:2\\.|۲)(?:\\-?تِیمُتھِیُ|[\\s\\xa0]*ت(?:ی(?:ِمُتھِیُ|مِتھُی)|ِیمُتھِیُ)|۔تیمتھی)س|2(?:\\-?تِیمُتھِیُس|[\\s\\xa0]*ت(?:ی(?:ِمُتھِیُ|مِتھُی)|ِیمُتھِیُ)س|۔تیمتھیس|Tim)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Tim"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])((?:ت(?:ِیمُتھِیُس[\\s\\xa0]*کے[\\s\\xa0]*نام[\\s\\xa0]*(?:پولُس[\\s\\xa0]*رسول[\\s\\xa0]*)?|یمتھیس[\\s\\xa0]*کے[\\s\\xa0]*نام[\\s\\xa0]*)کا[\\s\\xa0]*پہلا[\\s\\xa0]*خط|tīmutʰiyus[\\s\\xa0]*ke[\\s\\xa0]*nām[\\s\\xa0]*kā[\\s\\xa0]*pahlā[\\s\\xa0]*ḫaṭ|اوّل(?:\\-?تِیمُتھِیُ|[\\s\\xa0]*ت(?:ِیمُتھِیُ|یمِتھُی)|۔تیمتھی)س|(?:1\\.|۱)(?:\\-?تِیمُتھِیُ|[\\s\\xa0]*ت(?:ِیمُتھِیُ|یمِتھُی)|۔تیمتھی)س|1(?:\\-?تِیمُتھِیُس|[\\s\\xa0]*ت(?:ِیمُتھِیُ|یمِتھُی)س|۔تیمتھیس|Tim)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Titus"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ط(?:ِطُس(?:[\\s\\xa0]*کے[\\s\\xa0]*نام[\\s\\xa0]*(?:پولس[\\s\\xa0]*رسُول[\\s\\xa0]*)?کا[\\s\\xa0]*خط)?|طس(?:[\\s\\xa0]*کے[\\s\\xa0]*نام[\\s\\xa0]*کا[\\s\\xa0]*خط)?)|ṭiṭus[\\s\\xa0]*ke[\\s\\xa0]*nām[\\s\\xa0]*kā[\\s\\xa0]*ḫaṭ|Titus))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Phlm"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ف(?:لیمون(?:[\\s\\xa0]*کے[\\s\\xa0]*نام[\\s\\xa0]*(?:پولس[\\s\\xa0]*رسُول[\\s\\xa0]*)?کا[\\s\\xa0]*خط)?|ِلیمون(?:[\\s\\xa0]*کے[\\s\\xa0]*نام[\\s\\xa0]*کا[\\s\\xa0]*خط)?)|filēmōn[\\s\\xa0]*ke[\\s\\xa0]*nām[\\s\\xa0]*kā[\\s\\xa0]*ḫaṭ|Phlm))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Heb"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ع(?:برانیوں(?:[\\s\\xa0]*کے[\\s\\xa0]*نام[\\s\\xa0]*(?:پولس[\\s\\xa0]*رسول[\\s\\xa0]*)?کا[\\s\\xa0]*خط)?|ِبرانیوں(?:[\\s\\xa0]*کے[\\s\\xa0]*نام[\\s\\xa0]*کا[\\s\\xa0]*خط)?)|ʿibrāniyōṅ[\\s\\xa0]*ke[\\s\\xa0]*nām[\\s\\xa0]*kā[\\s\\xa0]*ḫaṭ|Heb))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jas"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:yaʿqūb[\\s\\xa0]*kā[\\s\\xa0]*ʿām[\\s\\xa0]*ḫaṭ|یعق(?:ُوب[\\s\\xa0]*کا[\\s\\xa0]*عا|وب[\\s\\xa0]*کا[\\s\\xa0]*عا[\\s\\xa0]*?)م[\\s\\xa0]*خط|یعقُ?وب|يعقوب|Jas))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Pet"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])((?:paṭras[\\s\\xa0]*kā[\\s\\xa0]*dūsrā[\\s\\xa0]*ʿām[\\s\\xa0]*ḫaṭ|پطرس[\\s\\xa0]*کا[\\s\\xa0]*دوسرا[\\s\\xa0]*عام[\\s\\xa0]*خط|دوم(?:[\\s\\xa0]*پطر[\\s\\xa0]*?|[\\x2D۔]پطر)س|(?:2\\.|۲)(?:[\\s\\xa0]*پطر[\\s\\xa0]*?|[\\x2D۔]پطر)س|2(?:[\\s\\xa0]*پطر[\\s\\xa0]*?س|[\\x2D۔]پطرس|Pet)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Pet"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])((?:paṭras[\\s\\xa0]*kā[\\s\\xa0]*pahlā[\\s\\xa0]*ʿām[\\s\\xa0]*ḫaṭ|پطر(?:[\\s\\xa0]*س[\\s\\xa0]*کاپہلا[\\s\\xa0]*عا[\\s\\xa0]*|س[\\s\\xa0]*کا[\\s\\xa0]*پہلا[\\s\\xa0]*عا)م[\\s\\xa0]*خط|اوّل(?:[\\s\\xa0]*پطر[\\s\\xa0]*?|[\\x2D۔]پطر)س|(?:1\\.|۱)(?:[\\s\\xa0]*پطر[\\s\\xa0]*?|[\\x2D۔]پطر)س|1(?:[\\s\\xa0]*پطر[\\s\\xa0]*?س|[\\x2D۔]پطرس|Pet)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jude"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:yahūdāh[\\s\\xa0]*kā[\\s\\xa0]*ʿām[\\s\\xa0]*ḫaṭ|یہُ?وداہ[\\s\\xa0]*کا[\\s\\xa0]*عام[\\s\\xa0]*خط|یہُ?وداہ|Jude))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Tob"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Tob))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jdt"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Jdt))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Bar"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Bar))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Sus"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Sus))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Macc"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])((?:2Macc))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["3Macc"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])((?:3Macc))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["4Macc"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])((?:4Macc))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Macc"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])((?:1Macc))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
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
