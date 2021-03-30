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
|titlu(?![a-z])\
|capitolele|capitolul|versetele|versetul|versete|[şs]i|vers|cap|ff|cf|cp|vs|-|v\
|[a-e](?!\\w)\
|$\
)+\
)`, "gi");
// These are the only valid ways to end a potential passage match. The closing parenthesis allows for fully capturing parentheses surrounding translations (ESV**)**. The last one, `[\d\x1f]` needs not to be +; otherwise `Gen5ff` becomes `\x1f0\x1f5ff`, and `adjust_regexp_end` matches the `\x1f5` and incorrectly dangles the ff.
// 'ff09' is a full-width closing parenthesis.
bcv_parser.prototype.regexps.match_end_split = new RegExp(`\
\\d\\W*titlu\
|\\d\\W*ff(?:[\\s\\xa0*]*\\.)?\
|\\d[\\s\\xa0*]*[a-e](?!\\w)\
|\\x1e(?:[\\s\\xa0*]*[)\\]\\uff09])?\
|[\\d\\x1f]`, "gi");
bcv_parser.prototype.regexps.control = /[\x1e\x1f]/g;
bcv_parser.prototype.regexps.pre_book = "[^A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ]";

bcv_parser.prototype.regexps.first = `(?:1|I)\\.?${bcv_parser.prototype.regexps.space}*`;
bcv_parser.prototype.regexps.second = `(?:2|II)\\.?${bcv_parser.prototype.regexps.space}*`;
bcv_parser.prototype.regexps.third = `(?:3|III)\\.?${bcv_parser.prototype.regexps.space}*`;
bcv_parser.prototype.regexps.range_and = `(?:[&\u2013\u2014-]|(?:[şs]i|cf|cp)|-)`;
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
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Facerea|Gen(?:e[sz]a)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Exod"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Ie[sşș]irea|Ex(?:odul|od)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Bel"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Istoria[\\s\\xa0]*(?:omor[a\\xE2]rii[\\s\\xa0]*balaurului[\\s\\xa0]*[sş]i[\\s\\xa0]*a[\\s\\xa0]*sf[aă]r[a\\xE2]m[aă]rii[\\s\\xa0]*lui[\\s\\xa0]*Bel|Balaurului)|Bel[\\s\\xa0]*[sș]i[\\s\\xa0]*dragonul)|(?:Bel))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Lev"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Lev(?:itic(?:ul)?)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Num"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Num(?:erii?)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Sir"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Cartea[\\s\\xa0]*[i\\xEE]n[tţ]elepciunii[\\s\\xa0]*lui[\\s\\xa0]*Isus,[\\s\\xa0]*fiul[\\s\\xa0]*lui[\\s\\xa0]*Sirah|Ec(?:clesiasticul|leziastic)|Sirach|Sir))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Lam"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Pl(?:[a\\xE2]ng(?:eri(?:le[\\s\\xa0]*(?:profetu)?lui[\\s\\xa0]*Ieremia)?)?)?|Lam))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["EpJer"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Ep(?:istola[\\s\\xa0]*lui[\\s\\xa0]*Ieremia|Jer)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["PrMan"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Rug[aă]ciunea[\\s\\xa0]*(?:rege)?lui[\\s\\xa0]*Manase|Manase|PrMan))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Deut"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Deut(?:eronom(?:ul)?)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Josh"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Ios(?:ua(?:[\\s\\xa0]*Navi)?)?|Josh))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Judg"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Jud(?:ec(?:atorii?|ători)|g)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Ruth"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Ruth?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Esd"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:I(?:II\\.?|\\.)?[\\s\\xa0]*Ezdra|1(?:\\.[\\s\\xa0]*Ezdra|[\\s\\xa0]*Ezdra|Esd)|3\\.?[\\s\\xa0]*Ezdra))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Esd"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:I[IV]\\.?[\\s\\xa0]*Ezdra|2(?:\\.[\\s\\xa0]*Ezdra|[\\s\\xa0]*Ezdra|Esd)|4\\.?[\\s\\xa0]*Ezdra))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Isa"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Is(?:a(?:ia)?)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Sam"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Cartea[\\s\\xa0]*(?:a[\\s\\xa0]*doua[\\s\\xa0]*a[\\s\\xa0]*Regilor|II[\\s\\xa0]*a[\\s\\xa0]*(?:lui[\\s\\xa0]*Samuel|Regilor))|(?:II\\.?|2\\.?)[\\s\\xa0]*Regilor|(?:II\\.?|2\\.?)[\\s\\xa0]*Samuel|II(?:\\.[\\s\\xa0]*Sam?|[\\s\\xa0]*Sam?)|2(?:\\.[\\s\\xa0]*Sam?|[\\s\\xa0]*Sam?)|2Sam))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Sam"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Cartea[\\s\\xa0]*(?:[i\\xEE]nt[a\\xE2]i[\\s\\xa0]*a[\\s\\xa0]*Regilor|I[\\s\\xa0]*a[\\s\\xa0]*(?:lui[\\s\\xa0]*Samuel|Regilor))|(?:I\\.?|1\\.?)[\\s\\xa0]*Regilor|(?:I\\.?|1\\.?)[\\s\\xa0]*Samuel|I(?:\\.[\\s\\xa0]*Sam?|[\\s\\xa0]*Sam?)|1(?:\\.[\\s\\xa0]*Sam?|[\\s\\xa0]*Sam?)|1Sam))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Kgs"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Cartea[\\s\\xa0]*(?:a[\\s\\xa0]*patra|IV)[\\s\\xa0]*a[\\s\\xa0]*Regilor|II[\\s\\xa0]*a[\\s\\xa0]*[I\\xCE]mp[aă]ra[tţ]ilor|I(?:I(?:\\.[\\s\\xa0]*(?:[I\\xCE]mp[aă]ra[tţ]|Reg)|[\\s\\xa0]*(?:[I\\xCE]mp[aă]ra[tţ]|Reg))|V\\.?[\\s\\xa0]*Reg)i|2(?:\\.[\\s\\xa0]*[I\\xCE]|[\\s\\xa0]*[I\\xCE])mp[aă]ra[tţ]i|(?:II(?:\\.[\\s\\xa0]*[I\\xCE]|[\\s\\xa0]*[I\\xCE])|2(?:\\.[\\s\\xa0]*[I\\xCE]|[\\s\\xa0]*[I\\xCE]))mp|(?:4\\.?|2\\.|2)[\\s\\xa0]*Regi|2Kgs))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Kgs"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Cartea[\\s\\xa0]*(?:a[\\s\\xa0]*treia|III)[\\s\\xa0]*a[\\s\\xa0]*Regilor|I[\\s\\xa0]*a[\\s\\xa0]*[I\\xCE]mp[aă]ra[tţ]ilor|1(?:\\.[\\s\\xa0]*[I\\xCE]|[\\s\\xa0]*[I\\xCE])mp[aă]ra[tţ]i|I(?:\\.[\\s\\xa0]*[I\\xCE]mp[aă]ra[tţ]|[\\s\\xa0]*(?:[I\\xCE]mp[aă]ra[tţ]|Reg)|(?:II\\.?|\\.)[\\s\\xa0]*Reg)i|(?:3\\.?|1\\.|1)[\\s\\xa0]*Regi|(?:1(?:\\.[\\s\\xa0]*[I\\xCE]|[\\s\\xa0]*[I\\xCE])|I(?:\\.[\\s\\xa0]*[I\\xCE]|[\\s\\xa0]*[I\\xCE]))mp|1Kgs))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Chr"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Cartea[\\s\\xa0]*a[\\s\\xa0]*doua[\\s\\xa0]*Paralipomena|(?:II\\.?|2\\.?)[\\s\\xa0]*Paralipomena|(?:II\\.?[\\s\\xa0]*Cronicilo|2(?:\\.[\\s\\xa0]*Cronicilo|[\\s\\xa0]*Cronicilo|Ch))r|II(?:\\.[\\s\\xa0]*Cron(?:ici)?|[\\s\\xa0]*Cron(?:ici)?)|2(?:\\.[\\s\\xa0]*Cron(?:ici)?|[\\s\\xa0]*Cron(?:ici)?)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Chr"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Cartea[\\s\\xa0]*[i\\xEE]nt[a\\xE2]i[\\s\\xa0]*Paralipomena|(?:I\\.?|1\\.?)[\\s\\xa0]*Paralipomena|(?:I\\.?[\\s\\xa0]*Cronicilo|1(?:\\.[\\s\\xa0]*Cronicilo|[\\s\\xa0]*Cronicilo|Ch))r|I(?:\\.[\\s\\xa0]*Cron(?:ici)?|[\\s\\xa0]*Cron(?:ici)?)|1(?:\\.[\\s\\xa0]*Cron(?:ici)?|[\\s\\xa0]*Cron(?:ici)?)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Ezra"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Ezra))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Neh"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Ne(?:em(?:ia)?|h)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["GkEsth"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:GkEsth))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Esth"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Est(?:er(?:ei|a)|h)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Job"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Job|Iov))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Ps"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Cartea[\\s\\xa0]*Psalmilor|Ps(?:alm(?:ul|ii)|almi?)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["PrAzar"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Rug[aă]ciunea[\\s\\xa0]*lui[\\s\\xa0]*Azaria|PrAzar))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Prov"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:P(?:rov(?:erbe(?:le(?:[\\s\\xa0]*lui[\\s\\xa0]*Solomon)?)?)?|ildele[\\s\\xa0]*lui[\\s\\xa0]*Solomon)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Eccl"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Ec(?:cl(?:esiastul)?|l(?:eziastul|esiastul|eziast)?)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["SgThree"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:C[a\\xE2]ntarea[\\s\\xa0]*celor[\\s\\xa0]*trei[\\s\\xa0]*(?:tiner|evre)i|(?:Trei|3)[\\s\\xa0]*tineri|SgThree))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Song"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:C(?:\\xE2nt(?:area[\\s\\xa0]*lui[\\s\\xa0]*Solomon|area[\\s\\xa0]*C[a\\xE2]nt[aă]rilor|[aă]ri)?|ant(?:ar(?:ea[\\s\\xa0]*(?:lui[\\s\\xa0]*Solomon|(?:canta|C[a\\xE2]nt[aă])rilor)|i)|ări)?)|Song))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Wis"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Cartea[\\s\\xa0]*(?:[i\\xEE]n[tţ]elepciunii[\\s\\xa0]*lui[\\s\\xa0]*Solomon|[I\\xCE]n[tț]elepciunii)|[I\\xCE]n[tț]elepciunea[\\s\\xa0]*lui[\\s\\xa0]*Solomon|Solomon|Wis))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jer"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Ier(?:emia)?|Jer))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Ezek"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Ezek)|(?:Iezechiel|Ez(?:echiel|e(?:ch?)?)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Dan"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Dan(?:iel)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Hos"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Os(?:ea)?|Hos))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Joel"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:(?:Joe|Io[ei])l))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Amos"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Amos))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Obad"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Obad(?:ia)?|Avdie))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jonah"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Jonah|Iona))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Mic"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Mi(?:heia|ca?)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Nah"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Na(?:um|h)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Hab"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Hab(?:acuc)?|Avacum))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Zeph"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:[TŢȚ]efania|Sofonie|Zeph|[TŢȚ]ef))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Hag"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Hag(?:ai)?|Agheu))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Zech"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Z(?:ah(?:aria)?|ech)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Mal"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Mal(?:eahi)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Matt"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:M(?:at(?:ei|t)?|t)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Mark"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:M(?:ar(?:cu?|k)|c)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Luke"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:L(?:u(?:ke|ca?)|c)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1John"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:(?:I\\.?[\\s\\xa0]*Ioa|1(?:\\.[\\s\\xa0]*Ioa|[\\s\\xa0]*Ioa|Joh|[\\s\\xa0]*I))n))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2John"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:(?:II\\.?[\\s\\xa0]*Ioa|2(?:\\.[\\s\\xa0]*Ioa|[\\s\\xa0]*Ioa|Joh|[\\s\\xa0]*I))n))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["3John"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:(?:III\\.?[\\s\\xa0]*Ioa|3(?:\\.[\\s\\xa0]*Ioa|[\\s\\xa0]*Ioa|Joh|[\\s\\xa0]*I))n))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Acts"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:F(?:ap(?:t(?:e(?:le(?:[\\s\\xa0]*Apostolilor)?|[\\s\\xa0]*Apostolilor)?)?)?|\\.(?:[\\s\\xa0]*Ap|A)|[\\s\\xa0]*Ap|A)|Acts))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Rev"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Ap(?:oc(?:alipsa(?:[\\s\\xa0]*lui[\\s\\xa0]*Ioan)?)?)?|Rev))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["John"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:(?:Joh|I(?:oa)?)n))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Rom"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Rom(?:ani)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Cor"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:II(?:\\.[\\s\\xa0]*Co(?:r(?:inti?eni)?)?|[\\s\\xa0]*Co(?:r(?:inti?eni)?)?)|2(?:\\.[\\s\\xa0]*Co(?:r(?:inti?eni)?)?|[\\s\\xa0]*Co(?:r(?:inti?eni)?)?|Cor)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Cor"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:I(?:\\.[\\s\\xa0]*Co(?:r(?:inti?eni)?)?|[\\s\\xa0]*Co(?:r(?:inti?eni)?)?)|1(?:\\.[\\s\\xa0]*Co(?:r(?:inti?eni)?)?|[\\s\\xa0]*Co(?:r(?:inti?eni)?)?|Cor)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Gal"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Gal(?:ateni)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Eph"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:E(?:f(?:es(?:eni)?)?|ph)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Phil"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:F(?:il(?:ip(?:eni)?)?|lp)|Phil))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Col"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Col(?:oseni)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Thess"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:II(?:\\.[\\s\\xa0]*Tes(?:aloniceni)?|[\\s\\xa0]*Tes(?:aloniceni)?)|2(?:\\.[\\s\\xa0]*Tes(?:aloniceni)?|[\\s\\xa0]*Tes(?:aloniceni)?|Thess)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Thess"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:I(?:\\.[\\s\\xa0]*Tes(?:aloniceni)?|[\\s\\xa0]*Tes(?:aloniceni)?)|1(?:\\.[\\s\\xa0]*Tes(?:aloniceni)?|[\\s\\xa0]*Tes(?:aloniceni)?|Thess)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Tim"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:II(?:\\.[\\s\\xa0]*Tim(?:otei)?|[\\s\\xa0]*Tim(?:otei)?)|2(?:\\.[\\s\\xa0]*Tim(?:otei)?|[\\s\\xa0]*Tim(?:otei)?|Tim)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Tim"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:I(?:\\.[\\s\\xa0]*Tim(?:otei)?|[\\s\\xa0]*Tim(?:otei)?)|1(?:\\.[\\s\\xa0]*Tim(?:otei)?|[\\s\\xa0]*Tim(?:otei)?|Tim)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Titus"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Tit(?:us)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Phlm"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Filim(?:on)?|Phlm))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Heb"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Evr(?:ei)?|Heb))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jas"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Iac(?:o[bv])?|Jas))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Pet"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:II(?:\\.[\\s\\xa0]*P(?:et(?:ru)?|t)|[\\s\\xa0]*P(?:et(?:ru)?|t))|2(?:\\.[\\s\\xa0]*P(?:et(?:ru)?|t)|[\\s\\xa0]*P(?:et(?:ru)?|t)|Pet)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Pet"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:I(?:\\.[\\s\\xa0]*P(?:et(?:ru)?|t)|[\\s\\xa0]*P(?:et(?:ru)?|t))|1(?:\\.[\\s\\xa0]*P(?:et(?:ru)?|t)|[\\s\\xa0]*P(?:et(?:ru)?|t)|Pet)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jude"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Jude|Iuda))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Tob"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Cartea[\\s\\xa0]*lui[\\s\\xa0]*Tobit|Tob(?:it)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jdt"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Iudita|Jdt))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Bar"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Bar(?:uh)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Sus"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Istoria[\\s\\xa0]*Susanei|Sus(?:anei|ana)?))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Macc"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:II\\.?[\\s\\xa0]*Macabei|2(?:\\.[\\s\\xa0]*Macabei|[\\s\\xa0]*Macabei|Macc)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["3Macc"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:III\\.?[\\s\\xa0]*Macabei|3(?:\\.[\\s\\xa0]*Macabei|[\\s\\xa0]*Macabei|Macc)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["4Macc"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:IV\\.?[\\s\\xa0]*Macabei|4(?:\\.[\\s\\xa0]*Macabei|[\\s\\xa0]*Macabei|Macc)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Macc"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:I\\.?[\\s\\xa0]*Macabei|1(?:\\.[\\s\\xa0]*Macabei|[\\s\\xa0]*Macabei|Macc)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
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
