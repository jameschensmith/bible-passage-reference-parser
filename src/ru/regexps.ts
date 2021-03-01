/* eslint-disable */
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
(?:^|[^\\x1f\\x1e\\dA-Za-zЀ-ҁ҃-҇Ҋ-ԧⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟ])\
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
|надписаниях(?![a-z])\
|и${bcv_parser.prototype.regexps.space}+далее|главы|стихи|глав|стих|гл|—|и\
|[аб](?!\\w)\
|$\
)+\
)`, "gi");
// These are the only valid ways to end a potential passage match. The closing parenthesis allows for fully capturing parentheses surrounding translations (ESV**)**. The last one, `[\d\x1f]` needs not to be +; otherwise `Gen5ff` becomes `\x1f0\x1f5ff`, and `adjust_regexp_end` matches the `\x1f5` and incorrectly dangles the ff.
// 'ff09' is a full-width closing parenthesis.
bcv_parser.prototype.regexps.match_end_split = new RegExp(`\
\\d\\W*надписаниях\
|\\d\\W*и${bcv_parser.prototype.regexps.space}+далее(?:[\\s\\xa0*]*\\.)?\
|\\d[\\s\\xa0*]*[аб](?!\\w)\
|\\x1e(?:[\\s\\xa0*]*[)\\]\\uff09])?\
|[\\d\\x1f]`, "gi");
bcv_parser.prototype.regexps.control = /[\x1e\x1f]/g;
bcv_parser.prototype.regexps.pre_book = "[^A-Za-zЀ-ҁ҃-҇Ҋ-ԧⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟ]";

bcv_parser.prototype.regexps.first = `(?:1-?я|1-?е|1)\\.?${bcv_parser.prototype.regexps.space}*`;
bcv_parser.prototype.regexps.second = `(?:2-?я|2-?е|2)\\.?${bcv_parser.prototype.regexps.space}*`;
bcv_parser.prototype.regexps.third = `(?:3-?я|3-?е|3)\\.?${bcv_parser.prototype.regexps.space}*`;
bcv_parser.prototype.regexps.range_and = `(?:[&\u2013\u2014-]|и|—)`;
bcv_parser.prototype.regexps.range_only = "(?:[\u2013\u2014-]|—)";
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
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Книга[\\s\\xa0]*Бытия|Начало|Бытие|Быт|Нач|Gen))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Exod"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Книга[\\s\\xa0]*Исход|Исход|Exod|Исх))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Bel"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Виле[\\s\\xa0]*и[\\s\\xa0]*драконе|Бел(?:[\\s\\xa0]*и[\\s\\xa0]*Дракон|е)|Бел|Bel))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Lev"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Книга[\\s\\xa0]*Левит|Левит|Лев|Lev))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Num"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Книга[\\s\\xa0]*Чисел|Числа|Чис|Num))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Sir"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Премудрост(?:и[\\s\\xa0]*Иисуса,[\\s\\xa0]*сына[\\s\\xa0]*Сирахов|ь[\\s\\xa0]*Сирах)а|Ekkleziastik|Сирахова|Сир|Sir))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Wis"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Прем(?:удрости[\\s\\xa0]*Соломона)?|Wis))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Lam"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Плач(?:[\\s\\xa0]*Иеремии)?|Lam))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["EpJer"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Послание[\\s\\xa0]*Иеремии|EpJer))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Rev"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Отк(?:р(?:овение)?)?|Rev))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["PrMan"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Молитва[\\s\\xa0]*Манассии|PrMan))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Deut"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Втор(?:озаконие)?|Deut))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Josh"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Книга[\\s\\xa0]*Иисуса[\\s\\xa0]*Навина|Иисуса[\\s\\xa0]*Навина|Иисус[\\s\\xa0]*Навин|Навин|Иешуа|Josh|Нав|Иеш))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Judg"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Книга[\\s\\xa0]*Суде[ий](?:[\\s\\xa0]*Израилевых)?|Суд(?:ьи|е[ий])|Judg|Суд))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Ruth"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Книга[\\s\\xa0]*Руфи|Ру(?:фь|т)|Ruth|Руф))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Esd"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zЀ-ҁ҃-҇Ҋ-ԧⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟ])((?:2(?:\\-?[ея]\\.?[\\s\\xa0]*Ездры|[ея]\\.?[\\s\\xa0]*Ездры|\\.[\\s\\xa0]*Ездры|[\\s\\xa0]*Езд(?:ры)?)|1Esd))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Esd"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zЀ-ҁ҃-҇Ҋ-ԧⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟ])((?:3(?:\\-?[ея]\\.?[\\s\\xa0]*Ездры|[ея]\\.?[\\s\\xa0]*Ездры|\\.[\\s\\xa0]*Ездры|[\\s\\xa0]*Езд(?:ры)?)|2Esd))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Isa"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Книга[\\s\\xa0]*пророка[\\s\\xa0]*Исаии|Исаи[ия]|Ис(?:аи)?|Isa))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Sam"],
			regexp: new RegExp(`(^|[^0-9A-Za-zЀ-ҁ҃-҇Ҋ-ԧⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟ])((?:2(?:\\-?[ея](?:\\.[\\s\\xa0]*(?:Книга[\\s\\xa0]*Царств|Самуила|Царств)|[\\s\\xa0]*(?:Книга[\\s\\xa0]*Царств|Самуила|Царств))|[ея](?:\\.[\\s\\xa0]*(?:Книга[\\s\\xa0]*Царств|Самуила|Царств)|[\\s\\xa0]*(?:Книга[\\s\\xa0]*Царств|Самуила|Царств))|\\.[\\s\\xa0]*(?:Книга[\\s\\xa0]*Царств|Самуила|Царств)|[\\s\\xa0]*Книга[\\s\\xa0]*Царств|[\\s\\xa0]*Самуила|[\\s\\xa0]*Царств|[\\s\\xa0]*Цар|Sam)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Sam"],
			regexp: new RegExp(`(^|[^0-9A-Za-zЀ-ҁ҃-҇Ҋ-ԧⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟ])((?:1(?:\\-?[ея](?:\\.[\\s\\xa0]*(?:Книга[\\s\\xa0]*Царств|Самуила|Царств)|[\\s\\xa0]*(?:Книга[\\s\\xa0]*Царств|Самуила|Царств))|[ея](?:\\.[\\s\\xa0]*(?:Книга[\\s\\xa0]*Царств|Самуила|Царств)|[\\s\\xa0]*(?:Книга[\\s\\xa0]*Царств|Самуила|Царств))|\\.[\\s\\xa0]*(?:Книга[\\s\\xa0]*Царств|Самуила|Царств)|[\\s\\xa0]*Книга[\\s\\xa0]*Царств|[\\s\\xa0]*Самуила|[\\s\\xa0]*Царств|[\\s\\xa0]*Цар|Sam)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Kgs"],
			regexp: new RegExp(`(^|[^0-9A-Za-zЀ-ҁ҃-҇Ҋ-ԧⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟ])((?:4(?:\\-?[ея](?:\\.[\\s\\xa0]*(?:Книга[\\s\\xa0]*)?|[\\s\\xa0]*(?:Книга[\\s\\xa0]*)?)Царств|[ея](?:\\.[\\s\\xa0]*(?:Книга[\\s\\xa0]*)?|[\\s\\xa0]*(?:Книга[\\s\\xa0]*)?)Царств|\\.[\\s\\xa0]*(?:Книга[\\s\\xa0]*)?Царств|[\\s\\xa0]*(?:Книга[\\s\\xa0]*Царств|Цар(?:ств)?))|2(?:\\-?[ея](?:\\.[\\s\\xa0]*Царе[ий]|[\\s\\xa0]*Царе[ий])|[ея](?:\\.[\\s\\xa0]*Царе[ий]|[\\s\\xa0]*Царе[ий])|\\.[\\s\\xa0]*Царе[ий]|[\\s\\xa0]*Царе[ий]|Kgs)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Kgs"],
			regexp: new RegExp(`(^|[^0-9A-Za-zЀ-ҁ҃-҇Ҋ-ԧⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟ])((?:3(?:\\-?[ея](?:\\.[\\s\\xa0]*(?:Книга[\\s\\xa0]*)?|[\\s\\xa0]*(?:Книга[\\s\\xa0]*)?)Царств|[ея](?:\\.[\\s\\xa0]*(?:Книга[\\s\\xa0]*)?|[\\s\\xa0]*(?:Книга[\\s\\xa0]*)?)Царств|\\.[\\s\\xa0]*(?:Книга[\\s\\xa0]*)?Царств|[\\s\\xa0]*(?:Книга[\\s\\xa0]*Царств|Цар(?:ств)?))|1(?:\\-?[ея](?:\\.[\\s\\xa0]*Царе[ий]|[\\s\\xa0]*Царе[ий])|[ея](?:\\.[\\s\\xa0]*Царе[ий]|[\\s\\xa0]*Царе[ий])|\\.[\\s\\xa0]*Царе[ий]|[\\s\\xa0]*Царе[ий]|Kgs)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Chr"],
			regexp: new RegExp(`(^|[^0-9A-Za-zЀ-ҁ҃-҇Ҋ-ԧⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟ])((?:2(?:\\-?[ея](?:\\.[\\s\\xa0]*(?:Книга[\\s\\xa0]*Паралипоменон|Паралипоменон|Летопись|Хроник)|[\\s\\xa0]*(?:Книга[\\s\\xa0]*Паралипоменон|Паралипоменон|Летопись|Хроник))|[ея](?:\\.[\\s\\xa0]*(?:Книга[\\s\\xa0]*Паралипоменон|Паралипоменон|Летопись|Хроник)|[\\s\\xa0]*(?:Книга[\\s\\xa0]*Паралипоменон|Паралипоменон|Летопись|Хроник))|\\.[\\s\\xa0]*(?:Книга[\\s\\xa0]*Паралипоменон|Паралипоменон|Летопись|Хроник)|[\\s\\xa0]*Книга[\\s\\xa0]*Паралипоменон|[\\s\\xa0]*Паралипоменон|[\\s\\xa0]*Летопись|[\\s\\xa0]*Хроник|[\\s\\xa0]*(?:Лет|Пар)|Chr)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Chr"],
			regexp: new RegExp(`(^|[^0-9A-Za-zЀ-ҁ҃-҇Ҋ-ԧⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟ])((?:1(?:\\-?[ея](?:\\.[\\s\\xa0]*(?:Книга[\\s\\xa0]*Паралипоменон|Паралипоменон|Летопись|Хроник)|[\\s\\xa0]*(?:Книга[\\s\\xa0]*Паралипоменон|Паралипоменон|Летопись|Хроник))|[ея](?:\\.[\\s\\xa0]*(?:Книга[\\s\\xa0]*Паралипоменон|Паралипоменон|Летопись|Хроник)|[\\s\\xa0]*(?:Книга[\\s\\xa0]*Паралипоменон|Паралипоменон|Летопись|Хроник))|\\.[\\s\\xa0]*(?:Книга[\\s\\xa0]*Паралипоменон|Паралипоменон|Летопись|Хроник)|[\\s\\xa0]*Книга[\\s\\xa0]*Паралипоменон|[\\s\\xa0]*Паралипоменон|[\\s\\xa0]*Летопись|[\\s\\xa0]*Хроник|[\\s\\xa0]*(?:Лет|Пар)|Chr)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Ezra"],
			regexp: new RegExp(`(^|[^0-9A-Za-zЀ-ҁ҃-҇Ҋ-ԧⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟ])((?:Первая[\\s\\xa0]*Ездры|Книга[\\s\\xa0]*Ездры|Уза[ий]р|Ездр[аы]|1[\\s\\xa0]*Езд|Ezra|Езд))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Neh"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Книга[\\s\\xa0]*Неемии|Нееми[ия]|Неем|Neh))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["GkEsth"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Дополнения[\\s\\xa0]*к[\\s\\xa0]*Есфири|GkEsth))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Esth"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Книга[\\s\\xa0]*Есфири|Есфирь|Esth|Есф))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Job"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Книга[\\s\\xa0]*Иова|Иова|Иов|Аюб|Job))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Ps"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Пс(?:ал(?:тирь|ом|мы)?)?|Забур|Заб|Ps))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["PrAzar"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Молитва[\\s\\xa0]*Азария|PrAzar))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Prov"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Книга[\\s\\xa0]*притче[ий][\\s\\xa0]*Соломоновых|Мудрые[\\s\\xa0]*изречения|Притчи|Пр(?:ит)?|Мудр|Prov))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Eccl"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Книга[\\s\\xa0]*Екклесиаста|Размышления|Екклесиаст|Разм|Eccl|Екк))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["SgThree"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Благодарственная[\\s\\xa0]*песнь[\\s\\xa0]*отроков|(?:Молитва[\\s\\xa0]*святых[\\s\\xa0]*тре|Песнь[\\s\\xa0]*тр[её])х[\\s\\xa0]*отроков|SgThree))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Song"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Песн(?:ь(?:[\\s\\xa0]*(?:песне[ий][\\s\\xa0]*Соломо|Сул(?:е[ий]ма|а[ий]мо))на)?|и[\\s\\xa0]*Песне[ий])?|Song))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jer"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Книга[\\s\\xa0]*пророка[\\s\\xa0]*Иеремии|Иереми[ия]|Иер|Jer))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Ezek"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Книга[\\s\\xa0]*пророка[\\s\\xa0]*Иезекииля|Иезекиил[ья]|Езекиил|Езек|Ezek|Иез))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Dan"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Книга[\\s\\xa0]*пророка[\\s\\xa0]*Даниила|Д(?:ани(?:ила|ял)|они[её]л)|Д(?:ан(?:иил)?|он)|Dan))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Hos"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Книга[\\s\\xa0]*пророка[\\s\\xa0]*Осии|Оси[ия]|Hos|Ос))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Joel"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Книга[\\s\\xa0]*пророка[\\s\\xa0]*Иоиля|Иоил[ья]|Иоил|Joel))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Amos"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Книга[\\s\\xa0]*пророка[\\s\\xa0]*Амоса|Амоса|Ам(?:ос)?|Amos))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Obad"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Книга[\\s\\xa0]*пророка[\\s\\xa0]*Авдия|Авди[ийя]|Obad|Авд))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jonah"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Книга[\\s\\xa0]*пророка[\\s\\xa0]*Ионы|Jonah|Юнус|Ион[аы]))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Mic"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Книга[\\s\\xa0]*пророка[\\s\\xa0]*Михея|Михе[ийя]|Мих|Mic))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Nah"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Книга[\\s\\xa0]*пророка[\\s\\xa0]*Наума|Наума|Наум|Nah))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Hab"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Книга[\\s\\xa0]*пророка[\\s\\xa0]*Аввакума|Аввакума|Авв(?:акум)?|Hab))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Zeph"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Книга[\\s\\xa0]*пророка[\\s\\xa0]*Софонии|Софони[ия]|Zeph|Соф))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Hag"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Книга[\\s\\xa0]*пророка[\\s\\xa0]*Аггея|Агге[ийя]|Агг|Hag))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Zech"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Книга[\\s\\xa0]*пророка[\\s\\xa0]*Захарии|За(?:хари[ия]|кария)|Zech|За[кх]))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Mal"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Книга[\\s\\xa0]*пророка[\\s\\xa0]*Малахии|Малахи[ия]|Мал|Mal))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Matt"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Евангелие[\\s\\xa0]*от[\\s\\xa0]*Матфея|От[\\s\\xa0]*Матфея|Матфея|М(?:ат(?:то|а[ий])|[тф])|Matt|Мат))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Mark"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Евангелие[\\s\\xa0]*от[\\s\\xa0]*Марка|От[\\s\\xa0]*Марка|М(?:арка|[кр])|Марк|Mark))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Luke"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Евангелие[\\s\\xa0]*от[\\s\\xa0]*Луки|От[\\s\\xa0]*Луки|Л(?:ук[аио]|к)|Luke))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1John"],
			regexp: new RegExp(`(^|[^0-9A-Za-zЀ-ҁ҃-҇Ҋ-ԧⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟ])((?:1(?:\\-?[ея](?:\\.[\\s\\xa0]*(?:послание[\\s\\xa0]*Иоан|Ио(?:ха|ан))|[\\s\\xa0]*(?:послание[\\s\\xa0]*Иоан|Ио(?:ха|ан)))на|[ея](?:\\.[\\s\\xa0]*(?:послание[\\s\\xa0]*Иоан|Ио(?:ха|ан))|[\\s\\xa0]*(?:послание[\\s\\xa0]*Иоан|Ио(?:ха|ан)))на|\\.[\\s\\xa0]*(?:послание[\\s\\xa0]*Иоан|Ио(?:ха|ан))на|[\\s\\xa0]*послание[\\s\\xa0]*Иоанна|[\\s\\xa0]*Иохана|[\\s\\xa0]*Иоанна|John|[\\s\\xa0]*Ин)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2John"],
			regexp: new RegExp(`(^|[^0-9A-Za-zЀ-ҁ҃-҇Ҋ-ԧⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟ])((?:2(?:\\-?[ея](?:\\.[\\s\\xa0]*(?:послание[\\s\\xa0]*Иоан|Ио(?:ха|ан))|[\\s\\xa0]*(?:послание[\\s\\xa0]*Иоан|Ио(?:ха|ан)))на|[ея](?:\\.[\\s\\xa0]*(?:послание[\\s\\xa0]*Иоан|Ио(?:ха|ан))|[\\s\\xa0]*(?:послание[\\s\\xa0]*Иоан|Ио(?:ха|ан)))на|\\.[\\s\\xa0]*(?:послание[\\s\\xa0]*Иоан|Ио(?:ха|ан))на|[\\s\\xa0]*послание[\\s\\xa0]*Иоанна|[\\s\\xa0]*Иохана|[\\s\\xa0]*Иоанна|John|[\\s\\xa0]*Ин)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["3John"],
			regexp: new RegExp(`(^|[^0-9A-Za-zЀ-ҁ҃-҇Ҋ-ԧⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟ])((?:3(?:\\-?[ея](?:\\.[\\s\\xa0]*(?:послание[\\s\\xa0]*Иоан|Ио(?:ха|ан))|[\\s\\xa0]*(?:послание[\\s\\xa0]*Иоан|Ио(?:ха|ан)))на|[ея](?:\\.[\\s\\xa0]*(?:послание[\\s\\xa0]*Иоан|Ио(?:ха|ан))|[\\s\\xa0]*(?:послание[\\s\\xa0]*Иоан|Ио(?:ха|ан)))на|\\.[\\s\\xa0]*(?:послание[\\s\\xa0]*Иоан|Ио(?:ха|ан))на|[\\s\\xa0]*послание[\\s\\xa0]*Иоанна|[\\s\\xa0]*Иохана|[\\s\\xa0]*Иоанна|John|[\\s\\xa0]*Ин)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["John"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Евангелие[\\s\\xa0]*от[\\s\\xa0]*Иоанна|От[\\s\\xa0]*Иоанна|Иоанна|И(?:оха)?н|John))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Acts"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Деян(?:ия)?|Acts))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Rom"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Послание[\\s\\xa0]*к[\\s\\xa0]*Римлянам|К[\\s\\xa0]*Римлянам|Римлянам|Рим|Rom))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Cor"],
			regexp: new RegExp(`(^|[^0-9A-Za-zЀ-ҁ҃-҇Ҋ-ԧⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟ])((?:2(?:\\-?[ея](?:\\.[\\s\\xa0]*(?:к[\\s\\xa0]*)?|[\\s\\xa0]*(?:к[\\s\\xa0]*)?)Коринфянам|[ея](?:\\.[\\s\\xa0]*(?:к[\\s\\xa0]*)?|[\\s\\xa0]*(?:к[\\s\\xa0]*)?)Коринфянам|\\.[\\s\\xa0]*(?:к[\\s\\xa0]*)?Коринфянам|[\\s\\xa0]*к[\\s\\xa0]*Коринфянам|[\\s\\xa0]*Коринфянам|[\\s\\xa0]*Кор|Cor)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Cor"],
			regexp: new RegExp(`(^|[^0-9A-Za-zЀ-ҁ҃-҇Ҋ-ԧⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟ])((?:1(?:\\-?[ея](?:\\.[\\s\\xa0]*(?:к[\\s\\xa0]*)?|[\\s\\xa0]*(?:к[\\s\\xa0]*)?)Коринфянам|[ея](?:\\.[\\s\\xa0]*(?:к[\\s\\xa0]*)?|[\\s\\xa0]*(?:к[\\s\\xa0]*)?)Коринфянам|\\.[\\s\\xa0]*(?:к[\\s\\xa0]*)?Коринфянам|[\\s\\xa0]*к[\\s\\xa0]*Коринфянам|[\\s\\xa0]*Коринфянам|[\\s\\xa0]*Кор|Cor)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Gal"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Послание[\\s\\xa0]*к[\\s\\xa0]*Галатам|К[\\s\\xa0]*Галатам|Галатам|Гал|Gal))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Eph"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Послание[\\s\\xa0]*к[\\s\\xa0]*Ефесянам|К[\\s\\xa0]*Ефесянам|[ЕЭ]фесянам|Eph|[ЕЭ]ф))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Phil"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Послание[\\s\\xa0]*к[\\s\\xa0]*Филиппи[ий]цам|К[\\s\\xa0]*Филиппи[ий]цам|Филиппи[ий]цам|Phil|Фил|Флп))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Col"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Послание[\\s\\xa0]*к[\\s\\xa0]*Колоссянам|К[\\s\\xa0]*Колоссянам|Колоссянам|Кол|Col))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Thess"],
			regexp: new RegExp(`(^|[^0-9A-Za-zЀ-ҁ҃-҇Ҋ-ԧⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟ])((?:2(?:\\-?[ея](?:\\.[\\s\\xa0]*(?:к[\\s\\xa0]*Фессалоники[ий]|Фессалоники[ий])|[\\s\\xa0]*(?:к[\\s\\xa0]*Фессалоники[ий]|Фессалоники[ий]))цам|[ея](?:\\.[\\s\\xa0]*(?:к[\\s\\xa0]*Фессалоники[ий]|Фессалоники[ий])|[\\s\\xa0]*(?:к[\\s\\xa0]*Фессалоники[ий]|Фессалоники[ий]))цам|\\.[\\s\\xa0]*(?:к[\\s\\xa0]*Фессалоники[ий]|Фессалоники[ий])цам|[\\s\\xa0]*к[\\s\\xa0]*Фессалоники[ий]цам|[\\s\\xa0]*Фессалоники[ий]цам|Thess|[\\s\\xa0]*Фес)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Thess"],
			regexp: new RegExp(`(^|[^0-9A-Za-zЀ-ҁ҃-҇Ҋ-ԧⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟ])((?:1(?:\\-?[ея](?:\\.[\\s\\xa0]*(?:к[\\s\\xa0]*Фессалоники[ий]|Фессалоники[ий])|[\\s\\xa0]*(?:к[\\s\\xa0]*Фессалоники[ий]|Фессалоники[ий]))цам|[ея](?:\\.[\\s\\xa0]*(?:к[\\s\\xa0]*Фессалоники[ий]|Фессалоники[ий])|[\\s\\xa0]*(?:к[\\s\\xa0]*Фессалоники[ий]|Фессалоники[ий]))цам|\\.[\\s\\xa0]*(?:к[\\s\\xa0]*Фессалоники[ий]|Фессалоники[ий])цам|[\\s\\xa0]*к[\\s\\xa0]*Фессалоники[ий]цам|[\\s\\xa0]*Фессалоники[ий]цам|Thess|[\\s\\xa0]*Фес)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Tim"],
			regexp: new RegExp(`(^|[^0-9A-Za-zЀ-ҁ҃-҇Ҋ-ԧⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟ])((?:2(?:\\-?[ея](?:\\.[\\s\\xa0]*(?:к[\\s\\xa0]*Тимоф|Тим(?:ет|оф))|[\\s\\xa0]*(?:к[\\s\\xa0]*Тимоф|Тим(?:ет|оф)))ею|[ея](?:\\.[\\s\\xa0]*(?:к[\\s\\xa0]*Тимоф|Тим(?:ет|оф))|[\\s\\xa0]*(?:к[\\s\\xa0]*Тимоф|Тим(?:ет|оф)))ею|\\.[\\s\\xa0]*(?:к[\\s\\xa0]*Тимоф|Тим(?:ет|оф))ею|[\\s\\xa0]*к[\\s\\xa0]*Тимофею|[\\s\\xa0]*Тиметею|[\\s\\xa0]*Тимофею|[\\s\\xa0]*Тим|Tim)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Tim"],
			regexp: new RegExp(`(^|[^0-9A-Za-zЀ-ҁ҃-҇Ҋ-ԧⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟ])((?:1(?:\\-?[ея](?:\\.[\\s\\xa0]*(?:к[\\s\\xa0]*Тимоф|Тим(?:ет|оф))|[\\s\\xa0]*(?:к[\\s\\xa0]*Тимоф|Тим(?:ет|оф)))ею|[ея](?:\\.[\\s\\xa0]*(?:к[\\s\\xa0]*Тимоф|Тим(?:ет|оф))|[\\s\\xa0]*(?:к[\\s\\xa0]*Тимоф|Тим(?:ет|оф)))ею|\\.[\\s\\xa0]*(?:к[\\s\\xa0]*Тимоф|Тим(?:ет|оф))ею|[\\s\\xa0]*к[\\s\\xa0]*Тимофею|[\\s\\xa0]*Тиметею|[\\s\\xa0]*Тимофею|[\\s\\xa0]*Тим|Tim)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Titus"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Послание[\\s\\xa0]*к[\\s\\xa0]*Титу|К[\\s\\xa0]*Титу|Titus|Титу|Тит))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Phlm"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Послание[\\s\\xa0]*к[\\s\\xa0]*Филимону|К[\\s\\xa0]*Филимону|Филимону|Phlm|Флм))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Heb"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Послание[\\s\\xa0]*к[\\s\\xa0]*Евреям|К[\\s\\xa0]*Евреям|Евреям|Евр|Heb))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jas"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Послание[\\s\\xa0]*Иакова|Иакова|Якуб|Иак|Jas))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Pet"],
			regexp: new RegExp(`(^|[^0-9A-Za-zЀ-ҁ҃-҇Ҋ-ԧⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟ])((?:2(?:\\-?[ея](?:\\.[\\s\\xa0]*(?:послание[\\s\\xa0]*Петр|Пет(?:р(?:ус)?|ир))|[\\s\\xa0]*(?:послание[\\s\\xa0]*Петр|Пет(?:р(?:ус)?|ир)))а|[ея](?:\\.[\\s\\xa0]*(?:послание[\\s\\xa0]*Петр|Пет(?:р(?:ус)?|ир))|[\\s\\xa0]*(?:послание[\\s\\xa0]*Петр|Пет(?:р(?:ус)?|ир)))а|\\.[\\s\\xa0]*(?:послание[\\s\\xa0]*Петр|Пет(?:р(?:ус)?|ир))а|[\\s\\xa0]*послание[\\s\\xa0]*Петра|[\\s\\xa0]*Петруса|[\\s\\xa0]*Петира|[\\s\\xa0]*Петра|[\\s\\xa0]*Пет|Pet)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Pet"],
			regexp: new RegExp(`(^|[^0-9A-Za-zЀ-ҁ҃-҇Ҋ-ԧⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟ])((?:1(?:\\-?[ея](?:\\.[\\s\\xa0]*(?:послание[\\s\\xa0]*Петр|Пет(?:р(?:ус)?|ир))|[\\s\\xa0]*(?:послание[\\s\\xa0]*Петр|Пет(?:р(?:ус)?|ир)))а|[ея](?:\\.[\\s\\xa0]*(?:послание[\\s\\xa0]*Петр|Пет(?:р(?:ус)?|ир))|[\\s\\xa0]*(?:послание[\\s\\xa0]*Петр|Пет(?:р(?:ус)?|ир)))а|\\.[\\s\\xa0]*(?:послание[\\s\\xa0]*Петр|Пет(?:р(?:ус)?|ир))а|[\\s\\xa0]*послание[\\s\\xa0]*Петра|[\\s\\xa0]*Петруса|[\\s\\xa0]*Петира|[\\s\\xa0]*Петра|[\\s\\xa0]*Пет|Pet)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jude"],
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Послание[\\s\\xa0]*Иуды|Иуд[аы]|Jude|Иуд))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Tob"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Тов(?:ита)?|Tob))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Jdt"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Юди(?:фь)?|Jdt))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Bar"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:Книга[\\s\\xa0]*(?:пророка[\\s\\xa0]*Вару́|Вару)ха|Бару́ха|Варуха|Вар|Bar))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["Sus"],
			apocrypha: true,
			regexp: new RegExp(`(^|${bcv_parser.prototype.regexps.pre_book})((?:С(?:казанию[\\s\\xa0]*о[\\s\\xa0]*Сусанне[\\s\\xa0]*и[\\s\\xa0]*Данииле|усанна(?:[\\s\\xa0]*и[\\s\\xa0]*старцы)?)|Sus))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["2Macc"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zЀ-ҁ҃-҇Ҋ-ԧⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟ])((?:Вторая[\\s\\xa0]*книга[\\s\\xa0]*Маккаве[ий]ская|2(?:\\-?[ея]\\.?[\\s\\xa0]*Маккавеев|[ея]\\.?[\\s\\xa0]*Маккавеев|\\.[\\s\\xa0]*Маккавеев|[\\s\\xa0]*Маккавеев|[\\s\\xa0]*Макк|Macc)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["3Macc"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zЀ-ҁ҃-҇Ҋ-ԧⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟ])((?:Третья[\\s\\xa0]*книга[\\s\\xa0]*Маккаве[ий]ская|3(?:\\-?[ея]\\.?[\\s\\xa0]*Маккавеев|[ея]\\.?[\\s\\xa0]*Маккавеев|\\.[\\s\\xa0]*Маккавеев|[\\s\\xa0]*Маккавеев|[\\s\\xa0]*Макк|Macc)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["4Macc"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zЀ-ҁ҃-҇Ҋ-ԧⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟ])((?:4(?:\\-?[ея]\\.?[\\s\\xa0]*Маккавеев|[ея]\\.?[\\s\\xa0]*Маккавеев|\\.[\\s\\xa0]*Маккавеев|[\\s\\xa0]*Маккавеев|[\\s\\xa0]*Макк|Macc)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
		},
		{
			osis: ["1Macc"],
			apocrypha: true,
			regexp: new RegExp(`(^|[^0-9A-Za-zЀ-ҁ҃-҇Ҋ-ԧⷠ-ⷿꙀ-꙯ꙴ-꙽ꙿ-ꚗꚟ])((?:Первая[\\s\\xa0]*книга[\\s\\xa0]*Маккаве[ий]ская|1(?:\\-?[ея]\\.?[\\s\\xa0]*Маккавеев|[ея]\\.?[\\s\\xa0]*Маккавеев|\\.[\\s\\xa0]*Маккавеев|[\\s\\xa0]*Маккавеев|[\\s\\xa0]*Макк|Macc)))(?:(?=[\\d\\s\\xa0.:,;\\x1e\\x1f&\\(\\)\\uff08\\uff09\\[\\]/"'\\*=~\\-\\u2013\\u2014])|$)`, "gi")
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
