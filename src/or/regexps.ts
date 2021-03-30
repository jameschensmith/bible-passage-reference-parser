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
(?:^|[^\\x1f\\x1e\\dA-Za-zଁଅ-ଌଏ-ଐଓ-ନପ-ରଲ-ଳଵ-ହ଼-ଽିୁ-ୄ୍ୖଡ଼-ଢ଼ୟ-ୣୱ])\
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
|chapter|verse|ଠାରୁ|and|ff\
|[ଖ](?!\\w)\
|$\
)+\
)`, "gi");
// These are the only valid ways to end a potential passage match. The closing parenthesis allows for fully capturing parentheses surrounding translations (ESV**)**. The last one, `[\d\x1f]` needs not to be +; otherwise `Gen5ff` becomes `\x1f0\x1f5ff`, and `adjust_regexp_end` matches the `\x1f5` and incorrectly dangles the ff.
// 'ff09' is a full-width closing parenthesis.
bcv_parser.prototype.regexps.match_end_split = new RegExp(`\
\\d\\W*title\
|\\d\\W*ff(?:[\\s\\xa0*]*\\.)?\
|\\d[\\s\\xa0*]*[ଖ](?!\\w)\
|\\x1e(?:[\\s\\xa0*]*[)\\]\\uff09])?\
|[\\d\\x1f]`, "gi");
bcv_parser.prototype.regexps.control = /[\x1e\x1f]/g;
bcv_parser.prototype.regexps.pre_book = "[^A-Za-zଁଅ-ଌଏ-ଐଓ-ନପ-ରଲ-ଳଵ-ହ଼-ଽିୁ-ୄ୍ୖଡ଼-ଢ଼ୟ-ୣୱ]";

bcv_parser.prototype.regexps.first = `(?:ପ୍ରଥମ|1)\\.?${bcv_parser.prototype.regexps.space}*`;
bcv_parser.prototype.regexps.second = `(?:ଦ୍ୱିତୀୟ|2)\\.?${bcv_parser.prototype.regexps.space}*`;
bcv_parser.prototype.regexps.third = `(?:ତୃତୀୟ|3)\\.?${bcv_parser.prototype.regexps.space}*`;
bcv_parser.prototype.regexps.range_and = `(?:[&\u2013\u2014-]|and|ଠାରୁ)`;
bcv_parser.prototype.regexps.range_only = "(?:[\u2013\u2014-]|ଠାରୁ)";
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
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ଆଦି(?:ପୁସ୍ତକ)?|Gen))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Exod"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ଯାତ୍ରା(?:[\\s\\xa0]*ପୁସ୍ତକ|ପୁସ୍ତକ)?|Exod))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Bel"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Bel))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Lev"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ଲେବୀୟ(?:[\\s\\xa0]*ପୁସ୍ତକ)?|Lev))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Num"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ଗଣନା(?:[\\s\\xa0]*ପୁସ୍ତକ)?|Num))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
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
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ଯିରିମିୟଙ୍କ[\\s\\xa0]*ବିଳାପ|Lam))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["EpJer"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:EpJer))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Rev"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ଯୋହନଙ୍କ[\\s\\xa0]*ପ୍ରତି[\\s\\xa0]*ପ୍ରକାଶିତ[\\s\\xa0]*ବାକ୍ୟ|Rev))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["PrMan"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:PrMan))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Deut"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ଦ୍ୱିତୀୟ[\\s\\xa0]*ବିବରଣୀ?|ବିବରଣି|Deut))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Josh"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ଯିହୋଶୂୟଙ୍କର(?:[\\s\\xa0]*ପୁସ୍ତକ)?|Josh))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Judg"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ବିଗ୍ଭରକର୍ତ୍ତାମାନଙ୍କ[\\s\\xa0]*ବିବରଣ|Judg))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Ruth"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ଋତର[\\s\\xa0]*ବିବରଣ[\\s\\xa0]*ପୁସ୍ତକ|Ruth))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Esd"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zଁଅ-ଌଏ-ଐଓ-ନପ-ରଲ-ଳଵ-ହ଼-ଽିୁ-ୄ୍ୖଡ଼-ଢ଼ୟ-ୣୱ])((?:1Esd))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Esd"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zଁଅ-ଌଏ-ଐଓ-ନପ-ରଲ-ଳଵ-ହ଼-ଽିୁ-ୄ୍ୖଡ଼-ଢ଼ୟ-ୣୱ])((?:2Esd))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Isa"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ଯ(?:ିଶାଇୟ(?:[\\s\\xa0]*ଭବିଷ୍ୟ‌ଦ୍‌ବକ୍ତାଙ୍କର[\\s\\xa0]*ପୁସ୍ତକ)?|[ାୀ]ଶାଇୟ)|ୟିଶାୟ|ୟଶାଇୟ|Isa))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Sam"],
			regexp: new RegExp(`(^|[^0-9A-Za-zଁଅ-ଌଏ-ଐଓ-ନପ-ରଲ-ଳଵ-ହ଼-ଽିୁ-ୄ୍ୖଡ଼-ଢ଼ୟ-ୣୱ])((?:2\\.?[\\s\\xa0]*ଶାମୁୟେଲଙ)|(?:ଶାମୁୟେଲଙ୍କ[\\s\\xa0]*ଦ୍ୱିତୀୟ[\\s\\xa0]*ପୁସ୍ତକ|ଦ୍ୱିତୀୟ[\\s\\xa0]*ଶାମୁୟେଲଙ|ଦ୍ୱିତୀୟ[\\s\\xa0]*ଶାମୁୟେଲ|2(?:\\.[\\s\\xa0]*ଶାମୁୟେଲ|[\\s\\xa0]*ଶାମୁୟେଲ|Sam)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Sam"],
			regexp: new RegExp(`(^|[^0-9A-Za-zଁଅ-ଌଏ-ଐଓ-ନପ-ରଲ-ଳଵ-ହ଼-ଽିୁ-ୄ୍ୖଡ଼-ଢ଼ୟ-ୣୱ])((?:1\\.?[\\s\\xa0]*ଶାମୁୟେଲଙ)|(?:ଶାମୁୟେଲଙ୍କ[\\s\\xa0]*ପ୍ରଥମ[\\s\\xa0]*ପୁସ୍ତକ|ପ୍ରଥମ[\\s\\xa0]*ଶାମୁୟେଲଙ|ପ୍ରଥମ[\\s\\xa0]*ଶାମୁୟେଲ|1(?:\\.[\\s\\xa0]*ଶାମୁୟେଲ|[\\s\\xa0]*ଶାମୁୟେଲ|Sam)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Kgs"],
			regexp: new RegExp(`(^|[^0-9A-Za-zଁଅ-ଌଏ-ଐଓ-ନପ-ରଲ-ଳଵ-ହ଼-ଽିୁ-ୄ୍ୖଡ଼-ଢ଼ୟ-ୣୱ])((?:2\\.?[\\s\\xa0]*ରାଜାବଳୀର)|(?:ରାଜାବଳୀର[\\s\\xa0]*ଦ୍ୱିତୀୟ[\\s\\xa0]*ପୁସ୍ତକ|ଦ୍ୱିତୀୟ[\\s\\xa0]*ରାଜାବଳୀର|ଦ୍ୱିତୀୟ[\\s\\xa0]*ରାଜାବଳୀ|2(?:\\.[\\s\\xa0]*ରାଜାବଳୀ|[\\s\\xa0]*ରାଜାବଳୀ|Kgs)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Kgs"],
			regexp: new RegExp(`(^|[^0-9A-Za-zଁଅ-ଌଏ-ଐଓ-ନପ-ରଲ-ଳଵ-ହ଼-ଽିୁ-ୄ୍ୖଡ଼-ଢ଼ୟ-ୣୱ])((?:1\\.?[\\s\\xa0]*ରାଜାବଳୀର)|(?:ରାଜାବଳୀର[\\s\\xa0]*ପ୍ରଥମ[\\s\\xa0]*ପୁସ୍ତକ|ପ୍ରଥମ[\\s\\xa0]*ରାଜାବଳୀର|ପ୍ରଥମ[\\s\\xa0]*ରାଜାବଳୀ|1(?:\\.[\\s\\xa0]*ରାଜାବଳୀ|[\\s\\xa0]*ରାଜାବଳୀ|Kgs)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Chr"],
			regexp: new RegExp(`(^|[^0-9A-Za-zଁଅ-ଌଏ-ଐଓ-ନପ-ରଲ-ଳଵ-ହ଼-ଽିୁ-ୄ୍ୖଡ଼-ଢ଼ୟ-ୣୱ])((?:2\\.?[\\s\\xa0]*ବଂଶାବଳୀର)|(?:ବଂଶାବଳୀର[\\s\\xa0]*ଦ୍ୱିତୀୟ[\\s\\xa0]*ପୁସ୍ତକ|ଦ୍ୱିତୀୟ[\\s\\xa0]*ବଂଶାବଳୀର|ଦ୍ୱିତୀୟ[\\s\\xa0]*ବଂଶାବଳୀ|2(?:\\.[\\s\\xa0]*ବଂଶାବଳୀ|[\\s\\xa0]*ବଂଶାବଳୀ|Chr)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Chr"],
			regexp: new RegExp(`(^|[^0-9A-Za-zଁଅ-ଌଏ-ଐଓ-ନପ-ରଲ-ଳଵ-ହ଼-ଽିୁ-ୄ୍ୖଡ଼-ଢ଼ୟ-ୣୱ])((?:1\\.?[\\s\\xa0]*ବଂଶାବଳୀର)|(?:ବଂଶାବଳୀର[\\s\\xa0]*ପ୍ରଥମ[\\s\\xa0]*ପୁସ୍ତକ|ପ୍ରଥମ[\\s\\xa0]*ବଂଶାବଳୀର|ପ୍ରଥମ[\\s\\xa0]*ବଂଶାବଳୀ|1(?:\\.[\\s\\xa0]*ବଂଶାବଳୀ|[\\s\\xa0]*ବଂଶାବଳୀ|Chr)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Ezra"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ଏଜ୍ରା|Ezra))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Neh"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ନିହିମିୟାଙ୍କର(?:[\\s\\xa0]*ପୁସ୍ତକ)?|Neh))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["GkEsth"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:GkEsth))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Esth"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ଏଷ୍ଟର[\\s\\xa0]*ବିବରଣ|Esth))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Job"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ଆୟୁବ(?:[\\s\\xa0]*ପୁସ୍ତକ)?|Job))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Ps"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ଗ(?:ୀତି?|ାତ)ସଂହିତା|Ps))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["PrAzar"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:PrAzar))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Prov"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ହିତୋପଦେଶ|Prov))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Eccl"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ଉପଦେଶକ|Eccl))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["SgThree"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:SgThree))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Song"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ପରମଗୀତ|Song))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jer"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ଯିରିମିୟ(?:[\\s\\xa0]*ଭବିଷ୍ୟ‌ଦ୍‌ବକ୍ତାଙ୍କ[\\s\\xa0]*ପୁସ୍ତକ)?|Jer))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Ezek"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ଯିହିଜିକଲ(?:[\\s\\xa0]*ଭବିଷ୍ୟ‌ଦ୍‌ବକ୍ତାଙ୍କ[\\s\\xa0]*ପୁସ୍ତକ)?|Ezek))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Dan"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ଦାନିୟେଲଙ(?:୍କ[\\s\\xa0]*ପୁସ୍ତକ)?|Dan))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Hos"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ହୋଶ(?:େୟ(?:[\\s\\xa0]*ଭବିଷ୍ୟ‌ଦ୍‌ବକ୍ତାଙ୍କ[\\s\\xa0]*ପୁସ୍ତକ)?|ହେ)|Hos))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Joel"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ଯୋୟେଲ(?:[\\s\\xa0]*ଭବିଷ୍ୟ‌ଦ୍‌ବକ୍ତାଙ୍କ[\\s\\xa0]*ପୁସ୍ତକ)?|Joel))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Amos"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ଆମୋଷ(?:[\\s\\xa0]*ଭବିଷ୍ୟ‌ଦ୍‌ବକ୍ତାଙ୍କ[\\s\\xa0]*ପୁସ୍ତକ)?|Amos))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Obad"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ଓବଦିଅ(?:[\\s\\xa0]*ଭବିଷ୍ୟ‌ଦ୍‌ବକ୍ତାଙ୍କ[\\s\\xa0]*ପୁସ୍ତକ)?|Obad))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jonah"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ଯୂନସ(?:[\\s\\xa0]*ଭବିଷ୍ୟ‌ଦ୍‌ବକ୍ତାଙ୍କ[\\s\\xa0]*ପୁସ୍ତକ)?|Jonah))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Mic"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ମ(?:ୀଖା(?:[\\s\\xa0]*ଭବିଷ୍ୟ‌ଦ୍‌ବକ୍ତାଙ୍କ[\\s\\xa0]*ପୁସ୍ତକ)?|ିଖା)|Mic))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Nah"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ନାହୂମ(?:[\\s\\xa0]*ଭବିଷ୍ୟ‌ଦ୍‌ବକ୍ତାଙ୍କ[\\s\\xa0]*ପୁସ୍ତକ)?|Nah))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Hab"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ହବ(?:‌କ୍‌କୂକ(?:[\\s\\xa0]*ଭବିଷ୍ୟ‌ଦ୍‌ବକ୍ତାଙ୍କ[\\s\\xa0]*ପୁସ୍ତକ)?|କ[ୁୂ]କ୍)|Hab))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Zeph"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ସିଫନିୟ(?:[\\s\\xa0]*ଭବିଷ୍ୟ‌ଦ୍‌ବକ୍ତାଙ୍କ[\\s\\xa0]*ପୁସ୍ତକ)?|Zeph))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Hag"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ହାଗୟ(?:[\\s\\xa0]*ଭବିଷ୍ୟ‌ଦ୍‌ବକ୍ତାଙ୍କ[\\s\\xa0]*ପୁସ୍ତକ)?|Hag))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Zech"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ଯିଖରିୟ(?:[\\s\\xa0]*ଭବିଷ୍ୟ‌ଦ୍‌ବକ୍ତାଙ୍କ[\\s\\xa0]*ପୁସ୍ତକ)?|Zech))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Mal"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ମଲାଖି(?:[\\s\\xa0]*ଭବିଷ୍ୟ‌ଦ୍‌ବକ୍ତାଙ୍କ[\\s\\xa0]*ପୁସ୍ତକ)?|Mal))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Matt"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ମାଥିଉ(?:[\\s\\xa0]*ଲିଖିତ[\\s\\xa0]*ସୁସମାଗ୍ଭର)?|Matt))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Mark"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ମାର୍କ(?:[\\s\\xa0]*ଲିଖିତ[\\s\\xa0]*ସୁସମାଗ୍ଭର)?|Mark))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Luke"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ଲୂକ(?:[\\s\\xa0]*ଲିଖିତ[\\s\\xa0]*ସୁସମାଗ୍ଭର)?|Luke))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1John"],
			regexp: new RegExp(`(^|[^0-9A-Za-zଁଅ-ଌଏ-ଐଓ-ନପ-ରଲ-ଳଵ-ହ଼-ଽିୁ-ୄ୍ୖଡ଼-ଢ଼ୟ-ୣୱ])((?:ଯୋହନଙ୍କ[\\s\\xa0]*ପ୍ରଥମ[\\s\\xa0]*ପତ୍ର|ପ୍ରଥମ[\\s\\xa0]*ଯୋହନଙ|1(?:\\.[\\s\\xa0]*ଯୋହନଙ|[\\s\\xa0]*ଯୋହନଙ|John)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2John"],
			regexp: new RegExp(`(^|[^0-9A-Za-zଁଅ-ଌଏ-ଐଓ-ନପ-ରଲ-ଳଵ-ହ଼-ଽିୁ-ୄ୍ୖଡ଼-ଢ଼ୟ-ୣୱ])((?:ଯୋହନଙ୍କ[\\s\\xa0]*ଦ୍ୱିତୀୟ[\\s\\xa0]*ପତ୍ର|ଦ୍ୱିତୀୟ[\\s\\xa0]*ଯୋହନଙ|2(?:\\.[\\s\\xa0]*ଯୋହନଙ|[\\s\\xa0]*ଯୋହନଙ|John)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["3John"],
			regexp: new RegExp(`(^|[^0-9A-Za-zଁଅ-ଌଏ-ଐଓ-ନପ-ରଲ-ଳଵ-ହ଼-ଽିୁ-ୄ୍ୖଡ଼-ଢ଼ୟ-ୣୱ])((?:ଯୋହନଙ୍କ[\\s\\xa0]*ତୃତୀୟ[\\s\\xa0]*ପତ୍ର|ତୃତୀୟ[\\s\\xa0]*ଯୋହନଙ|3(?:\\.[\\s\\xa0]*ଯୋହନଙ|[\\s\\xa0]*ଯୋହନଙ|John)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["John"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ଯୋହନ(?:[\\s\\xa0]*ଲିଖିତ[\\s\\xa0]*ସୁସମାଗ୍ଭର)?|John))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Acts"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ପ୍ରେରିତ(?:ମାନଙ୍କ[\\s\\xa0]*କାର୍ଯ୍ୟର[\\s\\xa0]*ବିବରଣ)?|Acts))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Rom"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ରୋମୀୟଙ୍କ(?:[\\s\\xa0]*ପ୍ରତି[\\s\\xa0]*ପତ୍ର)?|Rom))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Cor"],
			regexp: new RegExp(`(^|[^0-9A-Za-zଁଅ-ଌଏ-ଐଓ-ନପ-ରଲ-ଳଵ-ହ଼-ଽିୁ-ୄ୍ୖଡ଼-ଢ଼ୟ-ୣୱ])((?:2\\.?[\\s\\xa0]*କରିନ୍ଥୀୟଙ୍କ)|(?:କରିନ୍ଥୀୟଙ୍କ[\\s\\xa0]*ପ୍ରତି[\\s\\xa0]*ଦ୍ୱିତୀୟ[\\s\\xa0]*ପତ୍ର|ଦ୍ୱିତୀୟ[\\s\\xa0]*କରିନ୍ଥୀୟଙ୍କ|ଦ୍ୱିତୀୟ[\\s\\xa0]*କରିନ୍ଥୀୟ|2(?:\\.[\\s\\xa0]*କରିନ୍ଥୀୟ|[\\s\\xa0]*କରିନ୍ଥୀୟ|Cor)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Cor"],
			regexp: new RegExp(`(^|[^0-9A-Za-zଁଅ-ଌଏ-ଐଓ-ନପ-ରଲ-ଳଵ-ହ଼-ଽିୁ-ୄ୍ୖଡ଼-ଢ଼ୟ-ୣୱ])((?:1\\.?[\\s\\xa0]*କରିନ୍ଥୀୟଙ୍କ)|(?:କରିନ୍ଥୀୟଙ୍କ[\\s\\xa0]*ପ୍ରତି[\\s\\xa0]*ପ୍ରଥମ[\\s\\xa0]*ପତ୍ର|ପ୍ରଥମ[\\s\\xa0]*କରିନ୍ଥୀୟଙ୍କ|ପ୍ରଥମ[\\s\\xa0]*କରିନ୍ଥୀୟ|1(?:\\.[\\s\\xa0]*କରିନ୍ଥୀୟ|[\\s\\xa0]*କରିନ୍ଥୀୟ|Cor)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Gal"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ଗାଲାତୀୟଙ୍କ(?:[\\s\\xa0]*ପ୍ରତି[\\s\\xa0]*ପତ୍ର)?|Gal))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Eph"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ଏଫିସୀୟଙ୍କ(?:[\\s\\xa0]*ପ୍ରତି[\\s\\xa0]*ପତ୍ର)?|Eph))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Phil"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ଫିଲି‌ପ୍‌ପୀୟଙ୍କ(?:[\\s\\xa0]*ପ୍ରତି[\\s\\xa0]*ପତ୍ର)?|Phil))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Col"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:କଲସୀୟଙ୍କ(?:[\\s\\xa0]*ପ୍ରତି[\\s\\xa0]*ପତ୍ର)?|Col))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Thess"],
			regexp: new RegExp(`(^|[^0-9A-Za-zଁଅ-ଌଏ-ଐଓ-ନପ-ରଲ-ଳଵ-ହ଼-ଽିୁ-ୄ୍ୖଡ଼-ଢ଼ୟ-ୣୱ])((?:ଥେସଲନୀକୀୟଙ୍କ[\\s\\xa0]*ପ୍ରତି[\\s\\xa0]*ଦ୍ୱିତୀୟ[\\s\\xa0]*ପତ୍ର|ଦ୍ୱିତୀୟ[\\s\\xa0]*ଥେସଲନୀକୀୟଙ|2(?:\\.[\\s\\xa0]*ଥେସଲନୀକୀୟଙ|[\\s\\xa0]*ଥେସଲନୀକୀୟଙ|Thess)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Thess"],
			regexp: new RegExp(`(^|[^0-9A-Za-zଁଅ-ଌଏ-ଐଓ-ନପ-ରଲ-ଳଵ-ହ଼-ଽିୁ-ୄ୍ୖଡ଼-ଢ଼ୟ-ୣୱ])((?:ଥେସଲନୀକୀୟଙ୍କ[\\s\\xa0]*ପ୍ରତି[\\s\\xa0]*ପ୍ରଥମ[\\s\\xa0]*ପତ୍ର|ପ୍ରଥମ[\\s\\xa0]*ଥେସଲନୀକୀୟଙ|1(?:\\.[\\s\\xa0]*ଥେସଲନୀକୀୟଙ|[\\s\\xa0]*ଥେସଲନୀକୀୟଙ|Thess)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Tim"],
			regexp: new RegExp(`(^|[^0-9A-Za-zଁଅ-ଌଏ-ଐଓ-ନପ-ରଲ-ଳଵ-ହ଼-ଽିୁ-ୄ୍ୖଡ଼-ଢ଼ୟ-ୣୱ])((?:ତୀମଥିଙ୍କ[\\s\\xa0]*ପ୍ରତି[\\s\\xa0]*ଦ୍ୱିତୀୟ[\\s\\xa0]*ପତ୍ର|ଦ୍ୱିତୀୟ[\\s\\xa0]*ତୀମଥିଙ୍କ|2(?:\\.[\\s\\xa0]*ତୀମଥିଙ୍କ|[\\s\\xa0]*ତୀମଥିଙ୍କ|Tim)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Tim"],
			regexp: new RegExp(`(^|[^0-9A-Za-zଁଅ-ଌଏ-ଐଓ-ନପ-ରଲ-ଳଵ-ହ଼-ଽିୁ-ୄ୍ୖଡ଼-ଢ଼ୟ-ୣୱ])((?:ତୀମଥିଙ୍କ[\\s\\xa0]*ପ୍ରତି[\\s\\xa0]*ପ୍ରଥମ[\\s\\xa0]*ପତ୍ର|ପ୍ରଥମ[\\s\\xa0]*ତୀମଥିଙ୍କ|1(?:\\.[\\s\\xa0]*ତୀମଥିଙ୍କ|[\\s\\xa0]*ତୀମଥିଙ୍କ|Tim)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Titus"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ତୀତସଙ୍କ(?:[\\s\\xa0]*ପ୍ରତି[\\s\\xa0]*ପତ୍ର)?|Titus))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Phlm"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ଫିଲୀମୋନଙ୍କ(?:[\\s\\xa0]*ପ୍ରତି[\\s\\xa0]*ପତ୍ର)?|Phlm))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Heb"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ଏବ୍ରୀ|Heb))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jas"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ଯାକୁବଙ୍କ(?:[\\s\\xa0]*ପତ୍ର)?|Jas))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Pet"],
			regexp: new RegExp(`(^|[^0-9A-Za-zଁଅ-ଌଏ-ଐଓ-ନପ-ରଲ-ଳଵ-ହ଼-ଽିୁ-ୄ୍ୖଡ଼-ଢ଼ୟ-ୣୱ])((?:ପିତରଙ୍କ[\\s\\xa0]*ଦ୍ୱିତୀୟ[\\s\\xa0]*ପତ୍ର|ଦ୍ୱିତୀୟ[\\s\\xa0]*ପିତରଙ|2(?:\\.[\\s\\xa0]*ପିତରଙ|[\\s\\xa0]*ପିତରଙ|Pet)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Pet"],
			regexp: new RegExp(`(^|[^0-9A-Za-zଁଅ-ଌଏ-ଐଓ-ନପ-ରଲ-ଳଵ-ହ଼-ଽିୁ-ୄ୍ୖଡ଼-ଢ଼ୟ-ୣୱ])((?:ପ(?:ିତରଙ୍କ[\\s\\xa0]*ପ୍ରଥମ[\\s\\xa0]*ପତ୍ର|୍ରଥମ[\\s\\xa0]*ପିତରଙ)|1(?:\\.[\\s\\xa0]*ପିତରଙ|[\\s\\xa0]*ପିତରଙ|Pet)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jude"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:ଯିହୂଦାଙ୍କ(?:[\\s\\xa0]*ପତ୍ର)?|Jude))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
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
			regexp: new RegExp(`(^|[^0-9A-Za-zଁଅ-ଌଏ-ଐଓ-ନପ-ରଲ-ଳଵ-ହ଼-ଽିୁ-ୄ୍ୖଡ଼-ଢ଼ୟ-ୣୱ])((?:2Macc))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["3Macc"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zଁଅ-ଌଏ-ଐଓ-ନପ-ରଲ-ଳଵ-ହ଼-ଽିୁ-ୄ୍ୖଡ଼-ଢ଼ୟ-ୣୱ])((?:3Macc))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["4Macc"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zଁଅ-ଌଏ-ଐଓ-ନପ-ରଲ-ଳଵ-ହ଼-ଽିୁ-ୄ୍ୖଡ଼-ଢ଼ୟ-ୣୱ])((?:4Macc))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Macc"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zଁଅ-ଌଏ-ଐଓ-ନପ-ରଲ-ଳଵ-ହ଼-ଽିୁ-ୄ୍ୖଡ଼-ଢ଼ୟ-ୣୱ])((?:1Macc))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
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
