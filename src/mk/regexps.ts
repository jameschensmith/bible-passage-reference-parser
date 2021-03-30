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
(?:^|[^\\x1f\\x1e\\dA-Za-zªµºÀ-ÖØ-öø-ɏЀ-ҁ҃-҇Ҋ-ԧḀ-ỿⱠ-Ɀⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])\
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
|глави|глава|verse|ff|-|и\
|[аб](?!\\w)\
|$\
)+\
)`, "gi");
// These are the only valid ways to end a potential passage match. The closing parenthesis allows for fully capturing parentheses surrounding translations (ESV**)**. The last one, `[\d\x1f]` needs not to be +; otherwise `Gen5ff` becomes `\x1f0\x1f5ff`, and `adjust_regexp_end` matches the `\x1f5` and incorrectly dangles the ff.
// 'ff09' is a full-width closing parenthesis.
bcv_parser.prototype.regexps.match_end_split = new RegExp(`\
\\d\\W*title\
|\\d\\W*ff(?:[\\s\\xa0*]*\\.)?\
|\\d[\\s\\xa0*]*[аб](?!\\w)\
|\\x1e(?:[\\s\\xa0*]*[)\\]\\uff09])?\
|[\\d\\x1f]`, "gi");
bcv_parser.prototype.regexps.control = /[\x1e\x1f]/g;
bcv_parser.prototype.regexps.pre_book = "[^A-Za-zªµºÀ-ÖØ-öø-ɏЀ-ҁ҃-҇Ҋ-ԧḀ-ỿⱠ-Ɀⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ]";

bcv_parser.prototype.regexps.first = `(?:Прва|Прво|1|I)\\.?${bcv_parser.prototype.regexps.space}*`;
bcv_parser.prototype.regexps.second = `(?:Втора|Второ|2|II)\\.?${bcv_parser.prototype.regexps.space}*`;
bcv_parser.prototype.regexps.third = `(?:Трета|Трето|3|III)\\.?${bcv_parser.prototype.regexps.space}*`;
bcv_parser.prototype.regexps.range_and = `(?:[&\u2013\u2014-]|и|-)`;
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
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏЀ-ҁ҃-҇Ҋ-ԧḀ-ỿⱠ-Ɀⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Прв[ао][\\s\\xa0]*книга[\\s\\xa0]*Мојсеева|[1I]\\.[\\s\\xa0]*книга[\\s\\xa0]*Мојсеева|[1I][\\s\\xa0]*книга[\\s\\xa0]*Мојсеева|Настанување|Битие|Gen))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Exod"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏЀ-ҁ҃-҇Ҋ-ԧḀ-ỿⱠ-Ɀⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Втор[ао][\\s\\xa0]*книга[\\s\\xa0]*Мојсеева|(?:II|2)\\.[\\s\\xa0]*книга[\\s\\xa0]*Мојсеева|(?:II|2)[\\s\\xa0]*книга[\\s\\xa0]*Мојсеева|Излез|Exod))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Bel"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Bel))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Lev"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Трета[\\s\\xa0]*книга[\\s\\xa0]*Мојсеева|Левитска[\\s\\xa0]*книга|Левит(?:ска)?|Lev))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Num"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Четврта[\\s\\xa0]*книга[\\s\\xa0]*Мојсеева|Броеви|Num))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Sir"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Sir))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Wis"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Книга[\\s\\xa0]*Мудрост[\\s\\xa0]*Соломонова|Wis))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Lam"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Плач(?:от[\\s\\xa0]*на[\\s\\xa0]*Еремија|[\\s\\xa0]*(?:на[\\s\\xa0]*)?Еремиин)|Lam))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["EpJer"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:EpJer))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Rev"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Откровение|Rev))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["PrMan"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:PrMan))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Deut"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:П(?:етта[\\s\\xa0]*книга[\\s\\xa0]*Мојсеева|овторени[\\s\\xa0]*закони)|Второзаконие|Deut))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Josh"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Книга[\\s\\xa0]*на[\\s\\xa0]*Исус[\\s\\xa0]*Невин|Исус[\\s\\xa0]*Навин|Ј[ео]шуа|Josh))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Judg"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Книга[\\s\\xa0]*на[\\s\\xa0]*израелеви[\\s\\xa0]*судии|Судии|Judg))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Ruth"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Ruth|Рут))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Esd"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏЀ-ҁ҃-҇Ҋ-ԧḀ-ỿⱠ-Ɀⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:1Esd))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Esd"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏЀ-ҁ҃-҇Ҋ-ԧḀ-ỿⱠ-Ɀⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:2Esd))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Isa"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Исаи?ја|Isa))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Sam"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏЀ-ҁ҃-҇Ҋ-ԧḀ-ỿⱠ-Ɀⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Втор[ао][\\s\\xa0]*(?:книга[\\s\\xa0]*Самоилова|Самуил)|(?:II|2)\\.[\\s\\xa0]*(?:книга[\\s\\xa0]*Самоилова|Самуил)|(?:II|2)[\\s\\xa0]*(?:книга[\\s\\xa0]*Самоилова|Самуил)|2Sam))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Sam"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏЀ-ҁ҃-҇Ҋ-ԧḀ-ỿⱠ-Ɀⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Прв[ао][\\s\\xa0]*(?:книга[\\s\\xa0]*Самоилова|Самуил)|[1I]\\.[\\s\\xa0]*(?:книга[\\s\\xa0]*Самоилова|Самуил)|[1I][\\s\\xa0]*(?:книга[\\s\\xa0]*Самоилова|Самуил)|1Sam))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Kgs"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏЀ-ҁ҃-҇Ҋ-ԧḀ-ỿⱠ-Ɀⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Втор[ао][\\s\\xa0]*(?:книга[\\s\\xa0]*за[\\s\\xa0]*царевите|Цареви)|(?:II|2)\\.[\\s\\xa0]*(?:книга[\\s\\xa0]*за[\\s\\xa0]*царевите|Цареви)|(?:II|2)[\\s\\xa0]*(?:книга[\\s\\xa0]*за[\\s\\xa0]*царевите|Цареви)|2Kgs))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Kgs"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏЀ-ҁ҃-҇Ҋ-ԧḀ-ỿⱠ-Ɀⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Прв[ао][\\s\\xa0]*(?:книга[\\s\\xa0]*за[\\s\\xa0]*царевите|Цареви)|[1I]\\.[\\s\\xa0]*(?:книга[\\s\\xa0]*за[\\s\\xa0]*царевите|Цареви)|[1I][\\s\\xa0]*(?:книга[\\s\\xa0]*за[\\s\\xa0]*царевите|Цареви)|1Kgs))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Chr"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏЀ-ҁ҃-҇Ҋ-ԧḀ-ỿⱠ-Ɀⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Втор[ао][\\s\\xa0]*(?:книга[\\s\\xa0]*л|Л)етописи|(?:II|2)\\.[\\s\\xa0]*(?:книга[\\s\\xa0]*л|Л)етописи|(?:II|2)[\\s\\xa0]*(?:книга[\\s\\xa0]*л|Л)етописи|2Chr))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Chr"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏЀ-ҁ҃-҇Ҋ-ԧḀ-ỿⱠ-Ɀⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Прв[ао][\\s\\xa0]*(?:книга[\\s\\xa0]*л|Л)етописи|[1I]\\.[\\s\\xa0]*(?:книга[\\s\\xa0]*л|Л)етописи|[1I][\\s\\xa0]*(?:книга[\\s\\xa0]*л|Л)етописи|1Chr))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Ezra"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Езра|Ezra))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Neh"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Нех?емија|Neh))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["GkEsth"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:GkEsth))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Esth"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Ест(?:ира|ер)|Esth))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Job"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Јов|Job))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Ps"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Псалми|Ps))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["PrAzar"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:PrAzar))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Prov"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Пословици|Изреки|Prov))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Eccl"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Проповедник|Eccl))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["SgThree"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:SgThree))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Song"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Песна(?:та[\\s\\xa0]*на(?:д[\\s\\xa0]*песните|[\\s\\xa0]*Соломон)|[\\s\\xa0]*над[\\s\\xa0]*песните)|Црковни[\\s\\xa0]*химни|Song))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jer"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Еремија|Jer))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Ezek"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Езекиел|Ezek))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Dan"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Дание?л|Dan))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Hos"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Хошеа|Осија|Hos))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Joel"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Јо[еи]л|Joel))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Amos"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Амос|Amos))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Obad"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Овадија|Авдиј|Obad))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jonah"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Jonah|Јона))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Mic"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Мих(?:еј|а)|Mic))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Nah"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Наум|Nah))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Hab"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Ха[бв]акук|Hab))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Zeph"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:С(?:офо|ефа)нија|Zeph))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Hag"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Хагај|Агеј|Hag))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Zech"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Захарија|Zech))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Mal"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Малахија|Mal))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Matt"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Евангелие(?:то)?[\\s\\xa0]*според[\\s\\xa0]*Матеј|Матеј|Matt))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Mark"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Евангелие(?:то)?[\\s\\xa0]*според[\\s\\xa0]*Марко|Марко|Mark))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Luke"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Евангелие(?:то)?[\\s\\xa0]*според[\\s\\xa0]*Лука|Luke|Лука))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1John"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏЀ-ҁ҃-҇Ҋ-ԧḀ-ỿⱠ-Ɀⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Прв[ао][\\s\\xa0]*(?:п(?:ослание[\\s\\xa0]*на|исмо[\\s\\xa0]*од)[\\s\\xa0]*апостол[\\s\\xa0]*Јован|Јован(?:ово)?)|[1I]\\.[\\s\\xa0]*(?:п(?:ослание[\\s\\xa0]*на|исмо[\\s\\xa0]*од)[\\s\\xa0]*апостол[\\s\\xa0]*Јован|Јован(?:ово)?)|[1I][\\s\\xa0]*(?:п(?:ослание[\\s\\xa0]*на|исмо[\\s\\xa0]*од)[\\s\\xa0]*апостол[\\s\\xa0]*Јован|Јован(?:ово)?)|1John))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2John"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏЀ-ҁ҃-҇Ҋ-ԧḀ-ỿⱠ-Ɀⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Втор[ао][\\s\\xa0]*(?:п(?:ослание[\\s\\xa0]*на|исмо[\\s\\xa0]*од)[\\s\\xa0]*апостол[\\s\\xa0]*Јован|Јован(?:ово)?)|(?:II|2)\\.[\\s\\xa0]*(?:п(?:ослание[\\s\\xa0]*на|исмо[\\s\\xa0]*од)[\\s\\xa0]*апостол[\\s\\xa0]*Јован|Јован(?:ово)?)|(?:II|2)[\\s\\xa0]*(?:п(?:ослание[\\s\\xa0]*на|исмо[\\s\\xa0]*од)[\\s\\xa0]*апостол[\\s\\xa0]*Јован|Јован(?:ово)?)|2John))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["3John"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏЀ-ҁ҃-҇Ҋ-ԧḀ-ỿⱠ-Ɀⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Трет[ао][\\s\\xa0]*(?:п(?:ослание[\\s\\xa0]*на|исмо[\\s\\xa0]*од)[\\s\\xa0]*апостол[\\s\\xa0]*Јован|Јован(?:ово)?)|(?:III|3)\\.[\\s\\xa0]*(?:п(?:ослание[\\s\\xa0]*на|исмо[\\s\\xa0]*од)[\\s\\xa0]*апостол[\\s\\xa0]*Јован|Јован(?:ово)?)|(?:III|3)[\\s\\xa0]*(?:п(?:ослание[\\s\\xa0]*на|исмо[\\s\\xa0]*од)[\\s\\xa0]*апостол[\\s\\xa0]*Јован|Јован(?:ово)?)|3John))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["John"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Евангелие(?:то)?[\\s\\xa0]*според[\\s\\xa0]*Јован|Јован|John))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Acts"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Дела(?:[\\s\\xa0]*(?:на[\\s\\xa0]*(?:светите[\\s\\xa0]*апостоли|апостолите)|Ап))?|Acts))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Rom"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Писмо[\\s\\xa0]*од[\\s\\xa0]*апостол[\\s\\xa0]*Павле[\\s\\xa0]*до[\\s\\xa0]*христијаните[\\s\\xa0]*во[\\s\\xa0]*Рим|Римјаните|Римјани|Rom))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Cor"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏЀ-ҁ҃-҇Ҋ-ԧḀ-ỿⱠ-Ɀⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Втор[ао][\\s\\xa0]*(?:писмо[\\s\\xa0]*од[\\s\\xa0]*апостол[\\s\\xa0]*Павле[\\s\\xa0]*до[\\s\\xa0]*христијаните[\\s\\xa0]*во[\\s\\xa0]*Коринт|Корин(?:[кќ]аните|тјани))|(?:II|2)\\.[\\s\\xa0]*(?:писмо[\\s\\xa0]*од[\\s\\xa0]*апостол[\\s\\xa0]*Павле[\\s\\xa0]*до[\\s\\xa0]*христијаните[\\s\\xa0]*во[\\s\\xa0]*Коринт|Корин(?:[кќ]аните|тјани))|(?:II|2)[\\s\\xa0]*(?:писмо[\\s\\xa0]*од[\\s\\xa0]*апостол[\\s\\xa0]*Павле[\\s\\xa0]*до[\\s\\xa0]*христијаните[\\s\\xa0]*во[\\s\\xa0]*Коринт|Корин(?:[кќ]аните|тјани))|2Cor))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Cor"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏЀ-ҁ҃-҇Ҋ-ԧḀ-ỿⱠ-Ɀⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Прв[ао][\\s\\xa0]*(?:писмо[\\s\\xa0]*од[\\s\\xa0]*апостол[\\s\\xa0]*Павле[\\s\\xa0]*до[\\s\\xa0]*христијаните[\\s\\xa0]*во[\\s\\xa0]*Коринт|Корин(?:[кќ]аните|тјани))|[1I]\\.[\\s\\xa0]*(?:писмо[\\s\\xa0]*од[\\s\\xa0]*апостол[\\s\\xa0]*Павле[\\s\\xa0]*до[\\s\\xa0]*христијаните[\\s\\xa0]*во[\\s\\xa0]*Коринт|Корин(?:[кќ]аните|тјани))|[1I][\\s\\xa0]*(?:писмо[\\s\\xa0]*од[\\s\\xa0]*апостол[\\s\\xa0]*Павле[\\s\\xa0]*до[\\s\\xa0]*христијаните[\\s\\xa0]*во[\\s\\xa0]*Коринт|Корин(?:[кќ]аните|тјани))|1Cor))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Gal"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Писмо[\\s\\xa0]*од[\\s\\xa0]*апостол[\\s\\xa0]*Павле[\\s\\xa0]*до[\\s\\xa0]*христијаните[\\s\\xa0]*во[\\s\\xa0]*Галатија|Галат(?:јани|ите)|Gal))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Eph"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Писмо[\\s\\xa0]*од[\\s\\xa0]*апостол[\\s\\xa0]*Павле[\\s\\xa0]*до[\\s\\xa0]*христијаните[\\s\\xa0]*во[\\s\\xa0]*Ефес|Ефе(?:шаните|сјани)|Eph))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Phil"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Писмо[\\s\\xa0]*од[\\s\\xa0]*апостол[\\s\\xa0]*Павле[\\s\\xa0]*до[\\s\\xa0]*христијаните[\\s\\xa0]*во[\\s\\xa0]*Филипи|Филипјаните|Филипјани|Phil))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Col"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Писмо[\\s\\xa0]*од[\\s\\xa0]*апостол[\\s\\xa0]*Павле[\\s\\xa0]*до[\\s\\xa0]*христијаните[\\s\\xa0]*во[\\s\\xa0]*Колос|Коло(?:шаните|сјани)|Col))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Thess"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏЀ-ҁ҃-҇Ҋ-ԧḀ-ỿⱠ-Ɀⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Втор[ао][\\s\\xa0]*(?:писмо[\\s\\xa0]*од[\\s\\xa0]*апостол[\\s\\xa0]*Павле[\\s\\xa0]*до[\\s\\xa0]*христијаните[\\s\\xa0]*во[\\s\\xa0]*Солун|Солун(?:јани|ците))|(?:II|2)\\.[\\s\\xa0]*(?:писмо[\\s\\xa0]*од[\\s\\xa0]*апостол[\\s\\xa0]*Павле[\\s\\xa0]*до[\\s\\xa0]*христијаните[\\s\\xa0]*во[\\s\\xa0]*Солун|Солун(?:јани|ците))|(?:II|2)[\\s\\xa0]*(?:писмо[\\s\\xa0]*од[\\s\\xa0]*апостол[\\s\\xa0]*Павле[\\s\\xa0]*до[\\s\\xa0]*христијаните[\\s\\xa0]*во[\\s\\xa0]*Солун|Солун(?:јани|ците))|2Thess))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Thess"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏЀ-ҁ҃-҇Ҋ-ԧḀ-ỿⱠ-Ɀⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Прв[ао][\\s\\xa0]*(?:писмо[\\s\\xa0]*од[\\s\\xa0]*апостол[\\s\\xa0]*Павле[\\s\\xa0]*до[\\s\\xa0]*христијаните[\\s\\xa0]*во[\\s\\xa0]*Солун|Солун(?:јани|ците))|[1I]\\.[\\s\\xa0]*(?:писмо[\\s\\xa0]*од[\\s\\xa0]*апостол[\\s\\xa0]*Павле[\\s\\xa0]*до[\\s\\xa0]*христијаните[\\s\\xa0]*во[\\s\\xa0]*Солун|Солун(?:јани|ците))|[1I][\\s\\xa0]*(?:писмо[\\s\\xa0]*од[\\s\\xa0]*апостол[\\s\\xa0]*Павле[\\s\\xa0]*до[\\s\\xa0]*христијаните[\\s\\xa0]*во[\\s\\xa0]*Солун|Солун(?:јани|ците))|1Thess))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Tim"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏЀ-ҁ҃-҇Ҋ-ԧḀ-ỿⱠ-Ɀⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Втор[ао][\\s\\xa0]*(?:писмо[\\s\\xa0]*од[\\s\\xa0]*апостол[\\s\\xa0]*Павле[\\s\\xa0]*до[\\s\\xa0]*)?Тимотеј|(?:II|2)\\.[\\s\\xa0]*(?:писмо[\\s\\xa0]*од[\\s\\xa0]*апостол[\\s\\xa0]*Павле[\\s\\xa0]*до[\\s\\xa0]*)?Тимотеј|(?:II|2)[\\s\\xa0]*(?:писмо[\\s\\xa0]*од[\\s\\xa0]*апостол[\\s\\xa0]*Павле[\\s\\xa0]*до[\\s\\xa0]*)?Тимотеј|2Tim))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Tim"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏЀ-ҁ҃-҇Ҋ-ԧḀ-ỿⱠ-Ɀⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Прв[ао][\\s\\xa0]*(?:писмо[\\s\\xa0]*од[\\s\\xa0]*апостол[\\s\\xa0]*Павле[\\s\\xa0]*до[\\s\\xa0]*)?Тимотеј|[1I]\\.[\\s\\xa0]*(?:писмо[\\s\\xa0]*од[\\s\\xa0]*апостол[\\s\\xa0]*Павле[\\s\\xa0]*до[\\s\\xa0]*)?Тимотеј|[1I][\\s\\xa0]*(?:писмо[\\s\\xa0]*од[\\s\\xa0]*апостол[\\s\\xa0]*Павле[\\s\\xa0]*до[\\s\\xa0]*)?Тимотеј|1Tim))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Titus"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Писмо[\\s\\xa0]*од[\\s\\xa0]*апостол[\\s\\xa0]*Павле[\\s\\xa0]*до[\\s\\xa0]*Тит|Titus|Тит))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Phlm"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Писмо[\\s\\xa0]*од[\\s\\xa0]*апостол[\\s\\xa0]*Павле[\\s\\xa0]*до[\\s\\xa0]*Филемон|Фил[еи]мон|Phlm))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Heb"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Писмо[\\s\\xa0]*до[\\s\\xa0]*Евреите|Евреите|Евреи|Heb))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jas"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:П(?:ослание[\\s\\xa0]*на|исмо[\\s\\xa0]*од)[\\s\\xa0]*апостол[\\s\\xa0]*Јаков|Јаков|Jas))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Pet"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏЀ-ҁ҃-҇Ҋ-ԧḀ-ỿⱠ-Ɀⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Втор[ао][\\s\\xa0]*(?:п(?:ослание[\\s\\xa0]*на|исмо[\\s\\xa0]*од)[\\s\\xa0]*апостол[\\s\\xa0]*Петар|Пет(?:рово|ар))|(?:II|2)\\.[\\s\\xa0]*(?:п(?:ослание[\\s\\xa0]*на|исмо[\\s\\xa0]*од)[\\s\\xa0]*апостол[\\s\\xa0]*Петар|Пет(?:рово|ар))|(?:II|2)[\\s\\xa0]*(?:п(?:ослание[\\s\\xa0]*на|исмо[\\s\\xa0]*од)[\\s\\xa0]*апостол[\\s\\xa0]*Петар|Пет(?:рово|ар))|2Pet))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Pet"],
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏЀ-ҁ҃-҇Ҋ-ԧḀ-ỿⱠ-Ɀⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:Прв[ао][\\s\\xa0]*(?:п(?:ослание[\\s\\xa0]*на|исмо[\\s\\xa0]*од)[\\s\\xa0]*апостол[\\s\\xa0]*Петар|Пет(?:рово|ар))|[1I]\\.[\\s\\xa0]*(?:п(?:ослание[\\s\\xa0]*на|исмо[\\s\\xa0]*од)[\\s\\xa0]*апостол[\\s\\xa0]*Петар|Пет(?:рово|ар))|[1I][\\s\\xa0]*(?:п(?:ослание[\\s\\xa0]*на|исмо[\\s\\xa0]*од)[\\s\\xa0]*апостол[\\s\\xa0]*Петар|Пет(?:рово|ар))|1Pet))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jude"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:П(?:ослание[\\s\\xa0]*на|исмо[\\s\\xa0]*од)[\\s\\xa0]*апостол[\\s\\xa0]*Јуда|Jude|Јуда))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
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
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏЀ-ҁ҃-҇Ҋ-ԧḀ-ỿⱠ-Ɀⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:2Macc))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["3Macc"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏЀ-ҁ҃-҇Ҋ-ԧḀ-ỿⱠ-Ɀⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:3Macc))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["4Macc"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏЀ-ҁ҃-҇Ҋ-ԧḀ-ỿⱠ-Ɀⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:4Macc))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Macc"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏЀ-ҁ҃-҇Ҋ-ԧḀ-ỿⱠ-Ɀⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])((?:1Macc))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
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
