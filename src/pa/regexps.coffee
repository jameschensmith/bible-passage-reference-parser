bcv_parser::regexps.space = "[\\s\\xa0]"
bcv_parser::regexps.escaped_passage = ///
	(?:^ | [^\x1f\x1e\dA-Za-zªµºÀ-ÖØ-öø-ɏਁ-ਂਅ-ਊਏ-ਐਓ-ਨਪ-ਰਲ-ਲ਼ਵ-ਸ਼ਸ-ਹ਼ੁ-ੂੇ-ੈੋ-੍ੑਖ਼-ੜਫ਼ੰ-ੵḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ] )	# Beginning of string or not in the middle of a word or immediately following another book. Only count a book if it's part of a sequence: `Matt5John3` is OK, but not `1Matt5John3`
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
				  | chapter | ਜਾਂ | ff | ਪਦ | -
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
bcv_parser::regexps.pre_book = "[^A-Za-zªµºÀ-ÖØ-öø-ɏਁ-ਂਅ-ਊਏ-ਐਓ-ਨਪ-ਰਲ-ਲ਼ਵ-ਸ਼ਸ-ਹ਼ੁ-ੂੇ-ੈੋ-੍ੑਖ਼-ੜਫ਼ੰ-ੵḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ]"

bcv_parser::regexps.first = "(?:ਪਹਿਲੀ|pahilī|1)\\.?#{bcv_parser::regexps.space}*"
bcv_parser::regexps.second = "(?:ਦੂਜੀ|dūjī|2)\\.?#{bcv_parser::regexps.space}*"
bcv_parser::regexps.third = "(?:ਤੀਜੀ|3)\\.?#{bcv_parser::regexps.space}*"
bcv_parser::regexps.range_and = "(?:[&\u2013\u2014-]|ਜਾਂ|-)"
bcv_parser::regexps.range_only = "(?:[\u2013\u2014-]|-)"
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
		(?:utpat|ਉਤਪਤ|Gen)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Exod"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Exod|ਕੂਚ|kūč)
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
		(?:levīāṃ(?:[\s\xa0]*dī[\s\xa0]*potʰī)?|ਲੇਵੀਆਂ[\s\xa0]*ਦੀ[\s\xa0]*ਪੋਥੀ|ਲੇਵੀਆਂ|Lev)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Num"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ਗਿਣਤੀ|giṇtī|Num)
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
		(?:ਵਿਰਲਾਪ|virlāp|Lam)
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
		(?:yūh\xE3nā[\s\xa0]*de[\s\xa0]*prakāš(?:[\s\xa0]*dī[\s\xa0]*potʰī)?|ਯੂਹੰਨਾ[\s\xa0]*ਦੇ[\s\xa0]*ਪਰਕਾਸ਼[\s\xa0]*ਦੀ[\s\xa0]*ਪੋਥੀ|ਪਰਕਾਸ਼[\s\xa0]*ਦੀ[\s\xa0]*ਪੋਥੀ|Rev)
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
		(?:bivastʰā[\s\xa0]*sār|ਬਿਵਸਥਾ[\s\xa0]*ਸਾਰ|ਬਿਵਸਥਾ|Deut)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Josh"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ਯਹੋਸ਼ੁਆ|yahošuā|Josh)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Judg"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ਨਿਆਂ?ਈਆਂ[\s\xa0]*ਦੀ[\s\xa0]*ਪੋਥੀ|niāīāṃ(?:[\s\xa0]*dī[\s\xa0]*potʰī)?|Judg)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Ruth"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:rūtʰ|Ruth|ਰੂਥ)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Esd"]
		apocrypha: true
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏਁ-ਂਅ-ਊਏ-ਐਓ-ਨਪ-ਰਲ-ਲ਼ਵ-ਸ਼ਸ-ਹ਼ੁ-ੂੇ-ੈੋ-੍ੑਖ਼-ੜਫ਼ੰ-ੵḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:1Esd)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Esd"]
		apocrypha: true
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏਁ-ਂਅ-ਊਏ-ਐਓ-ਨਪ-ਰਲ-ਲ਼ਵ-ਸ਼ਸ-ਹ਼ੁ-ੂੇ-ੈੋ-੍ੑਖ਼-ੜਫ਼ੰ-ੵḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:2Esd)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Isa"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ਯਾ?ਸਾਯਾਹ|yasāyāh|ਯਸਾ|Isa)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Sam"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏਁ-ਂਅ-ਊਏ-ਐਓ-ਨਪ-ਰਲ-ਲ਼ਵ-ਸ਼ਸ-ਹ਼ੁ-ੂੇ-ੈੋ-੍ੑਖ਼-ੜਫ਼ੰ-ੵḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:samūel[\s\xa0]*dī[\s\xa0]*dūjī[\s\xa0]*potʰī|ਸਮੂਏਲ[\s\xa0]*ਦੀ[\s\xa0]*ਦੂਜੀ[\s\xa0]*ਪੋਥੀ|2(?:[\s\xa0]*(?:samūel|ਸਮੂਏਲ)|Sam))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Sam"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏਁ-ਂਅ-ਊਏ-ਐਓ-ਨਪ-ਰਲ-ਲ਼ਵ-ਸ਼ਸ-ਹ਼ੁ-ੂੇ-ੈੋ-੍ੑਖ਼-ੜਫ਼ੰ-ੵḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:samūel[\s\xa0]*dī[\s\xa0]*pahilī[\s\xa0]*potʰī|ਸਮੂਏਲ[\s\xa0]*ਦੀ[\s\xa0]*ਪਹਿਲੀ[\s\xa0]*ਪੋਥੀ|1(?:[\s\xa0]*(?:samūel|ਸਮੂਏਲ)|Sam))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Kgs"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏਁ-ਂਅ-ਊਏ-ਐਓ-ਨਪ-ਰਲ-ਲ਼ਵ-ਸ਼ਸ-ਹ਼ੁ-ੂੇ-ੈੋ-੍ੑਖ਼-ੜਫ਼ੰ-ੵḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:rājiāṃ[\s\xa0]*dī[\s\xa0]*dūjī[\s\xa0]*potʰī|ਰਾਜਿਆਂ[\s\xa0]*ਦੀ[\s\xa0]*ਦੂਜੀ[\s\xa0]*ਪੋਥੀ|2(?:[\s\xa0]*(?:ਰਾਜਿਆਂ|rājiāṃ)|Kgs))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Kgs"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏਁ-ਂਅ-ਊਏ-ਐਓ-ਨਪ-ਰਲ-ਲ਼ਵ-ਸ਼ਸ-ਹ਼ੁ-ੂੇ-ੈੋ-੍ੑਖ਼-ੜਫ਼ੰ-ੵḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:rājiāṃ[\s\xa0]*dī[\s\xa0]*pahilī[\s\xa0]*potʰī|ਰਾਜਿਆਂ[\s\xa0]*ਦੀ[\s\xa0]*ਪਹਿਲੀ[\s\xa0]*ਪੋਥੀ|1(?:[\s\xa0]*(?:ਰਾਜਿਆਂ|rājiāṃ)|Kgs))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Chr"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏਁ-ਂਅ-ਊਏ-ਐਓ-ਨਪ-ਰਲ-ਲ਼ਵ-ਸ਼ਸ-ਹ਼ੁ-ੂੇ-ੈੋ-੍ੑਖ਼-ੜਫ਼ੰ-ੵḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:itahās[\s\xa0]*dī[\s\xa0]*dūjī[\s\xa0]*potʰī|ਇਤਹਾਸ[\s\xa0]*ਦੀ[\s\xa0]*ਦੂਜੀ[\s\xa0]*ਪੋਥੀ|2(?:[\s\xa0]*(?:itahās|ਇਤਹਾਸ)|Chr))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Chr"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏਁ-ਂਅ-ਊਏ-ਐਓ-ਨਪ-ਰਲ-ਲ਼ਵ-ਸ਼ਸ-ਹ਼ੁ-ੂੇ-ੈੋ-੍ੑਖ਼-ੜਫ਼ੰ-ੵḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:itahās[\s\xa0]*dī[\s\xa0]*pahilī[\s\xa0]*potʰī|ਇਤਹਾਸ[\s\xa0]*ਦੀ[\s\xa0]*ਪਹਿਲੀ[\s\xa0]*ਪੋਥੀ|1(?:[\s\xa0]*(?:itahās|ਇਤਹਾਸ)|Chr))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Ezra"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ਅਜ਼ਰਾ|azrā|Ezra)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Neh"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:nahamyāh|ਨਹਮਯਾਹ|Neh)
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
		(?:astar|ਅਸਤਰ|Esth)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Job"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ਅੱ?ਯੂਬ|ayyūb|Job)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Ps"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ਜ਼?ਬੂਰ|zabūr|Ps)
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
		(?:kahāutāṃ|ਕਹਾਉ(?:ਤਾਂ|ਂਤਾ)|Prov)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Eccl"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:upadešak|ਉਪਦੇਸ਼ਕ|Eccl)
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
		(?:salemān[\s\xa0]*dā[\s\xa0]*gīt|ਸਲੇਮਾਨ[\s\xa0]*ਦਾ[\s\xa0]*ਗੀਤ|Song)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Jer"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ਯਿਰਮਿਯਾਹ|yirmiyāh|Jer)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Ezek"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ਹਿਜ਼ਕੀਏਲ|hizkīel|Ezek)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Dan"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ਦਾਨੀਏਲ|dānīel|Dan)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Hos"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ਹੋਸ਼ੇਆ|hošeā|Hos)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Joel"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:[ਜਯ]ੋਏਲ|[Jy]oel)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Amos"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ਆਮੋਸ|[Aā]mos)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Obad"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:obadyāh|ਓਬਦਯਾਹ|Obad)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Jonah"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ਯੂਨਾਹ|yūnāh|Jonah)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Mic"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ਮੀਕਾਹ|mīkāh|Mic)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Nah"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:nahūm|ਨਹੂਮ|Nah)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Hab"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:habakkūk|ਹਬ(?:ੱਕ|ਕੱ?)ੂਕ|Hab)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Zeph"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:safanyāh|ਸਫ਼ਨਯਾਹ|Zeph)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Hag"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:hajjaī|ਹੱਜਈ|Hag)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Zech"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:zakaryāh|ਜ(?:਼ਕਰ[ਜਯ]|ਕਰਯ)ਾਹ|Zech)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Mal"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:malākī|ਮਲਾਕੀ|Mal)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Matt"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ਮੱਤੀ[\s\xa0]*ਦੀ[\s\xa0]*ਇੰਜੀਲ|mattī(?:[\s\xa0]*dī[\s\xa0]*ĩjīl)?|ਮੱਤੀ|Matt)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Mark"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ਮਰਕੁਸ[\s\xa0]*ਦੀ[\s\xa0]*ਇੰਜੀਲ|markus(?:[\s\xa0]*dī[\s\xa0]*ĩjīl)?|ਮਰਕੁਸ|Mark)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Luke"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ਲੂਕਾ(?:[\s\xa0]*ਦੀ[\s\xa0]*ਇੰਜੀਲ)?|lūkā[\s\xa0]*dī[\s\xa0]*ĩjīl|lūkā|Luke)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1John"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏਁ-ਂਅ-ਊਏ-ਐਓ-ਨਪ-ਰਲ-ਲ਼ਵ-ਸ਼ਸ-ਹ਼ੁ-ੂੇ-ੈੋ-੍ੑਖ਼-ੜਫ਼ੰ-ੵḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:yūh\xE3nā[\s\xa0]*dī[\s\xa0]*pahilī[\s\xa0]*pattrī|ਯੂਹੰਨਾ[\s\xa0]*ਦੀ[\s\xa0]*ਪਹਿਲੀ[\s\xa0]*ਪੱਤ੍ਰੀ|1(?:[\s\xa0]*(?:ਯੂਹੰਨਾ|yūh\xE3nā)|John))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2John"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏਁ-ਂਅ-ਊਏ-ਐਓ-ਨਪ-ਰਲ-ਲ਼ਵ-ਸ਼ਸ-ਹ਼ੁ-ੂੇ-ੈੋ-੍ੑਖ਼-ੜਫ਼ੰ-ੵḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:ਯੂਹੰਨਾ[\s\xa0]*ਦੀ[\s\xa0]*ਦੂਜੀ[\s\xa0]*ਪੱਤ੍ਰੀ|yūh\xE3nā[\s\xa0]*dī[\s\xa0]*dūjī[\s\xa0]*pattrī|2(?:[\s\xa0]*(?:ਯੂਹੰਨਾ|yūh\xE3nā)|John))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["3John"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏਁ-ਂਅ-ਊਏ-ਐਓ-ਨਪ-ਰਲ-ਲ਼ਵ-ਸ਼ਸ-ਹ਼ੁ-ੂੇ-ੈੋ-੍ੑਖ਼-ੜਫ਼ੰ-ੵḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:ਯੂਹੰਨਾ[\s\xa0]*ਦੀ[\s\xa0]*ਤੀਜੀ[\s\xa0]*ਪੱਤ੍ਰੀ|yūh\xE3nā[\s\xa0]*dī[\s\xa0]*tījī[\s\xa0]*pattrī|3(?:[\s\xa0]*(?:ਯੂਹੰਨਾ|yūh\xE3nā)|John))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["John"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ਯੂਹ(?:ੰਨਾ(?:[\s\xa0]*ਦੀ[\s\xa0]*ਇੰਜੀਲ)?|ਾਂਨਾ)|yūh\xE3nā[\s\xa0]*dī[\s\xa0]*ĩjīl|yūh\xE3nā|John)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Acts"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:rasūlāṃ[\s\xa0]*de[\s\xa0]*kartabb|ਰਸੂਲਾਂ[\s\xa0]*ਦੇ[\s\xa0]*ਕਰਤੱਬ|Acts)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Rom"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ਰੋਮੀਆਂ[\s\xa0]*ਨੂੰ[\s\xa0]*ਪੱਤ੍ਰੀ|romīāṃ(?:[\s\xa0]*nū̃[\s\xa0]*pattrī)?|ਰੋਮੀਆਂ(?:[\s\xa0]*ਨੂੰ)?|Rom)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Cor"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏਁ-ਂਅ-ਊਏ-ਐਓ-ਨਪ-ਰਲ-ਲ਼ਵ-ਸ਼ਸ-ਹ਼ੁ-ੂੇ-ੈੋ-੍ੑਖ਼-ੜਫ਼ੰ-ੵḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:ਕੁਰਿੰਥੀਆਂ[\s\xa0]*ਨੂੰ[\s\xa0]*ਦੂਜੀ[\s\xa0]*ਪੱਤ੍ਰੀ|kurĩtʰīāṃ[\s\xa0]*nū̃[\s\xa0]*dūjī[\s\xa0]*pattrī|2(?:[\s\xa0]*(?:ਕੁਰਿੰਥੀਆਂ[\s\xa0]*ਨੂੰ|kurĩtʰīāṃ)|Cor)|2[\s\xa0]*ਕੁਰਿੰਥੀਆਂ)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Cor"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏਁ-ਂਅ-ਊਏ-ਐਓ-ਨਪ-ਰਲ-ਲ਼ਵ-ਸ਼ਸ-ਹ਼ੁ-ੂੇ-ੈੋ-੍ੑਖ਼-ੜਫ਼ੰ-ੵḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:kurĩtʰīāṃ[\s\xa0]*nū̃[\s\xa0]*pahilī[\s\xa0]*pattrī|ਕੁਰਿੰਥੀਆਂ[\s\xa0]*ਨੂੰ[\s\xa0]*ਪਹਿਲੀ[\s\xa0]*ਪੱਤ੍ਰੀ|1(?:[\s\xa0]*(?:ਕੁਰਿੰਥੀਆਂ[\s\xa0]*ਨੂੰ|kurĩtʰīāṃ)|Cor)|ਕੁਰਿੰਥੀਆਂ[\s\xa0]*ਨੂੰ|1[\s\xa0]*ਕੁਰਿੰਥੀਆਂ)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Gal"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:galātīāṃ(?:[\s\xa0]*nū̃[\s\xa0]*pattrī)?|ਗਲਾਤੀਆਂ[\s\xa0]*ਨੂੰ[\s\xa0]*ਪੱਤ੍ਰੀ|ਗਲਾਤੀਆਂ[\s\xa0]*ਨੂੰ|Gal)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Eph"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ਅਫ਼ਸੀਆਂ[\s\xa0]*ਨੂੰ[\s\xa0]*ਪੱਤ੍ਰੀ|afasīāṃ(?:[\s\xa0]*nū̃[\s\xa0]*pattrī)?|ਅਫ਼ਸੀਆਂ[\s\xa0]*ਨੂੰ|Eph)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Phil"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ਫ਼ਿਲਿੱਪੀਆਂ[\s\xa0]*ਨੂੰ(?:[\s\xa0]*ਪੱਤ੍ਰੀ)?|filippīāṃ[\s\xa0]*nū̃[\s\xa0]*pattrī|filippīāṃ|Phil)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Col"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ਕੁਲੁੱਸੀਆਂ[\s\xa0]*ਨੂੰ[\s\xa0]*ਪੱਤ੍ਰੀ|kulussīāṃ(?:[\s\xa0]*nū̃[\s\xa0]*pattrī)?|ਕੁਲੁੱਸੀਆਂ[\s\xa0]*ਨੂੰ|Col)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Thess"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏਁ-ਂਅ-ਊਏ-ਐਓ-ਨਪ-ਰਲ-ਲ਼ਵ-ਸ਼ਸ-ਹ਼ੁ-ੂੇ-ੈੋ-੍ੑਖ਼-ੜਫ਼ੰ-ੵḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:tʰassalunīkīāṃ[\s\xa0]*nū̃[\s\xa0]*dūjī[\s\xa0]*pattrī|ਥੱਸਲੁਨੀਕੀਆਂ[\s\xa0]*ਨੂੰ[\s\xa0]*ਦੂਜੀ[\s\xa0]*ਪੱਤ੍ਰੀ|2(?:[\s\xa0]*(?:ਥੱਸਲੁਨੀਕੀਆਂ[\s\xa0]*ਨੂੰ|tʰassalunīkīāṃ)|Thess))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Thess"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏਁ-ਂਅ-ਊਏ-ਐਓ-ਨਪ-ਰਲ-ਲ਼ਵ-ਸ਼ਸ-ਹ਼ੁ-ੂੇ-ੈੋ-੍ੑਖ਼-ੜਫ਼ੰ-ੵḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:tʰassalunīkīāṃ[\s\xa0]*nū̃[\s\xa0]*pahilī[\s\xa0]*pattrī|ਥ(?:ੱਸ|ਸੱ)ਲੁਨੀਕੀਆਂ[\s\xa0]*ਨੂੰ[\s\xa0]*ਪਹਿਲੀ[\s\xa0]*ਪੱਤ੍ਰੀ|1(?:[\s\xa0]*(?:ਥੱਸਲੁਨੀਕੀਆਂ[\s\xa0]*ਨੂੰ|tʰassalunīkīāṃ)|Thess))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Tim"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏਁ-ਂਅ-ਊਏ-ਐਓ-ਨਪ-ਰਲ-ਲ਼ਵ-ਸ਼ਸ-ਹ਼ੁ-ੂੇ-ੈੋ-੍ੑਖ਼-ੜਫ਼ੰ-ੵḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:timotʰius[\s\xa0]*nū̃[\s\xa0]*dūjī[\s\xa0]*pattrī|ਤਿਮੋਥਿਉਸ[\s\xa0]*ਨੂੰ[\s\xa0]*ਦੂਜੀ[\s\xa0]*ਪੱਤ੍ਰੀ|2(?:[\s\xa0]*(?:ਤਿਮੋਥਿਉਸ[\s\xa0]*ਨੂੰ|timotʰius)|Tim))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Tim"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏਁ-ਂਅ-ਊਏ-ਐਓ-ਨਪ-ਰਲ-ਲ਼ਵ-ਸ਼ਸ-ਹ਼ੁ-ੂੇ-ੈੋ-੍ੑਖ਼-ੜਫ਼ੰ-ੵḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:timotʰius[\s\xa0]*nū̃[\s\xa0]*pahilī[\s\xa0]*pattrī|ਤਿਮੋਥਿਉਸ[\s\xa0]*ਨੂੰ[\s\xa0]*ਪਹਿਲੀ[\s\xa0]*ਪੱਤ੍ਰੀ|1(?:[\s\xa0]*(?:ਤਿਮੋਥਿਉਸ[\s\xa0]*ਨੂੰ|timotʰius)|Tim))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Titus"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ਤੀਤੁਸ[\s\xa0]*ਨੂੰ[\s\xa0]*ਪੱਤ੍ਰੀ|tītus(?:[\s\xa0]*nū̃[\s\xa0]*pattrī)?|ਤੀਤੁਸ(?:[\s\xa0]*ਨੂੰ)?|Titus)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Phlm"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ਫ਼?ਿਲੇਮੋਨ[\s\xa0]*ਨੂੰ[\s\xa0]*ਪੱਤ੍ਰੀ|pʰilemon(?:[\s\xa0]*nū̃[\s\xa0]*pattrī)?|ਫ਼ਿਲੇਮੋਨ[\s\xa0]*ਨੂੰ|Phlm)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Heb"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ਇਬਰਾਨੀਆਂ[\s\xa0]*ਨੂੰ[\s\xa0]*ਪੱਤ੍ਰੀ|ibrānīāṃ(?:[\s\xa0]*nū̃[\s\xa0]*pattrī)?|ਇਬਰਾਨੀਆਂ[\s\xa0]*ਨੂੰ|Heb)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Jas"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:ਯਾਕੂਬ[\s\xa0]*ਦੀ[\s\xa0]*ਪੱਤ੍ਰੀ|yākūb(?:[\s\xa0]*dī[\s\xa0]*pattrī)?|ਯਾਕੂਬ|Jas)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Pet"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏਁ-ਂਅ-ਊਏ-ਐਓ-ਨਪ-ਰਲ-ਲ਼ਵ-ਸ਼ਸ-ਹ਼ੁ-ੂੇ-ੈੋ-੍ੑਖ਼-ੜਫ਼ੰ-ੵḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:patras[\s\xa0]*dī[\s\xa0]*dūjī[\s\xa0]*pattrī|ਪਤਰਸ[\s\xa0]*ਦੀ[\s\xa0]*ਦੂਜੀ[\s\xa0]*ਪੱਤ੍ਰੀ|2(?:[\s\xa0]*(?:patras|ਪਤਰਸ)|Pet))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Pet"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏਁ-ਂਅ-ਊਏ-ਐਓ-ਨਪ-ਰਲ-ਲ਼ਵ-ਸ਼ਸ-ਹ਼ੁ-ੂੇ-ੈੋ-੍ੑਖ਼-ੜਫ਼ੰ-ੵḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:patras[\s\xa0]*dī[\s\xa0]*pahilī[\s\xa0]*pattrī|ਪਤਰਸ[\s\xa0]*ਦੀ[\s\xa0]*ਪਹਿਲੀ[\s\xa0]*ਪੱਤ੍ਰੀ|1(?:[\s\xa0]*(?:patras|ਪਤਰਸ)|Pet))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Jude"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:yahūdāh(?:[\s\xa0]*dī[\s\xa0]*pattrī)?|ਯਹੂਦਾਹ[\s\xa0]*ਦੀ[\s\xa0]*ਪੱਤ੍ਰੀ|ਯਹੂਦਾਹ|Jude)
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
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏਁ-ਂਅ-ਊਏ-ਐਓ-ਨਪ-ਰਲ-ਲ਼ਵ-ਸ਼ਸ-ਹ਼ੁ-ੂੇ-ੈੋ-੍ੑਖ਼-ੜਫ਼ੰ-ੵḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:2Macc)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["3Macc"]
		apocrypha: true
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏਁ-ਂਅ-ਊਏ-ਐਓ-ਨਪ-ਰਲ-ਲ਼ਵ-ਸ਼ਸ-ਹ਼ੁ-ੂੇ-ੈੋ-੍ੑਖ਼-ੜਫ਼ੰ-ੵḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:3Macc)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["4Macc"]
		apocrypha: true
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏਁ-ਂਅ-ਊਏ-ਐਓ-ਨਪ-ਰਲ-ਲ਼ਵ-ਸ਼ਸ-ਹ਼ੁ-ੂੇ-ੈੋ-੍ੑਖ਼-ੜਫ਼ੰ-ੵḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:4Macc)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Macc"]
		apocrypha: true
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏਁ-ਂਅ-ਊਏ-ਐਓ-ਨਪ-ਰਲ-ਲ਼ਵ-ਸ਼ਸ-ਹ਼ੁ-ੂੇ-ੈੋ-੍ੑਖ਼-ੜਫ਼ੰ-ੵḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
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
