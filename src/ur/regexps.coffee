bcv_parser::regexps.space = "[\\s\\xa0]"
bcv_parser::regexps.escaped_passage = ///
	(?:^ | [^\x1f\x1e\dA-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ] )	# Beginning of string or not in the middle of a word or immediately following another book. Only count a book if it's part of a sequence: `Matt5John3` is OK, but not `1Matt5John3`
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
				  | title (?! [a-z] )		#could be followed by a number
				  | ابواب | آیات | باب | آیت | ff | تا | ، | ؛ | ۔
				  | [a-e] (?! \w )			#a-e allows 1:1a
				  | $						#or the end of the string
				 )+
		)
	///gi
# These are the only valid ways to end a potential passage match. The closing parenthesis allows for fully capturing parentheses surrounding translations (ESV**)**. The last one, `[\d\x1f]` needs not to be +; otherwise `Gen5ff` becomes `\x1f0\x1f5ff`, and `adjust_regexp_end` matches the `\x1f5` and incorrectly dangles the ff.
bcv_parser::regexps.match_end_split = ///
	  \d \W* title
	| \d \W* ff (?: [\s\xa0*]* \.)?
	| \d [\s\xa0*]* [a-e] (?! \w )
	| \x1e (?: [\s\xa0*]* [)\]\uff09] )? #ff09 is a full-width closing parenthesis
	| [\d\x1f]
	///gi
bcv_parser::regexps.control = /[\x1e\x1f]/g
bcv_parser::regexps.pre_book = "[^A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ]"

bcv_parser::regexps.first = "(?:اوّل|[۱1]|1)\\.?#{bcv_parser::regexps.space}*"
bcv_parser::regexps.second = "(?:دوم|[۲2]|2)\\.?#{bcv_parser::regexps.space}*"
bcv_parser::regexps.third = "(?:تیسرا|[۳3]|3)\\.?#{bcv_parser::regexps.space}*"
bcv_parser::regexps.range_and = "(?:[&\u2013\u2014-]|(?:،|؛|۔)|تا)"
bcv_parser::regexps.range_only = "(?:[\u2013\u2014-]|تا)"
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
		(?:پ(?:َیدای|یدا[ئی]|يدائ)ش|pīdāyiš|Gen)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Exod"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:خ(?:ُرُ|ر)وج|ḫurūj|Exod)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Bel"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Bel)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Lev"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:احبار|iḥbār|Lev)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Num"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:گِ?نتی|gintī|Num)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Sir"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Sir)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Wis"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Wis)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Lam"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:نَ?وحہ|nūḥ\xE2|Lam)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["EpJer"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:EpJer)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Rev"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ی(?:ُو(?:[\s\xa0]*حنّا[\s\xa0]*عارِف[\s\xa0]*کا[\s\xa0]*مُ|حنا[\s\xa0]*عارف[\s\xa0]*کا[\s\xa0]*م)|و[\s\xa0]*حنا[\s\xa0]*عارف[\s\xa0]*کا[\s\xa0]*م)کاشفہ|yūḥannā[\s\xa0]*ʿārif[\s\xa0]*kā[\s\xa0]*mukāšaf\xE2|مُکاشفہ|مکاشفہ|Rev)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["PrMan"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:PrMan)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Deut"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ا(?:ِستِثنا|ستثناء)|istis̱nā|استثنا|Deut)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Josh"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:یشُ?وع|yašūʿ|Josh)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Judg"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ق(?:ُضاۃ|ضا[ةہۃ])|qużāh|Judg)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Ruth"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:رُ?وت|Ruth|rūt)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Esd"]
		apocrypha: true
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])(
		(?:1Esd)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Esd"]
		apocrypha: true
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])(
		(?:2Esd)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Isa"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:yasaʿyāh|ی(?:عس|سع)یاہ|Isa)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Sam"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])(
		(?:دوم(?:۔سموا|[\s\xa0\x2D]*سموئ)یل|2(?:[\s\xa0]*samūʾīl|۔سموایل|[\s\xa0]*سموئیل|\-?سموئیل|Sam)|(?:2\.|۲)(?:۔سموا|[\s\xa0\x2D]*سموئ)یل)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Sam"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])(
		(?:اوّل(?:(?:۔سموا|\-?سموئ)ی|[\s\xa0]*سموئ[يی])ل|1(?:[\s\xa0]*samūʾīl|(?:۔سموا|\-?سموئ)یل|[\s\xa0]*سموئ[يی]ل|Sam)|(?:1\.|۱)(?:(?:۔سموا|\-?سموئ)ی|[\s\xa0]*سموئ[يی])ل)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Kgs"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])(
		(?:دوم(?:\-?سلاطِ|[\s\xa0۔]*سلاط)ین|(?:2\.|۲)(?:\-?سلاطِ|[\s\xa0۔]*سلاط)ین|2(?:[\s\xa0]*salāṭīn|\-?سلاطِین|[\s\xa0۔]*سلاطین|Kgs))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Kgs"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])(
		(?:اوّل(?:\-?سلاطِ|[\s\xa0۔]*سلاط)ین|(?:1\.|۱)(?:\-?سلاطِ|[\s\xa0۔]*سلاط)ین|1(?:[\s\xa0]*salāṭīn|\-?سلاطِین|[\s\xa0۔]*سلاطین|Kgs))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Chr"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])(
		(?:دوم(?:\-?[\s\xa0]*توارِ|(?:[\s\xa0]*تو[\s\xa0]*|۔تو)ار)یخ|(?:2\.|۲)(?:\-?[\s\xa0]*توارِ|(?:[\s\xa0]*تو[\s\xa0]*|۔تو)ار)یخ|2(?:\-?[\s\xa0]*توارِیخ|[\s\xa0]*tavārīḫ|(?:[\s\xa0]*تو[\s\xa0]*|۔تو)اریخ|Chr))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Chr"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])(
		(?:اوّل(?:\-?توارِ|[\s\xa0۔]*توار)یخ|(?:1\.|۱)(?:\-?توارِ|[\s\xa0۔]*توار)یخ|1(?:[\s\xa0]*tavārīḫ|\-?توارِیخ|[\s\xa0۔]*تواریخ|Chr))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Ezra"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:عز[\s\xa0]*?را|ʿizrā|Ezra)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Neh"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:niḥimyāh|نحمیاہ|Neh)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["GkEsth"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:GkEsth)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Esth"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ایستر|āstar|Esth|آستر)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Job"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ای(?:ُّ|ّ)?وب|(?:ayyū|Jo)b)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Ps"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:زبُ?ور|zabūr|زبُو|Ps)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["PrAzar"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:PrAzar)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Prov"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:اَ?مثال|ams̱āl|Prov)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Eccl"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:واعِ?ظ|vāʿẓ|Eccl)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["SgThree"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:SgThree)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Song"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ġazalu[\s\xa0]*l\-?ġazalāt|غزلُ?[\s\xa0]*الغزلات|Song)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Jer"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:yirmayāh|یرمِ?یاہ|Jer)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Ezek"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ḥiziqīʾīl|ح(?:ِزقی[\s\xa0]*|زقی[\s\xa0‌]*)ایل|Ezek)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Dan"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:دانی(?:[\s\xa0‌]*ای|ا)ل|dānīʾīl|Dan)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Hos"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ہو(?:[\s\xa0]*سیعاہ|سیع(?:َِ)?)|hūsīʿ|Hos)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Joel"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:یُ?وایل|(?:yōʾī|Joe)l)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Amos"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:عامُ?وس|(?:ʿāmō|Amo)s)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Obad"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ʿabadiyāh|عبدیاہ|Obad)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Jonah"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ی(?:ُوناہ|ونس)|yūnas|Jonah)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Mic"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:مِ?یکاہ|mīkāh|Mic)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Nah"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:نا(?:[\s\xa0]*حُ|حُ?)وم|nāḥūm|Nah)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Hab"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ḥabaqqūq|حبق(?:ُّ|ّ)?وق|Hab)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Zeph"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ṣafaniyāh|صفنیاہ|Zeph)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Hag"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ḥajjai|حج(?:َّی|يّ|ی)|Hag)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Zech"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:zakariyāh|زکریاہ?|Zech)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Mal"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:malākī|ملاکی|Mal)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Matt"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:mattī[\s\xa0]*kī[\s\xa0]*injīl|متّ?ی[\s\xa0]*کی[\s\xa0]*انجیل|متّ?ی|Matt)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Mark"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:marqus[\s\xa0]*kī[\s\xa0]*injīl|مرقُ?س[\s\xa0]*کی[\s\xa0]*انجیل|مرقس|Mark)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Luke"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ل(?:ُوقا(?:[\s\xa0]*کی[\s\xa0]*انجیل)?|وقا(?:[\s\xa0]*کی[\s\xa0]*انجیل)?)|lūqā[\s\xa0]*kī[\s\xa0]*injīl|Luke)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2John"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])(
		(?:yūḥannā[\s\xa0]*kā[\s\xa0]*dūsrā[\s\xa0]*ʿām[\s\xa0]*ḫaṭ|ی(?:ُوحنّا[\s\xa0]*کا[\s\xa0]*دوسرا[\s\xa0]*عام|وحن(?:ا[\s\xa0]*کا[\s\xa0]*دوسرا[\s\xa0]*عام|ّا[\s\xa0]*کا[\s\xa0]*دوسرا))[\s\xa0]*خط|دوم(?:\-?یُوحنّ|[\s\xa0]*یُ?وحنّ|۔یوحن)ا|(?:2\.|۲)(?:\-?یُوحنّ|[\s\xa0]*یُ?وحنّ|۔یوحن)ا|2(?:\-?یُوحنّا|[\s\xa0]*یُ?وحنّا|۔یوحنا|John))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["3John"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])(
		(?:yūḥannā[\s\xa0]*kā[\s\xa0]*tīsrā[\s\xa0]*ʿām[\s\xa0]*ḫaṭ|ی(?:ُوحنّا[\s\xa0]*کا[\s\xa0]*تیسرا[\s\xa0]*عام|وحن(?:ا[\s\xa0]*کا[\s\xa0]*تیسرا[\s\xa0]*عام|ّا[\s\xa0]*کا[\s\xa0]*(?:تیسرا|3\.|3|۳)))[\s\xa0]*خط|تیسرا(?:\-?یُوحنّ|[\s\xa0]*یُ?وحنّ|۔یوحن)ا|(?:3\.|۳)(?:\-?یُوحنّ|[\s\xa0]*یُ?وحنّ|۔یوحن)ا|3(?:\-?یُوحنّا|[\s\xa0]*یُ?وحنّا|۔یوحنا|John))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1John"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])(
		(?:yūḥannā[\s\xa0]*kā[\s\xa0]*pahlā[\s\xa0]*ʿām[\s\xa0]*ḫaṭ|ی(?:ُوحنّ|وحنّ?)ا[\s\xa0]*کا[\s\xa0]*پہلا[\s\xa0]*عام[\s\xa0]*خط|اوّل(?:\-?یُوحنّ|[\s\xa0]*یُ?وحنّ|۔یوحن)ا|(?:1\.|۱)(?:\-?یُوحنّ|[\s\xa0]*یُ?وحنّ|۔یوحن)ا|1(?:\-?یُوحنّا|[\s\xa0]*یُ?وحنّا|۔یوحنا|John))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["John"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ی(?:ُوحنّ|وحن)ا[\s\xa0]*کی[\s\xa0]*انجیل|yūḥannā[\s\xa0]*kī[\s\xa0]*injīl|ی(?:ُوحنّ|وحن)ا|John)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Acts"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:رسُ?ولوں[\s\xa0]*کے[\s\xa0]*اعمال|rasūlōṅ[\s\xa0]*ke[\s\xa0]*aʿmāl|یوحنا[\s\xa0]*کے[\s\xa0]*اعمال|رسولوں|اَعمال|اعمال|Acts)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Rom"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ر(?:ومیوں(?:[\s\xa0]*کے[\s\xa0]*نام[\s\xa0]*(?:پولس[\s\xa0]*رسول[\s\xa0]*)?کا[\s\xa0]*خط)?|ُومِیوں)|rōmiyōṅ[\s\xa0]*ke[\s\xa0]*nām[\s\xa0]*kā[\s\xa0]*ḫaṭ|Rom)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Cor"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])(
		(?:ک(?:رنتھ(?:ِیُوں[\s\xa0]*کے[\s\xa0]*نام[\s\xa0]*پولس[\s\xa0]*رسول|یوں[\s\xa0]*کے[\s\xa0]*نام)|ُرِنتھِیوں[\s\xa0]*کے[\s\xa0]*نام)[\s\xa0]*کا[\s\xa0]*دوسرا[\s\xa0]*خط|kurintʰiyōṅ[\s\xa0]*ke[\s\xa0]*nām[\s\xa0]*kā[\s\xa0]*dūsrā[\s\xa0]*ḫaṭ|دوم(?:\-?کُرِنتھِی|[\s\xa0]*کرنتھ(?:ِیُ|ی)|[\s\xa0]*کُرنتھِی|۔کرنتھی)وں|(?:2\.|۲)(?:\-?کُرِنتھِی|[\s\xa0]*کرنتھ(?:ِیُ|ی)|[\s\xa0]*کُرنتھِی|۔کرنتھی)وں|2(?:\-?کُرِنتھِیوں|[\s\xa0]*کرنتھ(?:ِیُ|ی)وں|[\s\xa0]*کُرنتھِیوں|۔کرنتھیوں|Cor))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Cor"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])(
		(?:ک(?:رنتھ(?:ِیُوں[\s\xa0]*کے[\s\xa0]*نام[\s\xa0]*پولس[\s\xa0]*رسول|یوں[\s\xa0]*کے[\s\xa0]*نام)|ُرِنتھِیوں[\s\xa0]*کے[\s\xa0]*نام)[\s\xa0]*کا[\s\xa0]*پہلا[\s\xa0]*خط|kurintʰiyōṅ[\s\xa0]*ke[\s\xa0]*nām[\s\xa0]*kā[\s\xa0]*pahlā[\s\xa0]*ḫaṭ|اوّل(?:\-?کُرِنتھِی|[\s\xa0]*کرنتھِیُ|[\s\xa0]*کُرنتھِی|۔کرنتھی)وں|(?:1\.|۱)(?:\-?کُرِنتھِی|[\s\xa0]*کرنتھِیُ|[\s\xa0]*کُرنتھِی|۔کرنتھی)وں|1(?:\-?کُرِنتھِیوں|[\s\xa0]*کرنتھِیُوں|[\s\xa0]*کُرنتھِیوں|۔کرنتھیوں|Cor))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Gal"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:گلت(?:یوں(?:[\s\xa0]*کے[\s\xa0]*نام[\s\xa0]*(?:پولُس[\s\xa0]*رسول[\s\xa0]*)?کا[\s\xa0]*خط)?|ِیوں(?:[\s\xa0]*کے[\s\xa0]*نام[\s\xa0]*کا[\s\xa0]*خط)?)|galatiyōṅ[\s\xa0]*ke[\s\xa0]*nām[\s\xa0]*kā[\s\xa0]*ḫaṭ|Gal)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Eph"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ا(?:فسیوں(?:[\s\xa0]*کے[\s\xa0]*نام[\s\xa0]*(?:پو[\s\xa0]*لس[\s\xa0]*رسول[\s\xa0]*)?کا[\s\xa0]*خط)?|ِف(?:ِسِیوں[\s\xa0]*کے[\s\xa0]*نام[\s\xa0]*کا[\s\xa0]*خط|سِ?یوں))|ifisiyōṅ[\s\xa0]*ke[\s\xa0]*nām[\s\xa0]*kā[\s\xa0]*ḫaṭ|Eph)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Phil"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ف(?:ِل(?:ِپ(?:ّیُوں(?:[\s\xa0]*کے[\s\xa0]*نام[\s\xa0]*پو[\s\xa0]*لس[\s\xa0]*رسُول[\s\xa0]*کا[\s\xa0]*خط)?|ِّیوں[\s\xa0]*کے[\s\xa0]*نام[\s\xa0]*کا[\s\xa0]*خط)|پّیوں)|لپیوں(?:[\s\xa0]*کے[\s\xa0]*نام[\s\xa0]*کا[\s\xa0]*خط)?)|filippiyōṅ[\s\xa0]*ke[\s\xa0]*nām[\s\xa0]*kā[\s\xa0]*ḫaṭ|Phil)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Col"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ک(?:ُل(?:ِسّیوں(?:[\s\xa0]*کے[\s\xa0]*نام[\s\xa0]*پولُس[\s\xa0]*رسُول[\s\xa0]*کا[\s\xa0]*خط)?|ُسِّیوں[\s\xa0]*کے[\s\xa0]*نام[\s\xa0]*کا[\s\xa0]*خط|س[ِّ]یوں)|لسیوں(?:[\s\xa0]*کے[\s\xa0]*نام[\s\xa0]*کا[\s\xa0]*خط)?)|kulussiyōṅ[\s\xa0]*ke[\s\xa0]*nām[\s\xa0]*kā[\s\xa0]*ḫaṭ|Col)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Thess"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])(
		(?:تھ(?:سلنیک(?:وں[\s\xa0]*کے[\s\xa0]*نام[\s\xa0]*پو[\s\xa0]*لس[\s\xa0]*رسول[\s\xa0]*کا|یوں[\s\xa0]*کے[\s\xa0]*نام[\s\xa0]*کا[\s\xa0]*)|ِسّلُنیکیوں[\s\xa0]*کے[\s\xa0]*نام[\s\xa0]*کا[\s\xa0]*)دوسرا[\s\xa0]*خط|tʰissalunīkiyōṅ[\s\xa0]*ke[\s\xa0]*nām[\s\xa0]*kā[\s\xa0]*dūsrā[\s\xa0]*ḫaṭ|دوم(?:\-?تھِسّلُنیکی|[\s\xa0]*تھِسلُنیکی|(?:[\s\xa0]*تھسّ|۔تھس)لنیکی|[\s\xa0]*تھسلنیک)وں|(?:2\.|۲)(?:\-?تھِسّلُنیکی|[\s\xa0]*تھِسلُنیکی|(?:[\s\xa0]*تھسّ|۔تھس)لنیکی|[\s\xa0]*تھسلنیک)وں|2(?:\-?تھِسّلُنیکیوں|[\s\xa0]*تھِسلُنیکیوں|(?:[\s\xa0]*تھسّ|۔تھس)لنیکیوں|[\s\xa0]*تھسلنیکوں|Thess))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Thess"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])(
		(?:تھ(?:س(?:ّلنیکیوں[\s\xa0]*کے[\s\xa0]*نام[\s\xa0]*پولس[\s\xa0]*رسول|لنیکیوں[\s\xa0]*کے[\s\xa0]*نام)|ِسّلُنیکیوں[\s\xa0]*کے[\s\xa0]*نام)[\s\xa0]*کا[\s\xa0]*پہلا[\s\xa0]*خط|tʰissalunīkiyōṅ[\s\xa0]*ke[\s\xa0]*nām[\s\xa0]*kā[\s\xa0]*pahlā[\s\xa0]*ḫaṭ|اوّل(?:\-?تھِسّلُ|[\s\xa0]*تھِسلُ|(?:[\s\xa0]*تھسّ|۔تھس)ل)نیکیوں|(?:1\.|۱)(?:\-?تھِسّلُ|[\s\xa0]*تھِسلُ|(?:[\s\xa0]*تھسّ|۔تھس)ل)نیکیوں|1(?:\-?تھِسّلُنیکیوں|[\s\xa0]*تھِسلُنیکیوں|(?:[\s\xa0]*تھسّ|۔تھس)لنیکیوں|Thess))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Tim"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])(
		(?:ت(?:ی(?:ِمُتھِیُس[\s\xa0]*کے[\s\xa0]*نام[\s\xa0]*پولس[\s\xa0]*رسول|متھیس[\s\xa0]*کے[\s\xa0]*نام)|ِیمُتھِیُس[\s\xa0]*کے[\s\xa0]*نام)[\s\xa0]*کا[\s\xa0]*دوسرا[\s\xa0]*خط|tīmutʰiyus[\s\xa0]*ke[\s\xa0]*nām[\s\xa0]*kā[\s\xa0]*dūsrā[\s\xa0]*ḫaṭ|دوم(?:\-?تِیمُتھِیُ|[\s\xa0]*ت(?:ی(?:ِمُتھِیُ|مِتھُی)|ِیمُتھِیُ)|۔تیمتھی)س|(?:2\.|۲)(?:\-?تِیمُتھِیُ|[\s\xa0]*ت(?:ی(?:ِمُتھِیُ|مِتھُی)|ِیمُتھِیُ)|۔تیمتھی)س|2(?:\-?تِیمُتھِیُس|[\s\xa0]*ت(?:ی(?:ِمُتھِیُ|مِتھُی)|ِیمُتھِیُ)س|۔تیمتھیس|Tim))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Tim"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])(
		(?:ت(?:ِیمُتھِیُس[\s\xa0]*کے[\s\xa0]*نام[\s\xa0]*(?:پولُس[\s\xa0]*رسول[\s\xa0]*)?|یمتھیس[\s\xa0]*کے[\s\xa0]*نام[\s\xa0]*)کا[\s\xa0]*پہلا[\s\xa0]*خط|tīmutʰiyus[\s\xa0]*ke[\s\xa0]*nām[\s\xa0]*kā[\s\xa0]*pahlā[\s\xa0]*ḫaṭ|اوّل(?:\-?تِیمُتھِیُ|[\s\xa0]*ت(?:ِیمُتھِیُ|یمِتھُی)|۔تیمتھی)س|(?:1\.|۱)(?:\-?تِیمُتھِیُ|[\s\xa0]*ت(?:ِیمُتھِیُ|یمِتھُی)|۔تیمتھی)س|1(?:\-?تِیمُتھِیُس|[\s\xa0]*ت(?:ِیمُتھِیُ|یمِتھُی)س|۔تیمتھیس|Tim))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Titus"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ط(?:ِطُس(?:[\s\xa0]*کے[\s\xa0]*نام[\s\xa0]*(?:پولس[\s\xa0]*رسُول[\s\xa0]*)?کا[\s\xa0]*خط)?|طس(?:[\s\xa0]*کے[\s\xa0]*نام[\s\xa0]*کا[\s\xa0]*خط)?)|ṭiṭus[\s\xa0]*ke[\s\xa0]*nām[\s\xa0]*kā[\s\xa0]*ḫaṭ|Titus)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Phlm"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ف(?:لیمون(?:[\s\xa0]*کے[\s\xa0]*نام[\s\xa0]*(?:پولس[\s\xa0]*رسُول[\s\xa0]*)?کا[\s\xa0]*خط)?|ِلیمون(?:[\s\xa0]*کے[\s\xa0]*نام[\s\xa0]*کا[\s\xa0]*خط)?)|filēmōn[\s\xa0]*ke[\s\xa0]*nām[\s\xa0]*kā[\s\xa0]*ḫaṭ|Phlm)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Heb"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ع(?:برانیوں(?:[\s\xa0]*کے[\s\xa0]*نام[\s\xa0]*(?:پولس[\s\xa0]*رسول[\s\xa0]*)?کا[\s\xa0]*خط)?|ِبرانیوں(?:[\s\xa0]*کے[\s\xa0]*نام[\s\xa0]*کا[\s\xa0]*خط)?)|ʿibrāniyōṅ[\s\xa0]*ke[\s\xa0]*nām[\s\xa0]*kā[\s\xa0]*ḫaṭ|Heb)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Jas"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:yaʿqūb[\s\xa0]*kā[\s\xa0]*ʿām[\s\xa0]*ḫaṭ|یعق(?:ُوب[\s\xa0]*کا[\s\xa0]*عا|وب[\s\xa0]*کا[\s\xa0]*عا[\s\xa0]*?)م[\s\xa0]*خط|یعقُ?وب|يعقوب|Jas)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Pet"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])(
		(?:paṭras[\s\xa0]*kā[\s\xa0]*dūsrā[\s\xa0]*ʿām[\s\xa0]*ḫaṭ|پطرس[\s\xa0]*کا[\s\xa0]*دوسرا[\s\xa0]*عام[\s\xa0]*خط|دوم(?:[\s\xa0]*پطر[\s\xa0]*?|[\x2D۔]پطر)س|(?:2\.|۲)(?:[\s\xa0]*پطر[\s\xa0]*?|[\x2D۔]پطر)س|2(?:[\s\xa0]*پطر[\s\xa0]*?س|[\x2D۔]پطرس|Pet))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Pet"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])(
		(?:paṭras[\s\xa0]*kā[\s\xa0]*pahlā[\s\xa0]*ʿām[\s\xa0]*ḫaṭ|پطر(?:[\s\xa0]*س[\s\xa0]*کاپہلا[\s\xa0]*عا[\s\xa0]*|س[\s\xa0]*کا[\s\xa0]*پہلا[\s\xa0]*عا)م[\s\xa0]*خط|اوّل(?:[\s\xa0]*پطر[\s\xa0]*?|[\x2D۔]پطر)س|(?:1\.|۱)(?:[\s\xa0]*پطر[\s\xa0]*?|[\x2D۔]پطر)س|1(?:[\s\xa0]*پطر[\s\xa0]*?س|[\x2D۔]پطرس|Pet))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Jude"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:yahūdāh[\s\xa0]*kā[\s\xa0]*ʿām[\s\xa0]*ḫaṭ|یہُ?وداہ[\s\xa0]*کا[\s\xa0]*عام[\s\xa0]*خط|یہُ?وداہ|Jude)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Tob"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Tob)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Jdt"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Jdt)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Bar"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Bar)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Sus"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Sus)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Macc"]
		apocrypha: true
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])(
		(?:2Macc)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["3Macc"]
		apocrypha: true
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])(
		(?:3Macc)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["4Macc"]
		apocrypha: true
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])(
		(?:4Macc)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Macc"]
		apocrypha: true
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏؐ-ؚؠ-ٟٮ-ۓە-ۜ۟-۪ۨ-ۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬࣤ-ࣾḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿﭐ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼ])(
		(?:1Macc)
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
