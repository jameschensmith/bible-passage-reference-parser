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
(?:^|[^\\x1f\\x1e\\dA-Za-zªµºÀ-ÖØ-öø-ɏऀ-ंऄ-ऺ़-ऽु-ै्ॐ-ॣॱ-ॷॹ-ॿḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ꣠-ꣷꣻ])\
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
|chapter|verse|and|ff|-\
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
bcv_parser.prototype.regexps.pre_book = "[^A-Za-zªµºÀ-ÖØ-öø-ɏऀ-ंऄ-ऺ़-ऽु-ै्ॐ-ॣॱ-ॷॹ-ॿḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ꣠-ꣷꣻ]";

bcv_parser.prototype.regexps.first = `1\\.?${bcv_parser.prototype.regexps.space}*`;
bcv_parser.prototype.regexps.second = `2\\.?${bcv_parser.prototype.regexps.space}*`;
bcv_parser.prototype.regexps.third = `3\\.?${bcv_parser.prototype.regexps.space}*`;
bcv_parser.prototype.regexps.range_and = `(?:[&\u2013\u2014-]|and|-)`;
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
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:उत्पत्ति(?:को(?:[\\s\\xa0]*पुस्तक)?)?|utpattiko[\\s\\xa0]*pustak|utpattiko|Gen))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Exod"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:प्रस्थानको[\\s\\xa0]*पुस्तक|prastʰ[aā]nko(?:[\\s\\xa0]*pustak)?|प्रस्थान(?:को)?|Exod))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Bel"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Bel))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Lev"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:lev[iī]har[uū]ko(?:[\\s\\xa0]*pustak)?|लेव(?:ीहरूको[\\s\\xa0]*पुस्तक|ि)|लेवी(?:हरूको)?|Lev))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Num"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:गन्तीको[\\s\\xa0]*पुस्तक|gant[iī]ko(?:[\\s\\xa0]*pustak)?|गन्ती(?:को)?|Num))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
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
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:यर्मियाको[\\s\\xa0]*विलाप|yarmiy[aā]ko[\\s\\xa0]*vil[aā]p|विलाप|Lam))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["EpJer"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:EpJer))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Rev"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:y[uū]hann[aā]l[aā][iī][\\s\\xa0]*bʰaeko[\\s\\xa0]*prak[aā][sš]|यूहन्नालाई[\\s\\xa0]*भएको[\\s\\xa0]*प्रकाश|Rev)|(?:प्रकाश))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["PrMan"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:PrMan))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Deut"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:vyavastʰ[aā]ko(?:[\\s\\xa0]*pustak)?|व्य(?:वस्थाको[\\s\\xa0]*पुस्तक|ावस्था)|व्यवस्था(?:को)?|Deut))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Josh"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:yaho[sš][uū]ko(?:[\\s\\xa0]*pustak)?|यहोशूको[\\s\\xa0]*पुस्तक|यहोशू(?:को)?|Josh))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Judg"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:न्यायकर्त(?:्त)?ाहरूको[\\s\\xa0]*पुस्तक|ny[aā]yakartt[aā]har[uū]ko[\\s\\xa0]*pustak|न्यायकर्ता|Judg)|(?:न्यायकर्त्ताहरूको|ny[aā]yakartt[aā]har[uū]ko))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Ruth"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:r[uū]tʰko(?:[\\s\\xa0]*pustak)?|रूथको[\\s\\xa0]*पुस्तक|रूथ(?:को)?|Ruth))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Esd"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏऀ-ंऄ-ऺ़-ऽु-ै्ॐ-ॣॱ-ॷॹ-ॿḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ꣠-ꣷꣻ])((?:1Esd))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Esd"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏऀ-ंऄ-ऺ़-ऽु-ै्ॐ-ॣॱ-ॷॹ-ॿḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ꣠-ꣷꣻ])((?:2Esd))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Isa"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ya[sš]əiy[aā]ko(?:[\\s\\xa0]*pustak)?|य(?:शैयाको[\\s\\xa0]*पुस्तक|ेशैया)|यशैया(?:को)?|Isa))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Sam"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏऀ-ंऄ-ऺ़-ऽु-ै्ॐ-ॣॱ-ॷॹ-ॿḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ꣠-ꣷꣻ])((?:शमूएलको[\\s\\xa0]*दोस्रो[\\s\\xa0]*पुस्तक|2(?:\\.[\\s\\xa0]*(?:[sš]am[uū]elko|श(?:मूएलको|ामुएल))|[\\s\\xa0]*(?:[sš]am[uū]elko|श(?:मूएलको|ामुएल))|\\.?[\\s\\xa0]*शमूएल|Sam)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Sam"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏऀ-ंऄ-ऺ़-ऽु-ै्ॐ-ॣॱ-ॷॹ-ॿḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ꣠-ꣷꣻ])((?:शमूएलको[\\s\\xa0]*पहिलो[\\s\\xa0]*पुस्तक|[sš]am[uū]elko[\\s\\xa0]*pustak|1(?:\\.[\\s\\xa0]*(?:[sš]am[uū]elko|श(?:मूएलको|ामुएल))|[\\s\\xa0]*(?:[sš]am[uū]elko|श(?:मूएलको|ामुएल))|Sam)|1\\.?[\\s\\xa0]*शमूएल))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Kgs"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏऀ-ंऄ-ऺ़-ऽु-ै्ॐ-ॣॱ-ॷॹ-ॿḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ꣠-ꣷꣻ])((?:राजाहरूको[\\s\\xa0]*दोस्रो[\\s\\xa0]*पुस्तक|2(?:\\.[\\s\\xa0]*(?:r[aā]ǳ[aā]har[uū]ko|राजाहरूको)|[\\s\\xa0]*(?:r[aā]ǳ[aā]har[uū]ko|राजाहरूको)|\\.?[\\s\\xa0]*राजा|Kgs)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Kgs"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏऀ-ंऄ-ऺ़-ऽु-ै्ॐ-ॣॱ-ॷॹ-ॿḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ꣠-ꣷꣻ])((?:राजाहरूक[\\s\\xa0]*पहिल[\\s\\xa0]*पुस्तक|r[aā]ǳ[aā]har[uū]ko[\\s\\xa0]*pustak|1(?:\\.[\\s\\xa0]*(?:r[aā]ǳ[aā]har[uū]ko|राजाहरूको)|[\\s\\xa0]*(?:r[aā]ǳ[aā]har[uū]ko|राजाहरूको)|Kgs)|1\\.?[\\s\\xa0]*राजा))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Chr"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏऀ-ंऄ-ऺ़-ऽु-ै्ॐ-ॣॱ-ॷॹ-ॿḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ꣠-ꣷꣻ])((?:इतिहासको[\\s\\xa0]*दोस्रो[\\s\\xa0]*पुस्तक|2(?:\\.[\\s\\xa0]*(?:इतिहासको|itih[aā]sko)|[\\s\\xa0]*(?:इतिहासको|itih[aā]sko)|\\.?[\\s\\xa0]*इतिहास|Chr)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Chr"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏऀ-ंऄ-ऺ़-ऽु-ै्ॐ-ॣॱ-ॷॹ-ॿḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ꣠-ꣷꣻ])((?:इतिहासको[\\s\\xa0]*पहिलो[\\s\\xa0]*पुस्तक|itih[aā]sko[\\s\\xa0]*pustak|1(?:\\.[\\s\\xa0]*(?:इतिहासको|itih[aā]sko)|[\\s\\xa0]*(?:इतिहासको|itih[aā]sko)|Chr)|1\\.?[\\s\\xa0]*इतिहास))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Ezra"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:एज्रा(?:को(?:[\\s\\xa0]*पुस्तक)?)?|eǳr[aā]ko|Ezra))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Neh"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:नहेम्याहको[\\s\\xa0]*पुस्तक|nahemy[aā]hko(?:[\\s\\xa0]*pustak)?|नहेम्याह(?:को)?|Neh))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["GkEsth"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:GkEsth))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Esth"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:एस्तरको[\\s\\xa0]*पुस्तक|estarko(?:[\\s\\xa0]*pustak)?|एस्तर(?:को)?|Esth))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Job"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:अय्यूब(?:को(?:[\\s\\xa0]*पुस्तक)?)?|ayy[uū]bko[\\s\\xa0]*pustak|ayy[uū]bko|Job))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Ps"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:bʰaǳansa[mṃ]grah|भजनसं?ग्रह|भजन|Ps))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["PrAzar"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:PrAzar))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Prov"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:hitopade[sš]ko(?:[\\s\\xa0]*pustak)?|हितोपदेशको[\\s\\xa0]*पुस्तक|हितोपदेश(?:को)?|Prov))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Eccl"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:upade[sš]akko(?:[\\s\\xa0]*pustak)?|उपदेशकको[\\s\\xa0]*पुस्तक|उपदेशक(?:को)?|Eccl))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["SgThree"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:SgThree))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Song"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:सुलेमानको[\\s\\xa0]*श्रेष्ठगीत|sulem[aā]nko[\\s\\xa0]*[sš]re[sṣ][tṭ]ʰag[iī]t|Song)|(?:श्रेष्ठगीत))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jer"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:यर्मियाको[\\s\\xa0]*पुस्तक|yarmiy[aā]ko(?:[\\s\\xa0]*pustak)?|यर्मिया(?:को)?|Jer))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Ezek"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:iǳakielko(?:[\\s\\xa0]*pustak)?|इजकिएल(?:को[\\s\\xa0]*पुस्तक|को)?|Ezek))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Dan"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:d[aā]niyalko(?:[\\s\\xa0]*pustak)?|दानियलको[\\s\\xa0]*पुस्तक|दानियल(?:को)?|Dan))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Hos"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:होशे(?:को[\\s\\xa0]*पुस्तक)?|ho[sš]e|Hos))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Joel"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:योएल(?:को[\\s\\xa0]*पुस्तक)?|[Jy]oel))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Amos"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:आमोस(?:को[\\s\\xa0]*पुस्तक)?|अमोस|[Aaā]mos))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Obad"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ओबदिया(?:को[\\s\\xa0]*पुस्तक)?|obadiy[aā]|Obad))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jonah"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:योना(?:को[\\s\\xa0]*पुस्तक)?|Jonah|yon[aā]))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Mic"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:म(?:ीका(?:को[\\s\\xa0]*पुस्तक)?|िका)|m[iī]k[aā]|Mic))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Nah"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:नहूम(?:को[\\s\\xa0]*पुस्तक)?|nah[uū]m|Nah))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Hab"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:हबकूक(?:को[\\s\\xa0]*पुस्तक)?|habak[uū]k|Hab))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Zeph"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:सपन्याह(?:को[\\s\\xa0]*पुस्तक)?|(?:sapany[aā]|Zep)h))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Hag"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:हाग्गै(?:को[\\s\\xa0]*पुस्तक)?|h[aā]ggəi|Hag))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Zech"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:जकरिया(?:को[\\s\\xa0]*पुस्तक)?|jakariy[aā]|Zech))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Mal"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:मल(?:ाकी(?:को[\\s\\xa0]*पुस्तक)?|की)|mal[aā]k[iī]|Mal))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Matt"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:matt[iī]le(?:[\\s\\xa0]*lekʰeko[\\s\\xa0]*susm[aā]c[aā]r)?|मत्त(?:ी(?:ले[\\s\\xa0]*लेखे)?को[\\s\\xa0]*सुसमाचार|ि)|मत्ती(?:ले)?|Matt))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Mark"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:mark[uū]sle(?:[\\s\\xa0]*lekʰeko[\\s\\xa0]*susm[aā]c[aā]r)?|मर्क(?:ू(?:स(?:ले[\\s\\xa0]*लेखे)?को[\\s\\xa0]*सुसमाचार|श)|ुस)|मर्कूस(?:ले)?|र्मकूस|र्मकस|Mark))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Luke"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:l[uū]k[aā]le[\\s\\xa0]*lekʰeko[\\s\\xa0]*susm[aā]c[aā]r|ल(?:ूका(?:ले[\\s\\xa0]*लेखे)?को[\\s\\xa0]*सुसमाचार|ुका)|लूका|Luke)|(?:लूकाले|l[uū]k[aā]le))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1John"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏऀ-ंऄ-ऺ़-ऽु-ै्ॐ-ॣॱ-ॷॹ-ॿḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ꣠-ꣷꣻ])((?:y[uū]hann[aā]ko[\\s\\xa0]*pahilo[\\s\\xa0]*patra|यूहन्नाको[\\s\\xa0]*पहिलो[\\s\\xa0]*पत्र|1(?:\\.[\\s\\xa0]*(?:यूहन्नाको|y[uū]hann[aā]ko)|[\\s\\xa0]*(?:यूहन्नाको|y[uū]hann[aā]ko)|John)|1\\.?[\\s\\xa0]*यूहन्ना))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2John"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏऀ-ंऄ-ऺ़-ऽु-ै्ॐ-ॣॱ-ॷॹ-ॿḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ꣠-ꣷꣻ])((?:यूहन्नाको[\\s\\xa0]*दोस्(?:त्)?रो[\\s\\xa0]*पत्र|y[uū]hann[aā]ko[\\s\\xa0]*dostro[\\s\\xa0]*patra|2(?:\\.[\\s\\xa0]*(?:यूहन्नाको|y[uū]hann[aā]ko)|[\\s\\xa0]*(?:यूहन्नाको|y[uū]hann[aā]ko)|John)|2\\.?[\\s\\xa0]*यूहन्ना))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["3John"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏऀ-ंऄ-ऺ़-ऽु-ै्ॐ-ॣॱ-ॷॹ-ॿḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ꣠-ꣷꣻ])((?:यूहन्नाको[\\s\\xa0]*तेस्(?:त्)?रो[\\s\\xa0]*पत्र|y[uū]hann[aā]ko[\\s\\xa0]*testro[\\s\\xa0]*patra|3(?:\\.[\\s\\xa0]*(?:यूहन्नाको|y[uū]hann[aā]ko)|[\\s\\xa0]*(?:यूहन्नाको|y[uū]hann[aā]ko)|John)|3\\.?[\\s\\xa0]*यूहन्ना))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["John"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:y[uū]hann[aā]le[\\s\\xa0]*lekʰeko[\\s\\xa0]*susm[aā]c[aā]r|य(?:ूह(?:न(?:्ना(?:ले[\\s\\xa0]*लेखे)?को[\\s\\xa0]*सुसमाचार|ा)|ान्ना)|(?:ुह|हू)न्ना)|यूहन्ना|John)|(?:यूहन्नाले|y[uū]hann[aā]le))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Acts"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:प्रेरितहरूका[\\s\\xa0]*काम|prerithar[uū]k[aā][\\s\\xa0]*k[aā]m|प्रेरित|Acts))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Rom"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:रोमी(?:हरूलाई[\\s\\xa0]*प(?:ावलको[\\s\\xa0]*प)?त्र)?|rom[iī]har[uū]l[aā][iī][\\s\\xa0]*patra|Rom)|(?:rom[iī]har[uū]l[aā][iī]|रोमीहरूलाई))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Cor"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏऀ-ंऄ-ऺ़-ऽु-ै्ॐ-ॣॱ-ॷॹ-ॿḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ꣠-ꣷꣻ])((?:कोरिन्थीहरूलाई[\\s\\xa0]*(?:पावलको[\\s\\xa0]*दोस|दोस्त)्रो[\\s\\xa0]*पत्र|korintʰ[iī]har[uū]l[aā][iī][\\s\\xa0]*dostro[\\s\\xa0]*patra|2(?:\\.[\\s\\xa0]*(?:korintʰ[iī]har[uū]l[aā][iī]|कोरिन्थीहरूलाई)|[\\s\\xa0]*(?:korintʰ[iī]har[uū]l[aā][iī]|कोरिन्थीहरूलाई)|Cor)|2\\.?[\\s\\xa0]*कोरिन्थी))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Cor"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏऀ-ंऄ-ऺ़-ऽु-ै्ॐ-ॣॱ-ॷॹ-ॿḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ꣠-ꣷꣻ])((?:कोरिन्थीहरूलाई[\\s\\xa0]*प(?:ावलको[\\s\\xa0]*प)?हिलो[\\s\\xa0]*पत्र|korintʰ[iī]har[uū]l[aā][iī][\\s\\xa0]*pahilo[\\s\\xa0]*patra|1(?:\\.[\\s\\xa0]*(?:korintʰ[iī]har[uū]l[aā][iī]|कोरिन्थीहरूलाई)|[\\s\\xa0]*(?:korintʰ[iī]har[uū]l[aā][iī]|कोरिन्थीहरूलाई)|Cor)|1\\.?[\\s\\xa0]*कोरिन्थी))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Gal"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:गलाती(?:हरूलाई[\\s\\xa0]*प(?:ावलको[\\s\\xa0]*प)?त्र)?|gal[aā]t[iī]har[uū]l[aā][iī][\\s\\xa0]*patra|Gal)|(?:gal[aā]t[iī]har[uū]l[aā][iī]|गलातीहरूलाई))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Eph"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:एफिसी(?:हरूलाई[\\s\\xa0]*प(?:ावलको[\\s\\xa0]*प)?त्र)?|epʰis[iī]har[uū]l[aā][iī][\\s\\xa0]*patra|Eph)|(?:epʰis[iī]har[uū]l[aā][iī]|एफिसीहरूलाई))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Phil"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:फिलिप्पी(?:हरूलाई[\\s\\xa0]*प(?:ावलको[\\s\\xa0]*प)?त्र)?|pʰilipp[iī]har[uū]l[aā][iī][\\s\\xa0]*patra|Phil)|(?:pʰilipp[iī]har[uū]l[aā][iī]|फिलिप्पीहरूलाई))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Col"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:कलस्सी(?:हरूलाई[\\s\\xa0]*प(?:ावलको[\\s\\xa0]*प)?त्र)?|kalass[iī]har[uū]l[aā][iī][\\s\\xa0]*patra|Col)|(?:kalass[iī]har[uū]l[aā][iī]|कलस्सीहरूलाई))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Thess"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏऀ-ंऄ-ऺ़-ऽु-ै्ॐ-ॣॱ-ॷॹ-ॿḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ꣠-ꣷꣻ])((?:थिस्सलोनिकीहरूलाई[\\s\\xa0]*(?:पावलको[\\s\\xa0]*दोस|दोस्त)्रो[\\s\\xa0]*पत्र|tʰissalonik[iī]har[uū]l[aā][iī][\\s\\xa0]*dostro[\\s\\xa0]*patra|2(?:\\.[\\s\\xa0]*(?:tʰissalonik[iī]har[uū]l[aā][iī]|थिस्सलोनिकीहरूलाई)|[\\s\\xa0]*(?:tʰissalonik[iī]har[uū]l[aā][iī]|थिस्सलोनिकीहरूलाई)|Thess)|2\\.?[\\s\\xa0]*थिस्सलोनिकी))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Thess"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏऀ-ंऄ-ऺ़-ऽु-ै्ॐ-ॣॱ-ॷॹ-ॿḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ꣠-ꣷꣻ])((?:थिस्सलोनिकीहरूलाई[\\s\\xa0]*प(?:ावलको[\\s\\xa0]*प)?हिलो[\\s\\xa0]*पत्र|tʰissalonik[iī]har[uū]l[aā][iī][\\s\\xa0]*pahilo[\\s\\xa0]*patra|1(?:\\.[\\s\\xa0]*(?:tʰissalonik[iī]har[uū]l[aā][iī]|थिस्सलोनिकीहरूलाई)|[\\s\\xa0]*(?:tʰissalonik[iī]har[uū]l[aā][iī]|थिस्सलोनिकीहरूलाई)|Thess)|1\\.?[\\s\\xa0]*थिस्सलोनिकी))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Tim"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏऀ-ंऄ-ऺ़-ऽु-ै्ॐ-ॣॱ-ॷॹ-ॿḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ꣠-ꣷꣻ])((?:तिमोथीलाई[\\s\\xa0]*(?:पावलको[\\s\\xa0]*दोस|दोस्त)्रो[\\s\\xa0]*पत्र|timotʰ[iī]l[aā][iī][\\s\\xa0]*dostro[\\s\\xa0]*patra|2(?:\\.[\\s\\xa0]*(?:timotʰ[iī]l[aā][iī]|तिमोथीलाई)|[\\s\\xa0]*(?:timotʰ[iī]l[aā][iī]|तिमोथीलाई)|Tim)|2\\.?[\\s\\xa0]*तिमोथी))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Tim"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏऀ-ंऄ-ऺ़-ऽु-ै्ॐ-ॣॱ-ॷॹ-ॿḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ꣠-ꣷꣻ])((?:तिमोथीलाई(?:र्[\\s\\xa0]*पावलको)?[\\s\\xa0]*पहिलो[\\s\\xa0]*पत्र|timotʰ[iī]l[aā][iī][\\s\\xa0]*pahilo[\\s\\xa0]*patra|1(?:\\.[\\s\\xa0]*(?:timotʰ[iī]l[aā][iī]|तिमोथीलाई)|[\\s\\xa0]*(?:timotʰ[iī]l[aā][iī]|तिमोथीलाई)|Tim)|1\\.?[\\s\\xa0]*तिमोथी))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Titus"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:तीतस(?:लाई[\\s\\xa0]*प(?:ावलको[\\s\\xa0]*प)?त्र)?|t[iī]tasl[aā][iī][\\s\\xa0]*patra|Titus)|(?:t[iī]tasl[aā][iī]|तीतसलाई))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Phlm"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:फिलेमोन(?:लाई(?:[\\s\\xa0]*प(?:ावलको[\\s\\xa0]*प)?त्र)?)?|pʰilemonl[aā][iī][\\s\\xa0]*patra|pʰilemonl[aā][iī]|Phlm))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Heb"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:हिब्रूहरूको[\\s\\xa0]*निम्ति[\\s\\xa0]*पत्र|hibr[uū]har[uū]ko[\\s\\xa0]*nimti(?:[\\s\\xa0]*patra)?|हिब्रू(?:हरूको[\\s\\xa0]*निम्ति)?|Heb))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jas"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:y[aā]k[uū]bko(?:[\\s\\xa0]*patra)?|याकूबको[\\s\\xa0]*पत्र|याकूब(?:को)?|Jas))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Pet"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏऀ-ंऄ-ऺ़-ऽु-ै्ॐ-ॣॱ-ॷॹ-ॿḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ꣠-ꣷꣻ])((?:पत्रुसको[\\s\\xa0]*दोस्(?:त्)?रो[\\s\\xa0]*पत्र|patrusko[\\s\\xa0]*dostro[\\s\\xa0]*patra|2(?:\\.[\\s\\xa0]*(?:पत्रुसको|patrusko)|[\\s\\xa0]*(?:पत्रुसको|patrusko)|Pet)|2\\.?[\\s\\xa0]*पत्रुस))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Pet"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏऀ-ंऄ-ऺ़-ऽु-ै्ॐ-ॣॱ-ॷॹ-ॿḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ꣠-ꣷꣻ])((?:patrusko[\\s\\xa0]*pahilo[\\s\\xa0]*patra|पत्रुसको[\\s\\xa0]*पहिलो[\\s\\xa0]*पत्र|1(?:\\.[\\s\\xa0]*(?:पत्रुसको|patrusko)|[\\s\\xa0]*(?:पत्रुसको|patrusko)|Pet)|1\\.?[\\s\\xa0]*पत्रुस))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jude"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:yah[uū]d[aā]ko(?:[\\s\\xa0]*patra)?|यहूदाको[\\s\\xa0]*पत्र|यहूदा(?:को)?|Jude))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
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
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏऀ-ंऄ-ऺ़-ऽु-ै्ॐ-ॣॱ-ॷॹ-ॿḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ꣠-ꣷꣻ])((?:2Macc))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["3Macc"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏऀ-ंऄ-ऺ़-ऽु-ै्ॐ-ॣॱ-ॷॹ-ॿḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ꣠-ꣷꣻ])((?:3Macc))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["4Macc"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏऀ-ंऄ-ऺ़-ऽु-ै्ॐ-ॣॱ-ॷॹ-ॿḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ꣠-ꣷꣻ])((?:4Macc))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Macc"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏऀ-ंऄ-ऺ़-ऽु-ै्ॐ-ॣॱ-ॷॹ-ॿḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ꣠-ꣷꣻ])((?:1Macc))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
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
