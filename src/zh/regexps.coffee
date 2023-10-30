bcv_parser::regexps.space = "[\\s\\xa0]"
bcv_parser::regexps.escaped_passage = ///
	(?:^ | [^\x1f\x1e\dA-Za-z] )	# Beginning of string or not in the middle of a word or immediately following another book. Only count a book if it's part of a sequence: `Matt5John3` is OK, but not `1Matt5John3`
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
				  | 篇 (?! [a-z] )		#could be followed by a number
				  | chapter | verse | ff | ～ | ~ | ； | ， | 參 | 、
				  | [a-e] (?! \w )			#a-e allows 1:1a
				  | $						#or the end of the string
				 )+
		)
	///gi
# These are the only valid ways to end a potential passage match. The closing parenthesis allows for fully capturing parentheses surrounding translations (ESV**)**. The last one, `[\d\x1f]` needs not to be +; otherwise `Gen5ff` becomes `\x1f0\x1f5ff`, and `adjust_regexp_end` matches the `\x1f5` and incorrectly dangles the ff.
bcv_parser::regexps.match_end_split = ///
	  \d \W* 篇
	| \d \W* ff (?: [\s\xa0*]* \.)?
	| \d [\s\xa0*]* [a-e] (?! \w )
	| \x1e (?: [\s\xa0*]* [)\]\uff09] )? #ff09 is a full-width closing parenthesis
	| [\d\x1f]
	///gi
bcv_parser::regexps.control = /[\x1e\x1f]/g
bcv_parser::regexps.pre_book = "[^\\x1f]"

bcv_parser::regexps.first = "第一\\.?#{bcv_parser::regexps.space}*"
bcv_parser::regexps.second = "第二\\.?#{bcv_parser::regexps.space}*"
bcv_parser::regexps.third = "第三\\.?#{bcv_parser::regexps.space}*"
bcv_parser::regexps.range_and = "(?:[&\u2013\u2014-]|(?:；|，|參|、)|(?:～|~))"
bcv_parser::regexps.range_only = "(?:[\u2013\u2014-]|(?:～|~))"
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
		(?:《(?:創(?:世[紀記])?|创(?:世记)?)》|Gen)|(?:(?:創(?:世[紀記])?|创(?:世记)?)》|《(?:創(?:世[紀記])?|创(?:世记)?)|創(?:世[紀記])?|创(?:世记)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Exod"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《出(?:埃及[記记]?|谷紀)?》|Exod)|(?:出(?:(?:埃及[記记]?|谷紀)?》|埃及[記记]?|谷紀)?|《出(?:埃及[記记]?|谷紀)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Bel"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《Bel》?|Bel》?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Lev"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:肋未紀|利(?:末记|未[記记])?)》|Lev)|(?:(?:肋未紀|利(?:末记|未[記记])?)》|《(?:肋未紀|利(?:末记|未[記记])?)|肋未紀|利(?:末记|未[記记])?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Num"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:民(?:(?:數記|数记)》?|》)?|戶籍紀》?)|民(?:數記|数记)》?|戶籍紀》?|Num|民》|民)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Sir"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《德訓篇》?|德訓篇》?|Sir)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Wis"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《智慧篇》?|智慧篇》?|Wis)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Rev"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:若望默示錄|启示录|啟示錄|[啓默]示錄|[启啟])》|Rev)|(?:(?:若望默示錄|启示录|啟示錄|[啓默]示錄|[启啟])》|《(?:若望默示錄|启示录|啟示錄|[啓默]示錄|[启啟])|若望默示錄|启示录|啟示錄|[啓默]示錄|[启啟])
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["PrMan"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《PrMan》?|PrMan》?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Deut"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《申(?:命[紀記记]》?|》)?|Deut|申(?:命[紀記记]》?|》)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Judg"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:民長紀》?|士(?:師記》?|师记》?|》)?)|Judg|民長紀》?|士(?:師記》?|师记》?|》)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Ruth"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:(?:路得[記记]|得)》?|盧德傳》?)|Ruth|(?:路得[記记]|得)》?|盧德傳》?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Esd"]
		apocrypha: true
		regexp: ///(^|[^0-9\\x1f])(
		(?:《1Esd》?|1Esd》?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Esd"]
		apocrypha: true
		regexp: ///(^|[^0-9\\x1f])(
		(?:《2Esd》?|2Esd》?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Isa"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:依撒意亞|以(?:赛亚书|賽(?:亞書|亚书))|[賽赛])》|Isa)|(?:(?:依撒意亞|以(?:赛亚书|賽(?:亞書|亚书))|[賽赛])》|《(?:依撒意亞|以(?:赛亚书|賽(?:亞書|亚书))|[賽赛])|依撒意亞|以(?:赛亚书|賽(?:亞書|亚书))|[賽赛])
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Sam"]
		regexp: ///(^|[^0-9\\x1f])(
		(?:《撒(?:母耳[記记]下》?|慕爾紀下》?|下》?)|撒(?:母耳[記记]下》?|慕爾紀下》?|下》?)|2Sam)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Sam"]
		regexp: ///(^|[^0-9\\x1f])(
		(?:《撒(?:母耳[記记]上》?|慕爾紀上》?|上》?)|撒(?:母耳[記记]上》?|慕爾紀上》?|上》?)|1Sam)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Kgs"]
		regexp: ///(^|[^0-9\\x1f])(
		(?:《(?:列王[紀纪记]下》?|王下》?)|列王[紀纪记]下》?|2Kgs|王下》?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Kgs"]
		regexp: ///(^|[^0-9\\x1f])(
		(?:《(?:列王[紀纪记]上》?|王上》?)|列王[紀纪记]上》?|1Kgs|王上》?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Chr"]
		regexp: ///(^|[^0-9\\x1f])(
		(?:《(?:編年紀|歷代志|历代志|歷|代)下》|2Chr)|(?:(?:編年紀|歷代志|历代志|歷|代)下》|《(?:編年紀|歷代志|历代志|歷|代)下|(?:編年紀|歷代志|历代志|歷|代)下)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Chr"]
		regexp: ///(^|[^0-9\\x1f])(
		(?:《(?:編年紀|歷代志|历代志|歷|代)上》|1Chr)|(?:(?:編年紀|歷代志|历代志|歷|代)上》|《(?:編年紀|歷代志|历代志|歷|代)上|(?:編年紀|歷代志|历代志|歷|代)上)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Ezra"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:厄斯德拉上》?|(?:以斯拉[記记]|拉)》?)|厄斯德拉上》?|(?:以斯拉[記记]|拉)》?|Ezra)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Neh"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:厄斯德拉下》?|尼(?:希米[記记]》?|》)?)|厄斯德拉下》?|尼希米[記记]》?|Neh|尼》|尼)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Amos"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:阿摩司[书書]》?|(?:亞毛斯|摩)》?)|阿摩司[书書]》?|Amos|(?:亞毛斯|摩)》?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Job"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:(?:约伯记|伯)》?|約伯[傳記]》?)|(?:约伯记|伯)》?|約伯[傳記]》?|Job)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Ps"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:聖詠集|[詩诗]篇|[詩诗])》|Ps)|(?:(?:聖詠集|[詩诗]篇|[詩诗])》|《(?:聖詠集|[詩诗]篇|[詩诗])|聖詠集|[詩诗]篇|[詩诗])
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["PrAzar"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《PrAzar》?|PrAzar》?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Prov"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:(?:《箴言?|箴言?)》|Prov|《箴言?|箴言?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["SgThree"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《SgThree》?|SgThree》?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Lam"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:耶利米哀歌》?|連同哀歌》?|哀》?)|耶利米哀歌》?|連同哀歌》?|Lam|哀》?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Song"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:(?:《雅?|雅)?歌》|Song|(?:《雅?|雅)?歌)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["EpJer"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《EpJer》?|EpJer》?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Jer"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《耶(?:肋米亞》?|利米[书書]》?|》)?|耶(?:肋米亞》?|利米[书書]》?|》)?|Jer)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Ezek"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:厄則克耳|以西(?:结书|結[书書])|[結结])》|Ezek)|(?:(?:厄則克耳|以西(?:结书|結[书書])|[結结])》|《(?:厄則克耳|以西(?:结书|結[书書])|[結结])|厄則克耳|以西(?:结书|結[书書])|[結结])
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Dan"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:但(?:以理[书書]》?|》)?|達尼爾》?)|但(?:以理[书書]》?|》)?|達尼爾》?|Dan)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Hos"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:何(?:西阿[书書]》?|》)?|歐瑟亞》?)|何(?:西阿[书書]》?|》)?|歐瑟亞》?|Hos)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Joel"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:约[珥饵]书|約珥書|岳厄爾|珥)》|Joel)|(?:(?:约[珥饵]书|約珥書|岳厄爾|珥)》|《(?:约[珥饵]书|約珥書|岳厄爾|珥)|约[珥饵]书|約珥書|岳厄爾|珥)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Obad"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:俄(?:巴底(?:亞書》?|亚书》?)|》)?|亞北底亞》?)|俄(?:巴底(?:亞書》?|亚书》?)|》)?|亞北底亞》?|Obad)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Jonah"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:(?:《(?:约拿书|約(?:拿書|納)|拿)|约拿书|約(?:拿書|納)|拿)》|Jonah|《(?:约拿书|約(?:拿書|納)|拿)|约拿书|約(?:拿書|納)|拿)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Mic"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:米該亞|彌迦書|弥(?:迦书)?|彌)》|Mic)|(?:(?:米該亞|彌迦書|弥(?:迦书)?|彌)》|《(?:米該亞|彌迦書|弥(?:迦书)?|彌)|米該亞|彌迦書|弥(?:迦书)?|彌)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Nah"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:那(?:鸿书|鴻[书書])|納鴻|[鴻鸿])》|Nah)|(?:(?:那(?:鸿书|鴻[书書])|納鴻|[鴻鸿])》|《(?:那(?:鸿书|鴻[书書])|納鴻|[鴻鸿])|那(?:鸿书|鴻[书書])|納鴻|[鴻鸿])
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Hab"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《哈(?:巴谷(?:[书書]》?|》)?|》)?|哈(?:巴谷(?:[书書]》?|》)?|》)?|Hab)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Zeph"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:(?:西番雅[书書]|番)》?|索福尼亞》?)|(?:西番雅[书書]|番)》?|索福尼亞》?|Zeph)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Hag"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:哈(?:该书|該[书書]|蓋)|[該该])》|Hag)|(?:(?:哈(?:该书|該[书書]|蓋)|[該该])》|《(?:哈(?:该书|該[书書]|蓋)|[該该])|哈(?:该书|該[书書]|蓋)|[該该])
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Mal"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:瑪(?:拉基[亞書])?|玛(?:拉基书?)?)》|Mal)|(?:(?:瑪(?:拉基[亞書])?|玛(?:拉基书?)?)》|《(?:瑪(?:拉基[亞書])?|玛(?:拉基书?)?)|瑪(?:拉基[亞書])?|玛(?:拉基书?)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Gal"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:迦拉達書|戛拉提亞|加(?:拉太[书書])?)》|Gal)|(?:(?:迦拉達書|戛拉提亞|加(?:拉太[书書])?)》|《(?:迦拉達書|戛拉提亞|加(?:拉太[书書])?)|迦拉達書|戛拉提亞|加(?:拉太[书書])?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Zech"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:撒(?:迦利(?:亞書|亚书|亞)|加利亞書)|匝加利亞|[亚亞])》|Zech)|(?:(?:撒(?:迦利(?:亞書|亚书|亞)|加利亞書)|匝加利亞|[亚亞])》|《(?:撒(?:迦利(?:亞書|亚书|亞)|加利亞書)|匝加利亞|[亚亞])|撒(?:迦利(?:亞書|亚书|亞)|加利亞書)|匝加利亞|[亚亞])
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Matt"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:[馬马]太福音|瑪(?:竇福音|特斐)|太)》|Matt)|(?:(?:[馬马]太福音|瑪(?:竇福音|特斐)|太)》|《(?:[馬马]太福音|瑪(?:竇福音|特斐)|太)|[馬马]太福音|瑪(?:竇福音|特斐)|太)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Mark"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:馬(?:爾谷|可)福音|马可福音|瑪爾克|可)》|Mark)|(?:(?:馬(?:爾谷|可)福音|马可福音|瑪爾克|可)》|《(?:馬(?:爾谷|可)福音|马可福音|瑪爾克|可)|馬(?:爾谷|可)福音|马可福音|瑪爾克|可)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Luke"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:路(?:加福音》?|》)?|魯喀》?)|路(?:加福音》?|》)?|Luke|魯喀》?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1John"]
		regexp: ///(^|[^0-9\\x1f])(
		(?:《(?:约(?:翰[一壹]书|壹)|若望一書|約(?:翰[一壹]書|壹)|伊望第一)》|1John)|(?:(?:约(?:翰[一壹]书|壹)|若望一書|約(?:翰[一壹]書|壹)|伊望第一)》|《(?:约(?:翰[一壹]书|壹)|若望一書|約(?:翰[一壹]書|壹)|伊望第一)|约(?:翰[一壹]书|壹)|若望一書|約(?:翰[一壹]書|壹)|伊望第一)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2John"]
		regexp: ///(^|[^0-9\\x1f])(
		(?:《(?:约(?:翰[二贰]书|贰)|若望二書|約(?:翰[二貳]書|[貳贰])|伊望第二)》|2John)|(?:(?:约(?:翰[二贰]书|贰)|若望二書|約(?:翰[二貳]書|[貳贰])|伊望第二)》|《(?:约(?:翰[二贰]书|贰)|若望二書|約(?:翰[二貳]書|[貳贰])|伊望第二)|约(?:翰[二贰]书|贰)|若望二書|約(?:翰[二貳]書|[貳贰])|伊望第二)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["3John"]
		regexp: ///(^|[^0-9\\x1f])(
		(?:《(?:约(?:翰[三叁]书|[三叁])|若望三書|約(?:翰[三參]書|[三叁])|伊望第三)》|3John)|(?:(?:约(?:翰[三叁]书|[三叁])|若望三書|約(?:翰[三參]書|[三叁])|伊望第三)》|《(?:约(?:翰[三叁]书|[三叁])|若望三書|約(?:翰[三參]書|[三叁])|伊望第三)|约(?:翰[三叁]书|[三叁])|若望三書|約(?:翰[三參]書|[三叁])|伊望第三)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["John"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:若望福音|[約约](?:翰福音)?|伊望)》|John)|(?:(?:若望福音|[約约](?:翰福音)?|伊望)》|《(?:若望福音|[約约](?:翰福音)?|伊望)|若望福音|[約约](?:翰福音)?|伊望)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Rom"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:羅(?:爾瑪書|馬書)?|罗(?:马书)?)》|Rom)|(?:(?:羅(?:爾瑪書|馬書)?|罗(?:马书)?)》|《(?:羅(?:爾瑪書|馬書)?|罗(?:马书)?)|羅(?:爾瑪書|馬書)?|罗(?:马书)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Cor"]
		regexp: ///(^|[^0-9\\x1f])(
		(?:《(?:适凌爾福後|[格歌]林多後書|哥林多(?:後書|后书)|林[后後])》|2Cor)|(?:(?:适凌爾福後|[格歌]林多後書|哥林多(?:後書|后书)|林[后後])》|《(?:适凌爾福後|[格歌]林多後書|哥林多(?:後書|后书)|林[后後])|适凌爾福後|[格歌]林多後書|哥林多(?:後書|后书)|林[后後])
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Cor"]
		regexp: ///(^|[^0-9\\x1f])(
		(?:《(?:(?:适凌爾福|林)前|[格歌]林多前書|哥林多前[书書])》|1Cor)|(?:(?:(?:适凌爾福|林)前|[格歌]林多前書|哥林多前[书書])》|《(?:(?:适凌爾福|林)前|[格歌]林多前書|哥林多前[书書])|(?:适凌爾福|林)前|[格歌]林多前書|哥林多前[书書])
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Eph"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:厄弗所書|以弗所[书書]|耶斐斯|弗)》|Eph)|(?:(?:厄弗所書|以弗所[书書]|耶斐斯|弗)》|《(?:厄弗所書|以弗所[书書]|耶斐斯|弗)|厄弗所書|以弗所[书書]|耶斐斯|弗)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Phil"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:腓立比[书書]|斐理伯書|肥利批|腓)》|Phil)|(?:(?:腓立比[书書]|斐理伯書|肥利批|腓)》|《(?:腓立比[书書]|斐理伯書|肥利批|腓)|腓立比[书書]|斐理伯書|肥利批|腓)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Col"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:歌罗西书|歌羅西書|哥羅森書|适羅斯|西)》|Col)|(?:(?:歌罗西书|歌羅西書|哥羅森書|适羅斯|西)》|《(?:歌罗西书|歌羅西書|哥羅森書|适羅斯|西)|歌罗西书|歌羅西書|哥羅森書|适羅斯|西)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["GkEsth"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《GkEsth》?|GkEsth》?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Esth"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:艾斯德爾傳》?|(?:以斯帖[記记]|斯)》?)|艾斯德爾傳》?|(?:以斯帖[記记]|斯)》?|Esth)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Acts"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:宗徒(?:大事錄|行實)|使徒行[传傳]|徒)》|Acts)|(?:(?:宗徒(?:大事錄|行實)|使徒行[传傳]|徒)》|《(?:宗徒(?:大事錄|行實)|使徒行[传傳]|徒)|宗徒(?:大事錄|行實)|使徒行[传傳]|徒)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Tob"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《多俾亞傳》?|多俾亞傳》?|Tob)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Jdt"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《友弟德傳》?|友弟德傳》?|Jdt)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Eccl"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:訓道篇|傳道書|传(?:道书)?|傳)》|Eccl)|(?:(?:訓道篇|傳道書|传(?:道书)?|傳)》|《(?:訓道篇|傳道書|传(?:道书)?|傳)|訓道篇|傳道書|传(?:道书)?|傳)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Thess"]
		regexp: ///(^|[^0-9\\x1f])(
		(?:《(?:帖(?:撒(?:羅尼迦後書|罗尼迦后书)|[后後])|得撒洛尼後書|莎倫後)》|2Thess)|(?:(?:帖(?:撒(?:羅尼迦後書|罗尼迦后书)|[后後])|得撒洛尼後書|莎倫後)》|《(?:帖(?:撒(?:羅尼迦後書|罗尼迦后书)|[后後])|得撒洛尼後書|莎倫後)|帖(?:撒(?:羅尼迦後書|罗尼迦后书)|[后後])|得撒洛尼後書|莎倫後)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Thess"]
		regexp: ///(^|[^0-9\\x1f])(
		(?:《(?:帖(?:撒(?:羅尼迦前書|罗尼迦前书)|前)|得撒洛尼前書|莎倫前)》|1Thess)|(?:(?:帖(?:撒(?:羅尼迦前書|罗尼迦前书)|前)|得撒洛尼前書|莎倫前)》|《(?:帖(?:撒(?:羅尼迦前書|罗尼迦前书)|前)|得撒洛尼前書|莎倫前)|帖(?:撒(?:羅尼迦前書|罗尼迦前书)|前)|得撒洛尼前書|莎倫前)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Tim"]
		regexp: ///(^|[^0-9\\x1f])(
		(?:《(?:提(?:摩(?:太后书|斐後)|摩太後書|[后後])|弟茂德後書)》|2Tim)|(?:(?:提(?:摩(?:太后书|斐後)|摩太後書|[后後])|弟茂德後書)》|《(?:提(?:摩(?:太后书|斐後)|摩太後書|[后後])|弟茂德後書)|提(?:摩(?:太后书|斐後)|摩太後書|[后後])|弟茂德後書)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Tim"]
		regexp: ///(^|[^0-9\\x1f])(
		(?:《(?:提(?:摩(?:太前[书書]|斐前)|前)|弟茂德前書)》|1Tim)|(?:(?:提(?:摩(?:太前[书書]|斐前)|前)|弟茂德前書)》|《(?:提(?:摩(?:太前[书書]|斐前)|前)|弟茂德前書)|提(?:摩(?:太前[书書]|斐前)|前)|弟茂德前書)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Titus"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:提多[书書]|提特書|弟鐸書|多)》|Titus)|(?:(?:提多[书書]|提特書|弟鐸書|多)》|《(?:提多[书書]|提特書|弟鐸書|多)|提多[书書]|提特書|弟鐸書|多)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Phlm"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:費肋孟書|腓利(?:门书|門書)|肥利孟|[門门])》|Phlm)|(?:(?:費肋孟書|腓利(?:门书|門書)|肥利孟|[門门])》|《(?:費肋孟書|腓利(?:门书|門書)|肥利孟|[門门])|費肋孟書|腓利(?:门书|門書)|肥利孟|[門门])
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Heb"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:耶烏雷爾|希伯(?:来书|來[书書])|[來来])》|Heb)|(?:(?:耶烏雷爾|希伯(?:来书|來[书書])|[來来])》|《(?:耶烏雷爾|希伯(?:来书|來[书書])|[來来])|耶烏雷爾|希伯(?:来书|來[书書])|[來来])
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Jas"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:雅(?:各(?:伯書|[书書]))?|亞适烏)》|Jas)|(?:(?:雅(?:各(?:伯書|[书書]))?|亞适烏)》|《(?:雅(?:各(?:伯書|[书書]))?|亞适烏)|雅(?:各(?:伯書|[书書]))?|亞适烏)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Pet"]
		regexp: ///(^|[^0-9\\x1f])(
		(?:《(?:伯多祿後書|撇特爾後|彼(?:得后书|[后後])|彼得後書)》|2Pet)|(?:(?:伯多祿後書|撇特爾後|彼(?:得后书|[后後])|彼得後書)》|《(?:伯多祿後書|撇特爾後|彼(?:得后书|[后後])|彼得後書)|伯多祿後書|撇特爾後|彼(?:得后书|[后後])|彼得後書)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Pet"]
		regexp: ///(^|[^0-9\\x1f])(
		(?:《(?:伯多祿前書|撇特爾前|彼(?:得前[书書]|前))》|1Pet)|(?:(?:伯多祿前書|撇特爾前|彼(?:得前[书書]|前))》|《(?:伯多祿前書|撇特爾前|彼(?:得前[书書]|前))|伯多祿前書|撇特爾前|彼(?:得前[书書]|前))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Jude"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:猶[大達]書|犹大书|伊屋達|[犹猶])》|Jude)|(?:(?:猶[大達]書|犹大书|伊屋達|[犹猶])》|《(?:猶[大達]書|犹大书|伊屋達|[犹猶])|猶[大達]書|犹大书|伊屋達|[犹猶])
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Bar"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《巴路克》?|巴路克》?|Bar)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Sus"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《Sus》?|Sus》?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Macc"]
		apocrypha: true
		regexp: ///(^|[^0-9\\x1f])(
		(?:《瑪加伯下》?|2Macc|瑪加伯下》?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["3Macc"]
		apocrypha: true
		regexp: ///(^|[^0-9\\x1f])(
		(?:《3Macc》?|3Macc》?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["4Macc"]
		apocrypha: true
		regexp: ///(^|[^0-9\\x1f])(
		(?:《4Macc》?|4Macc》?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Macc"]
		apocrypha: true
		regexp: ///(^|[^0-9\\x1f])(
		(?:《瑪加伯上》?|1Macc|瑪加伯上》?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Josh"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:《(?:若蘇厄書|约书亚记|約書亞記|[书書])》|Josh)|(?:(?:若蘇厄書|约书亚记|約書亞記|[书書])》|《(?:若蘇厄書|约书亚记|約書亞記|[书書])|若蘇厄書|约书亚记|約書亞記|[书書])
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
