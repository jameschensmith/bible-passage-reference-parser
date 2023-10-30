bcv_parser::regexps.space = "[\\s\\xa0]"
bcv_parser::regexps.escaped_passage = ///
	(?:^ | [^\x1f\x1e\dA-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ] )	# Beginning of string or not in the middle of a word or immediately following another book. Only count a book if it's part of a sequence: `Matt5John3` is OK, but not `1Matt5John3`
		(
			# Start inverted book/chapter (cb)
			(?:
				  (?: ch (?: apters? | a?pts?\.? | a?p?s?\.? )? \s*
					\d+ \s* (?: [\u2013\u2014\-] | through | thru | to) \s* \d+ \s*
					(?: from | of | in ) (?: \s+ the \s+ book \s+ of )?\s* )
				| (?: ch (?: apters? | a?pts?\.? | a?p?s?\.? )? \s*
					\d+ \s*
					(?: from | of | in ) (?: \s+ the \s+ book \s+ of )?\s* )
				| (?: \d+ (?: th | nd | st ) \s*
					ch (?: apter | a?pt\.? | a?p?\.? )? \s* #no plurals here since it's a single chapter
					(?: from | of | in ) (?: \s+ the \s+ book \s+ of )? \s* )
			)? # End inverted book/chapter (cb)
			\x1f(\d+)(?:/\d+)?\x1f		#book
				(?:
				    /\d+\x1f				#special Psalm chapters
				  | [\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014]
				  | (?:subt[íi]tulo|t[íi]tulo|tít) (?! [a-z] )		#could be followed by a number
				  | y#{bcv_parser::regexps.space}+siguientes | y(?!#{bcv_parser::regexps.space}+sig) | y#{bcv_parser::regexps.space}+sig | vers[íi]culos | cap[íi]tulos | vers[íi]culo | cap[íi]tulo | caps | vers | cap | ver | vss | vs | vv | á | v
				  | [a-e] (?! \w )			#a-e allows 1:1a
				  | $						#or the end of the string
				 )+
		)
	///gi
# These are the only valid ways to end a potential passage match. The closing parenthesis allows for fully capturing parentheses surrounding translations (ESV**)**. The last one, `[\d\x1f]` needs not to be +; otherwise `Gen5ff` becomes `\x1f0\x1f5ff`, and `adjust_regexp_end` matches the `\x1f5` and incorrectly dangles the ff.
bcv_parser::regexps.match_end_split = ///
	  \d \W* (?:subt[íi]tulo|t[íi]tulo|tít)
	| \d \W* (?:y#{bcv_parser::regexps.space}+siguientes|y#{bcv_parser::regexps.space}+sig) (?: [\s\xa0*]* \.)?
	| \d [\s\xa0*]* [a-e] (?! \w )
	| \x1e (?: [\s\xa0*]* [)\]\uff09] )? #ff09 is a full-width closing parenthesis
	| [\d\x1f]
	///gi
bcv_parser::regexps.control = /[\x1e\x1f]/g
bcv_parser::regexps.pre_book = "[^A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ]"

bcv_parser::regexps.first = "(?:1\.?[ºo]|1|I|Primero?)\\.?#{bcv_parser::regexps.space}*"
bcv_parser::regexps.second = "(?:2\.?[ºo]|2|II|Segundo)\\.?#{bcv_parser::regexps.space}*"
bcv_parser::regexps.third = "(?:3\.?[ºo]|3|III|Tercero?)\\.?#{bcv_parser::regexps.space}*"
bcv_parser::regexps.range_and = "(?:[&\u2013\u2014-]|y(?!#{bcv_parser::regexps.space}+sig)|á)"
bcv_parser::regexps.range_only = "(?:[\u2013\u2014-]|á)"
# Each book regexp should return two parenthesized objects: an optional preliminary character and the book itself.
bcv_parser::regexps.get_books = (include_apocrypha, case_sensitive) ->
	books = [
		osis: ["Ps"]
		apocrypha: true
		extra: "2"
		regexp: ///(\b)( # Don't match a preceding \d like usual because we only want to match a valid OSIS, which will never have a preceding digit.
			Ps151
			# Always follwed by ".1"; the regular Psalms parser can handle `Ps151` on its own.
			)(?=\.1)///g # Case-sensitive because we only want to match a valid OSIS.
	,
		osis: ["Gen"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:G(?:[e\xE9](?:n(?:esis)?)?|n))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Exod"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:[E\xC9]x(?:o(?:do?)?|d)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Bel"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Bel(?:[\s\xa0]*y[\s\xa0]*el[\s\xa0]*(?:Serpiente|Drag[o\xF3]n))?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Lev"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:L(?:ev(?:[i\xED]tico)?|v))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Num"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:N(?:[u\xFA](?:m(?:eros)?)?|m))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Sir"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ec(?:lesi[a\xE1]stico|clus)|Si(?:r(?:[a\xE1]cides|[a\xE1]cida)|r(?:[a\xE1]c)?)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Wis"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:S(?:ab(?:idur[i\xED]a)?|b)|Wis)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Lam"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:L(?:a(?:m(?:[ei]ntaciones?)?)?|m))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["EpJer"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:La[\s\xa0]*Carta[\s\xa0]*de[\s\xa0]*Jerem[i\xED]as|Carta[\s\xa0]*de[\s\xa0]*Jerem[i\xED]as|Carta[\s\xa0]*Jerem[i\xED]as|(?:Carta[\s\xa0]*|Ep)Jer)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Rev"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:El[\s\xa0]*Apocalipsis|Apocalipsis|Ap(?:oc)?|Rev)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["PrMan"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:La[\s\xa0]*Oraci[o\xF3]n[\s\xa0]*de[\s\xa0]*Manas[e\xE9]s|Oraci[o\xF3]n[\s\xa0]*de[\s\xa0]*Manas[e\xE9]s|(?:Or\.?[\s\xa0]*|Pr)Man)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Deut"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:D(?:ueteronomio|eu(?:t(?:[eo]rono?mio|rono?mio)?)?|t))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Josh"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Jos(?:u[e\xE9]|h)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Judg"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:J(?:u(?:e(?:c(?:es)?)?|dg)|c))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Ruth"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:R(?:u(?:th?)?|t))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Esd"]
		apocrypha: true
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Primero?[\s\xa0]*Esdras|(?:1(?:\.[o\xBA]|[o\xBA])|I)\.[\s\xa0]*Esdras|(?:1(?:\.[o\xBA]?|[o\xBA])|I)[\s\xa0]*Esdras|1(?:[\s\xa0]*Esdras|[\s\xa0]*Esdr?|Esd))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Esd"]
		apocrypha: true
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Segundo[\s\xa0]*Esdras|(?:2(?:\.[o\xBA]|[o\xBA])|II)\.[\s\xa0]*Esdras|(?:2(?:\.[o\xBA]?|[o\xBA])|II)[\s\xa0]*Esdras|2(?:[\s\xa0]*Esdras|[\s\xa0]*Esdr?|Esd))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Isa"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Is(?:a(?:[i\xED]as)?)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Sam"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:2[\s\xa0]*Sm)|(?:Segundo[\s\xa0]*Samuel|(?:2(?:\.[o\xBA]|[o\xBA])|II)\.[\s\xa0]*Samuel|(?:2(?:\.[o\xBA]?|[o\xBA])|II)[\s\xa0]*Samuel|2(?:[\s\xa0]*Samuel|[\s\xa0]*S(?:am?)?|Sam))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Sam"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:1[\s\xa0]*Sm)|(?:Primero?[\s\xa0]*Samuel|(?:1(?:\.[o\xBA]|[o\xBA])|I)\.[\s\xa0]*Samuel|(?:1(?:\.[o\xBA]?|[o\xBA])|I)[\s\xa0]*Samuel|1(?:[\s\xa0]*Samuel|[\s\xa0]*S(?:am?)?|Sam))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Kgs"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Segundo[\s\xa0]*Reyes|(?:2(?:\.[o\xBA]|[o\xBA])|II)\.[\s\xa0]*Reyes|(?:2(?:\.[o\xBA]?|[o\xBA])|II)[\s\xa0]*Reyes|2(?:[\s\xa0]*R(?:(?:e(?:ye?|e)?|ye?)?s|e(?:ye?|e)?|ye?)?|Kgs))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Kgs"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Primero?[\s\xa0]*Reyes|(?:1(?:\.[o\xBA]|[o\xBA])|I)\.[\s\xa0]*Reyes|(?:1(?:\.[o\xBA]?|[o\xBA])|I)[\s\xa0]*Reyes|1(?:[\s\xa0]*R(?:(?:e(?:ye?|e)?|ye?)?s|e(?:ye?|e)?|ye?)?|Kgs))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Chr"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Segundo[\s\xa0]*Cr[o\xF3]nicas|(?:2(?:\.[o\xBA]|[o\xBA])|II)\.[\s\xa0]*Cr[o\xF3]nicas|(?:2(?:\.[o\xBA]?|[o\xBA])|II)[\s\xa0]*Cr[o\xF3]nicas|2(?:[\s\xa0]*Cr[o\xF3]nicas|[\s\xa0]*Cr(?:[o\xF3]n?)?|Chr))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Chr"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Primer(?:o[\s\xa0]*Cr[o\xF3]|[\s\xa0]*Cr[o\xF3])nicas|(?:1(?:\.[o\xBA]|[o\xBA])|I)\.[\s\xa0]*Cr[o\xF3]nicas|(?:1(?:\.[o\xBA]?|[o\xBA])|I)[\s\xa0]*Cr[o\xF3]nicas|1(?:[\s\xa0]*Cr[o\xF3]nicas|[\s\xa0]*Cr(?:[o\xF3]n?)?|Chr))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Ezra"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:E(?:sd(?:r(?:as)?)?|zra))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Neh"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ne(?:h(?:em[i\xED]as)?)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["GkEsth"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Est(?:er[\s\xa0]*(?:\([Gg]riego\)|[Gg]riego)|[\s\xa0]*Gr)|GkEsth)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Esth"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Es(?:t(?:er|h)?)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Job"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Jo?b)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Ps"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:S(?:al(?:m(?:os?)?)?|lm?)|Ps)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["PrAzar"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Oraci[o\xF3]n[\s\xa0]*de[\s\xa0]*Azar[i\xED]as|C[a\xE1]ntico[\s\xa0]*de[\s\xa0]*Azar[i\xED]as|(?:Or[\s\xa0]*|Pr)Azar|Azar[i\xED]as|Or[\s\xa0]*Az)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Prov"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Provebios)|(?:P(?:r(?:o(?:bv?erbios|verbios|v(?:erbio)?)?|(?:e?verbio|vbo?)s|e?verbio|vbo|vb?)?|or?verbios|v))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Eccl"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ec(?:c(?:l(?:es(?:i(?:a(?:st(?:i(?:c[e\xE9]|[e\xE9])s|[e\xE9]s|[e\xE9])|t(?:[e\xE9]s|[e\xE9]))|i(?:s?t[e\xE9]s|s?t[e\xE9]))|(?:s[ai][ai]|a[ai])s?t[e\xE9]s|(?:s[ai][ai]|a[ai])s?t[e\xE9])?)?)?|l(?:es(?:i(?:a(?:st(?:i(?:c[e\xE9]|[e\xE9])s|[e\xE9]s|[e\xE9])|t(?:[e\xE9]s|[e\xE9]))|i(?:s?t[e\xE9]s|s?t[e\xE9]))|(?:s[ai][ai]|a[ai])s?t[e\xE9]s|(?:s[ai][ai]|a[ai])s?t[e\xE9])?)?)?|Qo)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["SgThree"]
		apocrypha: true
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:El[\s\xa0]*(?:Himno[\s\xa0]*de[\s\xa0]*los[\s\xa0]*(?:Tres[\s\xa0]*J[o\xF3]venes[\s\xa0]*(?:Hebre|Jud[i\xED])|3[\s\xa0]*J[o\xF3]venes[\s\xa0]*(?:Hebre|Jud[i\xED]))|Canto[\s\xa0]*de[\s\xa0]*los[\s\xa0]*(?:Tres[\s\xa0]*J[o\xF3]venes[\s\xa0]*(?:Hebre|Jud[i\xED])|3[\s\xa0]*J[o\xF3]venes[\s\xa0]*(?:Hebre|Jud[i\xED])))os|SgThree|Ct[\s\xa0]*3[\s\xa0]*J[o\xF3])|(?:Canto[\s\xa0]*de[\s\xa0]*los[\s\xa0]*(?:Tres[\s\xa0]*J[o\xF3]venes(?:[\s\xa0]*(?:Hebre|Jud[i\xED])os)?|3[\s\xa0]*J[o\xF3]venes(?:[\s\xa0]*(?:Hebre|Jud[i\xED])os)?)|(?:Himno[\s\xa0]*de[\s\xa0]*los[\s\xa0]*Tres[\s\xa0]*J[o\xF3]venes[\s\xa0]*Jud[i\xED]o|(?:Himno[\s\xa0]*de[\s\xa0]*los[\s\xa0]*Tres[\s\xa0]*J[o\xF3]|Tres[\s\xa0]*J[o\xF3]|3[\s\xa0]*J[o\xF3])vene)s|Himno[\s\xa0]*de[\s\xa0]*los[\s\xa0]*3[\s\xa0]*J[o\xF3]venes(?:[\s\xa0]*(?:Hebre|Jud[i\xED])os)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Song"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:El[\s\xa0]*Cantar[\s\xa0]*de[\s\xa0]*los[\s\xa0]*Cantares|Cantare?[\s\xa0]*de[\s\xa0]*los[\s\xa0]*Cantares|C(?:antares|n?t)|Cant?|Song)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Jer"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:J(?:er(?:e(?:m[i\xED]as?)?)?|r))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Ezek"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ez(?:i[ei]qui?el|e(?:[ei]qui?el|qu(?:i[ae]|e)l|qu?|k)?|iqui?el|q)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Dan"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:D(?:a(?:n(?:iel)?)?|[ln]))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Hos"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Os(?:eas)?|Hos)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Joel"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:J(?:oel?|l))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Amos"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Am(?:[o\xF3]s?|s)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Obad"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ab(?:d(?:[i\xED]as)?)?|Obad)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Jonah"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:J(?:on(?:\xE1s|a[hs])?|ns))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Mic"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:M(?:i(?:q(?:ueas)?|c)?|q))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Nah"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:N(?:a(?:h(?:[u\xFA]m?)?)?|h))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Hab"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Hab(?:bac[au]c|ac[au]c|c)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Zeph"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:S(?:o(?:f(?:on[i\xED]as)?)?|f)|Zeph)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Hag"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:H(?:ag(?:geo|eo)?|g)|Ag(?:eo)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Zech"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Z(?:a(?:c(?:ar(?:[i\xED]as)?)?)?|ech))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Mal"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:M(?:al(?:a(?:qu(?:[i\xED]as)?)?)?|l))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Matt"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:E(?:l[\s\xa0]*E)?vangelio[\s\xa0]*de[\s\xa0]*Mateo|San[\s\xa0]*Mateo|M(?:ateo|(?:at|a)?t))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Macc"]
		apocrypha: true
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:2[\s\xa0]*Mc)|(?:Segundo[\s\xa0]*Mac(?:cab(?:be(?:eos?|os?)|e(?:eos?|os?))|ab(?:be(?:eos?|os?)|e(?:eos?|os?)))|(?:2(?:\.[o\xBA]|[o\xBA])|II)\.[\s\xa0]*Mac(?:cab(?:be(?:eos?|os?)|e(?:eos?|os?))|ab(?:be(?:eos?|os?)|e(?:eos?|os?)))|(?:2(?:\.[o\xBA]?|[o\xBA])|II)[\s\xa0]*Mac(?:cab(?:be(?:eos?|os?)|e(?:eos?|os?))|ab(?:be(?:eos?|os?)|e(?:eos?|os?)))|2(?:[\s\xa0]*Macc?ab(?:be(?:eos?|os?)|e(?:eos?|os?))|[\s\xa0]*M(?:acc?)?|Macc))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["3Macc"]
		apocrypha: true
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:3[\s\xa0]*Mc)|(?:Tercer(?:o[\s\xa0]*Mac(?:cab(?:be(?:eos?|os?)|e(?:eos?|os?))|ab(?:be(?:eos?|os?)|e(?:eos?|os?)))|[\s\xa0]*Mac(?:cab(?:be(?:eos?|os?)|e(?:eos?|os?))|ab(?:be(?:eos?|os?)|e(?:eos?|os?))))|(?:III|3(?:\.[o\xBA]|[o\xBA]))\.[\s\xa0]*Mac(?:cab(?:be(?:eos?|os?)|e(?:eos?|os?))|ab(?:be(?:eos?|os?)|e(?:eos?|os?)))|(?:III|3(?:\.[o\xBA]?|[o\xBA]))[\s\xa0]*Mac(?:cab(?:be(?:eos?|os?)|e(?:eos?|os?))|ab(?:be(?:eos?|os?)|e(?:eos?|os?)))|3(?:[\s\xa0]*Macc?ab(?:be(?:eos?|os?)|e(?:eos?|os?))|[\s\xa0]*M(?:acc?)?|Macc))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["4Macc"]
		apocrypha: true
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:4[\s\xa0]*Mc)|(?:Cuarto[\s\xa0]*Mac(?:cab(?:be(?:eos?|os?)|e(?:eos?|os?))|ab(?:be(?:eos?|os?)|e(?:eos?|os?)))|(?:4(?:\.[o\xBA]|[o\xBA])|IV)\.[\s\xa0]*Mac(?:cab(?:be(?:eos?|os?)|e(?:eos?|os?))|ab(?:be(?:eos?|os?)|e(?:eos?|os?)))|(?:4(?:\.[o\xBA]?|[o\xBA])|IV)[\s\xa0]*Mac(?:cab(?:be(?:eos?|os?)|e(?:eos?|os?))|ab(?:be(?:eos?|os?)|e(?:eos?|os?)))|4(?:[\s\xa0]*Macc?ab(?:be(?:eos?|os?)|e(?:eos?|os?))|[\s\xa0]*M(?:acc?)?|Macc))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Macc"]
		apocrypha: true
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:1[\s\xa0]*Mc)|(?:Primer(?:o[\s\xa0]*Mac(?:cab(?:be(?:eos?|os?)|e(?:eos?|os?))|ab(?:be(?:eos?|os?)|e(?:eos?|os?)))|[\s\xa0]*Mac(?:cab(?:be(?:eos?|os?)|e(?:eos?|os?))|ab(?:be(?:eos?|os?)|e(?:eos?|os?))))|(?:1(?:\.[o\xBA]|[o\xBA])|I)\.[\s\xa0]*Mac(?:cab(?:be(?:eos?|os?)|e(?:eos?|os?))|ab(?:be(?:eos?|os?)|e(?:eos?|os?)))|(?:1(?:\.[o\xBA]?|[o\xBA])|I)[\s\xa0]*Mac(?:cab(?:be(?:eos?|os?)|e(?:eos?|os?))|ab(?:be(?:eos?|os?)|e(?:eos?|os?)))|1(?:[\s\xa0]*Macc?ab(?:be(?:eos?|os?)|e(?:eos?|os?))|[\s\xa0]*M(?:acc?)?|Macc))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Mark"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Mark)|(?:E(?:l[\s\xa0]*E)?vangelio[\s\xa0]*de[\s\xa0]*Marcos|San[\s\xa0]*Marcos|M(?:a?rcos|arc?|rc?|c))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Luke"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:E(?:l[\s\xa0]*E)?vangelio[\s\xa0]*de[\s\xa0]*Lucas|San[\s\xa0]*Lucas|L(?:ucas|uke|uc?|c))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1John"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:(?:Primer(?:o[\s\xa0]*(?:San[\s\xa0]*J[au][au]|J[au][au])|[\s\xa0]*(?:San[\s\xa0]*J[au][au]|J[au][au]))|(?:1(?:\.[o\xBA]|[o\xBA])|I)\.[\s\xa0]*(?:San[\s\xa0]*J[au][au]|J[au][au])|(?:1(?:\.[o\xBA]?|[o\xBA])|I)[\s\xa0]*(?:San[\s\xa0]*J[au][au]|J[au][au])|1(?:[\s\xa0]*San[\s\xa0]*J[au][au]|[\s\xa0]*J[au][au]|Joh|[\s\xa0]*J))n)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2John"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:(?:Segundo[\s\xa0]*(?:San[\s\xa0]*J[au][au]|J[au][au])|(?:2(?:\.[o\xBA]|[o\xBA])|II)\.[\s\xa0]*(?:San[\s\xa0]*J[au][au]|J[au][au])|(?:2(?:\.[o\xBA]?|[o\xBA])|II)[\s\xa0]*(?:San[\s\xa0]*J[au][au]|J[au][au])|2(?:[\s\xa0]*San[\s\xa0]*J[au][au]|[\s\xa0]*J[au][au]|Joh|[\s\xa0]*J))n)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["3John"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:(?:Tercer(?:o[\s\xa0]*(?:San[\s\xa0]*J[au][au]|J[au][au])|[\s\xa0]*(?:San[\s\xa0]*J[au][au]|J[au][au]))|(?:III|3(?:\.[o\xBA]|[o\xBA]))\.[\s\xa0]*(?:San[\s\xa0]*J[au][au]|J[au][au])|(?:III|3(?:\.[o\xBA]?|[o\xBA]))[\s\xa0]*(?:San[\s\xa0]*J[au][au]|J[au][au])|3(?:[\s\xa0]*San[\s\xa0]*J[au][au]|[\s\xa0]*J[au][au]|Joh|[\s\xa0]*J))n)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["John"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:(?:El[\s\xa0]*Evangelio[\s\xa0]*de[\s\xa0]*J[au][au]|San[\s\xa0]*Jua|Joh|J[au][au]|J)n)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Acts"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Los[\s\xa0]*Hechos(?:[\s\xa0]*de[\s\xa0]*los[\s\xa0]*Ap[o\xF3]stoles)?|Hechos(?:[\s\xa0]*de[\s\xa0]*los[\s\xa0]*Ap[o\xF3]stoles)?|H(?:ech?|ch|c)|Acts)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Rom"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:R(?:o(?:m(?:anos?|s)?|s)?|m(?:ns?|s)?))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Cor"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:2[\s\xa0]*Corini)|(?:Segundo[\s\xa0]*Corintios|(?:2(?:\.[o\xBA]|[o\xBA])|II)\.[\s\xa0]*Corintios|(?:2(?:\.[o\xBA]?|[o\xBA])|II)[\s\xa0]*Corintios|2(?:[\s\xa0]*Corintios|[\s\xa0]*Co(?:r(?:in(?:ti?)?)?)?|Cor))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Cor"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:1[\s\xa0]*Corini)|(?:Primero?[\s\xa0]*Corintios|(?:1(?:\.[o\xBA]|[o\xBA])|I)\.[\s\xa0]*Corintios|(?:1(?:\.[o\xBA]?|[o\xBA])|I)[\s\xa0]*Corintios|1(?:[\s\xa0]*Corintios|[\s\xa0]*Co(?:r(?:in(?:ti?)?)?)?|Cor))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Gal"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:G[a\xE1](?:l(?:at(?:as)?)?)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Eph"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:E(?:f(?:es(?:ios)?)?|ph))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Phil"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:F(?:il(?:i(?:p(?:enses)?)?)?|lp)|Phil)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Col"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Col(?:os(?:enses)?)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Thess"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Segundo[\s\xa0]*Tesaloni[cs]enses?|(?:2(?:\.[o\xBA]|[o\xBA])|II)\.[\s\xa0]*Tesaloni[cs]enses?|(?:2(?:\.[o\xBA]?|[o\xBA])|II)[\s\xa0]*Tesaloni[cs]enses?|2(?:[\s\xa0]*Tesaloni[cs]enses?|(?:[\s\xa0]*T(?:hes)?|Thes|[\s\xa0]*Te)s))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Thess"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Primer(?:o[\s\xa0]*Tesaloni[cs]enses?|[\s\xa0]*Tesaloni[cs]enses?)|(?:1(?:\.[o\xBA]|[o\xBA])|I)\.[\s\xa0]*Tesaloni[cs]enses?|(?:1(?:\.[o\xBA]?|[o\xBA])|I)[\s\xa0]*Tesaloni[cs]enses?|1(?:[\s\xa0]*Tesaloni[cs]enses?|(?:[\s\xa0]*T(?:hes)?|Thes|[\s\xa0]*Te)s))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Tim"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Segundo[\s\xa0]*Timoteo|(?:2(?:\.[o\xBA]|[o\xBA])|II)\.[\s\xa0]*Timoteo|(?:2(?:\.[o\xBA]?|[o\xBA])|II)[\s\xa0]*Timoteo|2(?:[\s\xa0]*Timoteo|[\s\xa0]*Tim?|(?:Ti|[\s\xa0]*T)m))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Tim"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Primero?[\s\xa0]*Timoteo|(?:1(?:\.[o\xBA]|[o\xBA])|I)\.[\s\xa0]*Timoteo|(?:1(?:\.[o\xBA]?|[o\xBA])|I)[\s\xa0]*Timoteo|1(?:[\s\xa0]*Timoteo|[\s\xa0]*Tim?|(?:Ti|[\s\xa0]*T)m))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Titus"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:T(?:i(?:t(?:us|o)?)?|t))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Phlm"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:F(?:ilem(?:[o\xF3]n)?|lmn?|mn)|Phlm)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Heb"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:He(?:b(?:r(?:eo?)?s|re[er]s|r[or][eor]?s|[eo](?:[eor][eor]?)?s|r(?:eo)?)?)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Jas"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:S(?:ant(?:iago)?|tg?)|Jas)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Pet"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:2(?:Pet|[\s\xa0]*Pd))|(?:Segundo[\s\xa0]*(?:San[\s\xa0]*)?Pedro|(?:2(?:\.[o\xBA]|[o\xBA])|II)\.[\s\xa0]*(?:San[\s\xa0]*)?Pedro|(?:2(?:\.[o\xBA]?|[o\xBA])|II)[\s\xa0]*(?:San[\s\xa0]*)?Pedro|2[\s\xa0]*(?:San[\s\xa0]*Pedro|P(?:edro|ed?)?))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Pet"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:1(?:Pet|[\s\xa0]*Pd))|(?:Primer(?:o[\s\xa0]*(?:San[\s\xa0]*)?|[\s\xa0]*(?:San[\s\xa0]*)?)Pedro|(?:1(?:\.[o\xBA]|[o\xBA])|I)\.[\s\xa0]*(?:San[\s\xa0]*)?Pedro|(?:1(?:\.[o\xBA]?|[o\xBA])|I)[\s\xa0]*(?:San[\s\xa0]*)?Pedro|1[\s\xa0]*(?:San[\s\xa0]*Pedro|P(?:edro|ed?)?))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Jude"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:San[\s\xa0]*Judas|J(?:u?das|ude|u?d))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Tob"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:T(?:ob(?:it?|t)?|b))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Jdt"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:J(?:udi?|di?)t)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Bar"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ba(?:r(?:uc)?)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Sus"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Sus(?:ana)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Hab", "Hag"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ha)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Heb", "Hab"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Hb)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Jonah", "Job", "Josh", "Joel"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Jo)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Jude", "Judg"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ju)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Matt", "Mark", "Mal"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ma)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Phil", "Phlm"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Fil)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	]
	# Short-circuit the look if we know we want all the books.
	return books if include_apocrypha is true and case_sensitive is "none"
	# Filter out books in the Apocrypha if we don't want them. `Array.map` isn't supported below IE9.
	out = []
	for book in books
		continue if include_apocrypha is false and book.apocrypha? and book.apocrypha is true
		if case_sensitive is "books"
			book.regexp = new RegExp book.regexp.source, "g"
		out.push book
	out

# Default to not using the Apocrypha
bcv_parser::regexps.books = bcv_parser::regexps.get_books false, "none"
