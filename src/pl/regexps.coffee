{ bcv_parser } = require("../core")

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
				  | tytuł (?! [a-z] )		#could be followed by a number
				  | rozdział[óo]w | werset[óo]w | rozdziały | rozdział | n(?![n]) | wersety | werset | rozdz | oraz | wers | por | rr | nn | do | r | i | w
				  | [a-e] (?! \w )			#a-e allows 1:1a
				  | $						#or the end of the string
				 )+
		)
	///gi
# These are the only valid ways to end a potential passage match. The closing parenthesis allows for fully capturing parentheses surrounding translations (ESV**)**. The last one, `[\d\x1f]` needs not to be +; otherwise `Gen5ff` becomes `\x1f0\x1f5ff`, and `adjust_regexp_end` matches the `\x1f5` and incorrectly dangles the ff.
bcv_parser::regexps.match_end_split = ///
	  \d \W* tytuł
	| \d \W* n(?![n]) (?: [\s\xa0*]* \.)?
	| \d \W* nn (?: [\s\xa0*]* \.)?
	| \d [\s\xa0*]* [a-e] (?! \w )
	| \x1e (?: [\s\xa0*]* [)\]\uff09] )? #ff09 is a full-width closing parenthesis
	| [\d\x1f]
	///gi
bcv_parser::regexps.control = /[\x1e\x1f]/g
bcv_parser::regexps.pre_book = "[^A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ]"

bcv_parser::regexps.first = "(?:Pierwsza|Pierwsze|Pierwszy|1|I)\\.?#{bcv_parser::regexps.space}*"
bcv_parser::regexps.second = "(?:Druga|Drugi|2|II)\\.?#{bcv_parser::regexps.space}*"
bcv_parser::regexps.third = "(?:Trzecia|Trzeci|3|III)\\.?#{bcv_parser::regexps.space}*"
bcv_parser::regexps.range_and = "(?:[&\u2013\u2014-]|(?:oraz|por|i)|do)"
bcv_parser::regexps.range_only = "(?:[\u2013\u2014-]|do)"
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
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Pierwsz[aey][\s\xa0]*(?:Ks(?:i[eę]g[ai][\s\xa0]*Mo(?:y[zż]eszowe|j[zż]eszowa)|\.[\s\xa0]*Mo(?:y[zż]eszowe|j[zż]eszowa)|[\s\xa0]*Mo(?:y[zż]eszowe|j[zż]eszowa))|Moj(?:[zż]eszowa|[zż]))|[1I]\.[\s\xa0]*(?:Ks(?:i[eę]g[ai][\s\xa0]*Mo(?:y[zż]eszowe|j[zż]eszowa)|\.[\s\xa0]*Mo(?:y[zż]eszowe|j[zż]eszowa)|[\s\xa0]*Mo(?:y[zż]eszowe|j[zż]eszowa))|Moj(?:[zż]eszowa|[zż]))|[1I][\s\xa0]*Ks(?:i[eę]g[ai][\s\xa0]*Mo(?:y[zż]eszowe|j[zż]eszowa)|\.[\s\xa0]*Mo(?:y[zż]eszowe|j[zż]eszowa)|[\s\xa0]*Mo(?:y[zż]eszowe|j[zż]eszowa))|Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Rodzaju|(?:I[\s\xa0]*Moj[zż]|1[\s\xa0]*Moj[zż])eszowa|Genezis|I[\s\xa0]*Moj[zż]|1[\s\xa0]*Moj[zż]|I[\s\xa0]*Moj|1[\s\xa0]*M(?:oj)?|Ro?dz|Gen)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Exod"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Drug[ai][\s\xa0]*(?:Ks(?:i[eę]g[ai][\s\xa0]*Moj[zż]|\.[\s\xa0]*Moj[zż]|[\s\xa0]*Moj[zż])eszowa|Moj(?:[zż]eszowa|[zż]))|(?:II|2)\.[\s\xa0]*(?:Ks(?:i[eę]g[ai][\s\xa0]*Moj[zż]|\.[\s\xa0]*Moj[zż]|[\s\xa0]*Moj[zż])eszowa|Moj(?:[zż]eszowa|[zż]))|(?:II|2)[\s\xa0]*Ks(?:i[eę]g[ai][\s\xa0]*Moj[zż]|\.[\s\xa0]*Moj[zż]|[\s\xa0]*Moj[zż])eszowa|Ks(?:i[eę]g[ai][\s\xa0]*Wyj[sś]|\.[\s\xa0]*Wyj[sś]|[\s\xa0]*Wyj[sś])cia|(?:II[\s\xa0]*Moj[zż]|2[\s\xa0]*Moj[zż])eszowa|II[\s\xa0]*Moj[zż]|II[\s\xa0]*Moj|2[\s\xa0]*Moj[zż]|Exodus|2[\s\xa0]*Moj|Ex(?:od)?|2[\s\xa0]*M|Wy?j)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Bel"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Opowiadaniem[\s\xa0]*o[\s\xa0]*Belu[\s\xa0]*i[\s\xa0]*w[eę][zż]u|Bel(?:a[\s\xa0]*i[\s\xa0]*w[eę][zż]a)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Lev"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Trzeci(?:a[\s\xa0]*(?:Ks(?:i[eę]g[ai][\s\xa0]*Moj[zż]|\.[\s\xa0]*Moj[zż]|[\s\xa0]*Moj[zż])eszowa|Moj(?:[zż]eszowa|[zż]))|[\s\xa0]*(?:Ks(?:i[eę]g[ai][\s\xa0]*Moj[zż]|\.[\s\xa0]*Moj[zż]|[\s\xa0]*Moj[zż])eszowa|Moj(?:[zż]eszowa|[zż])))|(?:III|3)\.[\s\xa0]*(?:Ks(?:i[eę]g[ai][\s\xa0]*Moj[zż]|\.[\s\xa0]*Moj[zż]|[\s\xa0]*Moj[zż])eszowa|Moj(?:[zż]eszowa|[zż]))|(?:III|3)[\s\xa0]*Ks(?:i[eę]g[ai][\s\xa0]*Moj[zż]|\.[\s\xa0]*Moj[zż]|[\s\xa0]*Moj[zż])eszowa|Ks(?:i[eę]g[ai][\s\xa0]*Kapła[nń]|\.[\s\xa0]*Kapła[nń]|[\s\xa0]*Kapła[nń])ska|(?:III[\s\xa0]*Moj[zż]|3[\s\xa0]*Moj[zż])eszowa|III[\s\xa0]*Moj[zż]|III[\s\xa0]*Moj|3[\s\xa0]*Moj[zż]|3[\s\xa0]*M(?:oj)?|K(?:ap[lł]|p[lł])|Lev)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Num"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Czwarta[\s\xa0]*(?:Ks(?:i[eę]g[ai][\s\xa0]*Moj[zż]|\.[\s\xa0]*Moj[zż]|[\s\xa0]*Moj[zż])eszowa|Moj(?:[zż]eszowa|[zż]))|(?:IV|4)\.[\s\xa0]*(?:Ks(?:i[eę]g[ai][\s\xa0]*Moj[zż]|\.[\s\xa0]*Moj[zż]|[\s\xa0]*Moj[zż])eszowa|Moj(?:[zż]eszowa|[zż]))|(?:IV|4)[\s\xa0]*Ks(?:i[eę]g[ai][\s\xa0]*Moj[zż]|\.[\s\xa0]*Moj[zż]|[\s\xa0]*Moj[zż])eszowa|(?:IV[\s\xa0]*Moj[zż]|4[\s\xa0]*Moj[zż])eszowa|Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Liczb|IV[\s\xa0]*Moj[zż]|IV[\s\xa0]*Moj|4[\s\xa0]*Moj[zż]|4[\s\xa0]*M(?:oj)?|Num|Lb)|(?:Liczb)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Sir"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:M[aą]dro[sś][cć][\s\xa0]*Syracha|Ekl(?:ezjastyka|i)|Eklezjastyk|Syracha|Syr|Sir)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Wis"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:M(?:[aą]dr(?:o[sś][cć][\s\xa0]*Salomona)?|dr)|Ks(?:i[eę]g[ai][\s\xa0]*M[aą]dro[sś]|\.[\s\xa0]*M[aą]dro[sś]|[\s\xa0]*M[aą]dro[sś])ci|Wis)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Lam"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:L(?:a(?:m(?:entacje(?:[\s\xa0]*Jeremiasza)?)?)?|m)|Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Lamentacji|Treny(?:[\s\xa0]*Jeremiasza)?|Tr)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["EpJer"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:List[\s\xa0]*Jeremiasza|EpJer)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["PrMan"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Modlitwa[\s\xa0]*Manassesa|PrMan)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Deut"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Ks(?:i[eę]g[ai][\s\xa0]*Powt(?:[o\xF3]rzonego)?|\.[\s\xa0]*Powt(?:[o\xF3]rzonego)?|[\s\xa0]*Powt(?:[o\xF3]rzonego)?)[\s\xa0]*Prawa|(?:Pi[aą]ta[\s\xa0]*(?:Ks(?:i[eę]g[ai][\s\xa0]*Moj[zż]|\.[\s\xa0]*Moj[zż]|[\s\xa0]*Moj[zż])e|Moj[zż]e)|[5V]\.[\s\xa0]*(?:Ks(?:i[eę]g[ai][\s\xa0]*Moj[zż]|\.[\s\xa0]*Moj[zż]|[\s\xa0]*Moj[zż])e|Moj[zż]e)|(?:[5V][\s\xa0]*Ks(?:i[eę]g[ai][\s\xa0]*Moj[zż]|\.[\s\xa0]*Moj[zż]|[\s\xa0]*Moj[zż])|V[\s\xa0]*Moj[zż]|5[\s\xa0]*Moj[zż])e)szowa|Pi[aą]ta[\s\xa0]*Moj[zż]|[5V]\.[\s\xa0]*Moj[zż]|V[\s\xa0]*Moj[zż]|5[\s\xa0]*Moj[zż]|V[\s\xa0]*Moj|5[\s\xa0]*M(?:oj)?|(?:Deu|Pw)t)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Josh"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Jozuego|Jo(?:zuego|sh|z))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Judg"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ks(?:i[eę]g[ai][\s\xa0]*S[eę]dzi[o\xF3]|\.[\s\xa0]*S[eę]dzi[o\xF3]|[\s\xa0]*S[eę]dzi[o\xF3])w|S[eę]?dz|Judg)|(?:S[eę]dzi[o\xF3]w)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Ruth"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ks(?:i[eę]g[ai][\s\xa0]*Rut(?:hy)?|\.[\s\xa0]*Rut(?:hy)?|[\s\xa0]*Rut(?:hy)?)|R(?:uth|ut?|t))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Esd"]
		apocrypha: true
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Pierwsz[aey][\s\xa0]*(?:Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*)?Ezdrasza|[1I]\.[\s\xa0]*(?:Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*)?Ezdrasza|[1I][\s\xa0]*(?:Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*)?Ezdrasza|1Esd)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Esd"]
		apocrypha: true
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Drug[ai][\s\xa0]*(?:Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*)?Ezdrasza|(?:II|2)\.[\s\xa0]*(?:Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*)?Ezdrasza|(?:II|2)[\s\xa0]*(?:Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*)?Ezdrasza|2Esd)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Isa"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Izajasza|I(?:zajasza|sa|z))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Sam"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Drug[ai][\s\xa0]*(?:Ks(?:i[eę]g[ai][\s\xa0]*Samuel(?:ow)?|\.[\s\xa0]*Samuel(?:ow)?|[\s\xa0]*Samuel(?:ow)?)|Samuelow)a|(?:II|2)\.[\s\xa0]*(?:Ks(?:i[eę]g[ai][\s\xa0]*Samuel(?:ow)?|\.[\s\xa0]*Samuel(?:ow)?|[\s\xa0]*Samuel(?:ow)?)|Samuelow)a|II[\s\xa0]*(?:Ks(?:i[eę]g[ai][\s\xa0]*Samuel(?:ow)?|\.[\s\xa0]*Samuel(?:ow)?|[\s\xa0]*Samuel(?:ow)?)|Samuelow)a|2(?:[\s\xa0]*Ks(?:i[eę]g[ai][\s\xa0]*Samuel(?:ow)?|\.[\s\xa0]*Samuel(?:ow)?|[\s\xa0]*Samuel(?:ow)?)a|[\s\xa0]*Samuelowa|[\s\xa0]*Sam?|(?:Sa|[\s\xa0]*S)m))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Sam"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Pierwsz[aey][\s\xa0]*(?:Ks(?:i[eę]g[ai][\s\xa0]*Samuel(?:ow)?|\.[\s\xa0]*Samuel(?:ow)?|[\s\xa0]*Samuel(?:ow)?)|Samuelow)a|[1I]\.[\s\xa0]*(?:Ks(?:i[eę]g[ai][\s\xa0]*Samuel(?:ow)?|\.[\s\xa0]*Samuel(?:ow)?|[\s\xa0]*Samuel(?:ow)?)|Samuelow)a|1(?:[\s\xa0]*Ks(?:i[eę]g[ai][\s\xa0]*Samuel(?:ow)?|\.[\s\xa0]*Samuel(?:ow)?|[\s\xa0]*Samuel(?:ow)?)a|[\s\xa0]*Samuelowa|[\s\xa0]*Sam?|(?:Sa|[\s\xa0]*S)m)|I[\s\xa0]*(?:Ks(?:i[eę]g[ai][\s\xa0]*Samuel(?:ow)?|\.[\s\xa0]*Samuel(?:ow)?|[\s\xa0]*Samuel(?:ow)?)|Samuelow)a)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Kgs"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Czwarta[\s\xa0]*Ks(?:i[eę]g[ai][\s\xa0]*Kr[o\xF3]|\.[\s\xa0]*Kr[o\xF3]|[\s\xa0]*Kr[o\xF3])lewska|(?:Drug[ai][\s\xa0]*Ks(?:i[eę]g[ai][\s\xa0]*Kr[o\xF3]|\.[\s\xa0]*Kr[o\xF3]|[\s\xa0]*Kr[o\xF3])|(?:II|2)\.[\s\xa0]*Ks(?:i[eę]g[ai][\s\xa0]*Kr[o\xF3]|\.[\s\xa0]*Kr[o\xF3]|[\s\xa0]*Kr[o\xF3])|II[\s\xa0]*Ks(?:i[eę]g[ai][\s\xa0]*Kr[o\xF3]|\.[\s\xa0]*Kr[o\xF3]|[\s\xa0]*Kr[o\xF3])|2[\s\xa0]*K(?:s(?:i[eę]g[ai][\s\xa0]*Kr[o\xF3]|\.[\s\xa0]*Kr[o\xF3]|[\s\xa0]*Kr[o\xF3])|r[o\xF3]))lewska|(?:IV|4)\.[\s\xa0]*Ks(?:i[eę]g[ai][\s\xa0]*Kr[o\xF3]|\.[\s\xa0]*Kr[o\xF3]|[\s\xa0]*Kr[o\xF3])lewska|Drug[ai][\s\xa0]*Ks(?:i[eę]g[ai][\s\xa0]*Kr[o\xF3]l[o\xF3]|\.[\s\xa0]*Kr[o\xF3]l[o\xF3]|[\s\xa0]*Kr[o\xF3]l[o\xF3])w|(?:IV|4)[\s\xa0]*Ks(?:i[eę]g[ai][\s\xa0]*Kr[o\xF3]|\.[\s\xa0]*Kr[o\xF3]|[\s\xa0]*Kr[o\xF3])lewska|(?:II|2)\.[\s\xa0]*Ks(?:i[eę]g[ai][\s\xa0]*Kr[o\xF3]l[o\xF3]|\.[\s\xa0]*Kr[o\xF3]l[o\xF3]|[\s\xa0]*Kr[o\xF3]l[o\xF3])w|II[\s\xa0]*Ks(?:i[eę]g[ai][\s\xa0]*Kr[o\xF3]l[o\xF3]|\.[\s\xa0]*Kr[o\xF3]l[o\xF3]|[\s\xa0]*Kr[o\xF3]l[o\xF3])w|2(?:[\s\xa0]*Ks(?:i[eę]g[ai][\s\xa0]*Kr[o\xF3]l[o\xF3]|\.[\s\xa0]*Kr[o\xF3]l[o\xF3]|[\s\xa0]*Kr[o\xF3]l[o\xF3])w|[\s\xa0]*Krl|Kgs)|(?:Drug[ai]|(?:II|2)\.|II)[\s\xa0]*Kr[o\xF3]lewska|2[\s\xa0]*Kr[o\xF3]l)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Kgs"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Pierwsz[aey][\s\xa0]*K(?:s(?:i[eę]g[ai][\s\xa0]*Kr[o\xF3]l(?:ewska|[o\xF3]w)|\.[\s\xa0]*Kr[o\xF3]l(?:ewska|[o\xF3]w)|[\s\xa0]*Kr[o\xF3]l(?:ewska|[o\xF3]w))|r[o\xF3]lewska)|(?:(?:Trzeci(?:a[\s\xa0]*Ks(?:i[eę]g[ai]|\.)?|[\s\xa0]*Ks(?:i[eę]g[ai]|\.)?)|(?:III|3)\.[\s\xa0]*Ks(?:i[eę]g[ai]|\.)?|(?:III|3)[\s\xa0]*Ks(?:i[eę]g[ai]|\.)?)[\s\xa0]*Kr[o\xF3]|1[\s\xa0]*Kr[o\xF3])lewska|[1I]\.[\s\xa0]*K(?:s(?:i[eę]g[ai][\s\xa0]*Kr[o\xF3]l(?:ewska|[o\xF3]w)|\.[\s\xa0]*Kr[o\xF3]l(?:ewska|[o\xF3]w)|[\s\xa0]*Kr[o\xF3]l(?:ewska|[o\xF3]w))|r[o\xF3]lewska)|1[\s\xa0]*Ks(?:i[eę]g[ai][\s\xa0]*Kr[o\xF3]l(?:ewska|[o\xF3]w)|\.[\s\xa0]*Kr[o\xF3]l(?:ewska|[o\xF3]w)|[\s\xa0]*Kr[o\xF3]l(?:ewska|[o\xF3]w))|I[\s\xa0]*K(?:s(?:i[eę]g[ai][\s\xa0]*Kr[o\xF3]l(?:ewska|[o\xF3]w)|\.[\s\xa0]*Kr[o\xF3]l(?:ewska|[o\xF3]w)|[\s\xa0]*Kr[o\xF3]l(?:ewska|[o\xF3]w))|r[o\xF3]lewska)|1(?:[\s\xa0]*Kr[o\xF3]l|[\s\xa0]*Krl|Kgs))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Chr"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Drug[ai][\s\xa0]*K(?:s(?:i[eę]g[ai]|\.)?[\s\xa0]*K)?ronik|(?:II|2)\.[\s\xa0]*K(?:s(?:i[eę]g[ai]|\.)?[\s\xa0]*K)?ronik|II[\s\xa0]*K(?:s(?:i[eę]g[ai]|\.)?[\s\xa0]*K)?ronik|2(?:[\s\xa0]*Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Kronik|[\s\xa0]*Kronik|[\s\xa0]*Kron|[\s\xa0]*Krn|Chr))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Chr"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Pierwsz[aey][\s\xa0]*K(?:s(?:i[eę]g[ai]|\.)?[\s\xa0]*K)?ronik|[1I]\.[\s\xa0]*K(?:s(?:i[eę]g[ai]|\.)?[\s\xa0]*K)?ronik|1(?:[\s\xa0]*Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Kronik|[\s\xa0]*Kronik|[\s\xa0]*Kron|[\s\xa0]*Krn|Chr)|I[\s\xa0]*K(?:s(?:i[eę]g[ai]|\.)?[\s\xa0]*K)?ronik)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Ezra"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Ezdrasza|Ez(?:drasza|dr?|ra|r))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Neh"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Nehemiasza|Ne(?:hemiasza|h)?)
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
		(?:Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Estery|Est(?:ery|h)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Job"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ks(?:i[eę]g[ai][\s\xa0]*(?:Ij|Hi|J)|\.[\s\xa0]*(?:Ij|Hi|J)|[\s\xa0]*(?:Ij|Hi|J))oba|(?:Hi|J)ob|Hi)|(?:(?:Hi|J)oba)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Ps"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ks(?:i[eę]g[ai][\s\xa0]*Psalm[o\xF3]|\.[\s\xa0]*Psalm[o\xF3]|[\s\xa0]*Psalm[o\xF3])w|Ps(?:almy|alm)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["PrAzar"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Modlitw[aą][\s\xa0]*Azariasza|P(?:ie[sś][nń][\s\xa0]*Azariasza|rAzar))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Prov"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ks(?:i[eę]g[ai][\s\xa0]*Przy(?:powie[sś]ci[\s\xa0]*Salomona|sł[o\xF3]w)|\.[\s\xa0]*Przy(?:powie[sś]ci[\s\xa0]*Salomona|sł[o\xF3]w)|[\s\xa0]*Przy(?:powie[sś]ci[\s\xa0]*Salomona|sł[o\xF3]w))|Pr(?:zypowie[sś]ci[\s\xa0]*Salomonowych|z(?:yp?)?|ov)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Eccl"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:K(?:s(?:i[eę]g[ai][\s\xa0]*(?:K(?:aznodziei[\s\xa0]*Salomon|ohelet)|Eklezjastes)|\.[\s\xa0]*(?:K(?:aznodziei[\s\xa0]*Salomon|ohelet)|Eklezjastes)|[\s\xa0]*(?:K(?:aznodziei[\s\xa0]*Salomon|ohelet)|Eklezjastes))a|aznodziei[\s\xa0]*Salomonowego|ohelet|azn|oh)|E(?:cc|k)l)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["SgThree"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Pie[sś](?:n(?:i[aą][\s\xa0]*trzech[\s\xa0]*młodzie[nń]c[o\xF3]|[\s\xa0]*trzech[\s\xa0]*młodzie[nń]c[o\xF3])|ń[\s\xa0]*trzech[\s\xa0]*młodzie[nń]c[o\xF3])w|SgThree)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Song"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:P(?:ie[sś][nń][\s\xa0]*(?:nad[\s\xa0]*Pie[sś]niami|Salomona)|np|NP)|Song)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Jer"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Jeremiasza|J(?:eremiasza|e?r))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Ezek"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Ezechiela|Ez(?:echiela|ek|e)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Dan"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Daniela|D(?:aniela|an?|n))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Hos"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Ozeasza|Ozeasza|Hos|Oz)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Joel"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Proroctwo[\s\xa0]*Ioelowe|Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Joela|J(?:oela|l)|Joel)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Amos"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Amosa|Am(?:osa|os)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Obad"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Proroctwo[\s\xa0]*Abdyaszowe|Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Abdiasza|Abdiasza|Obad|Ab)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Jonah"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Proroctwo[\s\xa0]*Ionaszowe|Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Jonasza|Jona(?:sza|h)|Jon)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Mic"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Micheasza|Mi(?:cheasza|ch?)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Nah"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Proroctwo[\s\xa0]*Nahumowe|Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Nahuma|Na(?:huma|ch)|Nah?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Hab"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Proroctwo[\s\xa0]*Abakukowe|(?:Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Ha|Ha|A)bakuka|Hab?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Zeph"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Proroctwo[\s\xa0]*Sofoniaszowe|Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Sofoniasza|Sofoniasza|Zeph|Sof?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Hag"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Proroctwo[\s\xa0]*Aggieuszowe|Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Aggeusza|Aggeusza|Hag|Ag)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Zech"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Zachariasza|Z(?:achariasza|a(?:ch)?|ech))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Mal"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Proroctwo[\s\xa0]*Malachyaszowe|Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Malachiasza|M(?:alachiasza|l)|Mal)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Matt"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ew(?:angelia[\s\xa0]*(?:w(?:edług[\s\xa0]*[sś]w\.?|g[\s\xa0]*[sś]w\.?)[\s\xa0]*)?Mateusza|\.[\s\xa0]*Mateusza|[\s\xa0]*Mat(?:eusza)?)|M(?:at(?:eusza|t)|at(?:eusz)?|t))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Mark"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ew(?:angelia[\s\xa0]*(?:w(?:edług[\s\xa0]*[sś]w\.?|g[\s\xa0]*[sś]w\.?)[\s\xa0]*)?Marka|\.[\s\xa0]*Marka|[\s\xa0]*Mar(?:ka)?)|M(?:ar(?:ka|ek)|ark?|k))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Luke"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ew(?:angelia[\s\xa0]*(?:w(?:edług[\s\xa0]*[sś]w\.?|g[\s\xa0]*[sś]w\.?)[\s\xa0]*)?Łukasza|\.[\s\xa0]*Łukasza|[\s\xa0]*Łuk(?:asza)?)|Ł(?:ukasza|k)|Łuk(?:asz)?|L(?:uke|k)|Luk)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Acts"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Dz(?:iej(?:ach[\s\xa0]*Apostolskich|e(?:[\s\xa0]*Apostolskie|[\s\xa0]*Apost)?)|[\s\xa0]*Ap)?|Acts)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Rev"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ap(?:okalipsa[\s\xa0]*(?:[SŚ]wi[eę]tego|[sś]w\.|[sś]w)[\s\xa0]*Jana)?|Objawienie[\s\xa0]*[sś]w\.[\s\xa0]*Jana|Objawienie[\s\xa0]*[sś]w[\s\xa0]*Jana|Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Apokalipsy|Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Objawienia|Objawienie[\s\xa0]*Jana|Obj|Rev)|(?:Objawienie|Apokalipsa)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1John"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:1John)|(?:Pierwsz[aey][\s\xa0]*(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*)?)?Jana|[1I]\.[\s\xa0]*(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*)?)?Jana|1[\s\xa0]*(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*)?Jana|J(?:ana|an|n)?)|I[\s\xa0]*(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*)?)?Jana)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2John"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:2John)|(?:Drug[ai][\s\xa0]*(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*)?)?Jana|(?:II|2)\.[\s\xa0]*(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*)?)?Jana|II[\s\xa0]*(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*)?)?Jana|2[\s\xa0]*(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*)?Jana|J(?:ana|an|n)?))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["3John"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:3John)|(?:Trzeci(?:a[\s\xa0]*(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*)?)?|[\s\xa0]*(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*)?)?)Jana|(?:III|3)\.[\s\xa0]*(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*)?)?Jana|III[\s\xa0]*(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*)?)?Jana|3[\s\xa0]*(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*)?Jana|J(?:ana|an|n)?))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["John"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ew(?:angelia[\s\xa0]*(?:w(?:edług[\s\xa0]*[sś]w\.?|g[\s\xa0]*[sś]w\.?)[\s\xa0]*)?Jana|\.[\s\xa0]*Jana|[\s\xa0]*Jana?)|J(?:(?:oh)?n|ana|an)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Rom"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*Pawła[\s\xa0]*)?do[\s\xa0]*Rzymian|R(?:zymian|z(?:ym)?|om))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Cor"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Drug[ai][\s\xa0]*(?:List[\s\xa0]*[sś]w\.?[\s\xa0]*Pawła[\s\xa0]*do[\s\xa0]*Koryntian|list[\s\xa0]*do[\s\xa0]*Koryntian|Korynt(?:ian|[o\xF3]w))|(?:II|2)\.[\s\xa0]*(?:List[\s\xa0]*[sś]w\.?[\s\xa0]*Pawła[\s\xa0]*do[\s\xa0]*Koryntian|list[\s\xa0]*do[\s\xa0]*Koryntian|Korynt(?:ian|[o\xF3]w))|II[\s\xa0]*(?:List[\s\xa0]*[sś]w\.?[\s\xa0]*Pawła[\s\xa0]*do[\s\xa0]*Koryntian|list[\s\xa0]*do[\s\xa0]*Koryntian|Korynt(?:ian|[o\xF3]w))|2(?:[\s\xa0]*List[\s\xa0]*[sś]w\.?[\s\xa0]*Pawła[\s\xa0]*do[\s\xa0]*Koryntian|[\s\xa0]*list[\s\xa0]*do[\s\xa0]*Koryntian|[\s\xa0]*Koryntian|[\s\xa0]*Korynt[o\xF3]w|[\s\xa0]*Kor|Cor))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Cor"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Pierwsz[aey][\s\xa0]*(?:List[\s\xa0]*[sś]w\.?[\s\xa0]*Pawła[\s\xa0]*do[\s\xa0]*Koryntian|list[\s\xa0]*do[\s\xa0]*Koryntian|Korynt(?:ian|[o\xF3]w))|[1I]\.[\s\xa0]*(?:List[\s\xa0]*[sś]w\.?[\s\xa0]*Pawła[\s\xa0]*do[\s\xa0]*Koryntian|list[\s\xa0]*do[\s\xa0]*Koryntian|Korynt(?:ian|[o\xF3]w))|1(?:[\s\xa0]*List[\s\xa0]*[sś]w\.?[\s\xa0]*Pawła[\s\xa0]*do[\s\xa0]*Koryntian|[\s\xa0]*list[\s\xa0]*do[\s\xa0]*Koryntian|[\s\xa0]*Koryntian|[\s\xa0]*Korynt[o\xF3]w|[\s\xa0]*Kor|Cor)|I[\s\xa0]*(?:List[\s\xa0]*[sś]w\.?[\s\xa0]*Pawła[\s\xa0]*do[\s\xa0]*Koryntian|list[\s\xa0]*do[\s\xa0]*Koryntian|Korynt(?:ian|[o\xF3]w)))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Gal"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*Pawła[\s\xa0]*do[\s\xa0]*Galacjan|do[\s\xa0]*Gala(?:cjan|t[o\xF3]w))|Ga(?:lacjan|lat[o\xF3]w|l)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Eph"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:List[\s\xa0]*(?:[SŚ]wi[eę]tego[\s\xa0]*Pawła[\s\xa0]*Apostoła[\s\xa0]*do[\s\xa0]*Efez[o\xF3]w|(?:[sś]w\.?[\s\xa0]*Pawła[\s\xa0]*)?do[\s\xa0]*Efezjan)|E(?:fezjan|fez[o\xF3]w|f(?:ez)?|ph))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Phil"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*Pawła[\s\xa0]*)?do[\s\xa0]*Filipian|F(?:ilipens[o\xF3]w|lp)|Filipian|F(?:il(?:ip)?|l)|Phil)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Col"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*Pawła[\s\xa0]*)?do[\s\xa0]*Kolosan|Kolosens[o\xF3]w|Kolosan|Kol|Col)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Thess"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Drug[ai][\s\xa0]*(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*Pawła[\s\xa0]*)?do[\s\xa0]*Tesaloniczan|Tesalonic(?:ens[o\xF3]w|zan))|(?:II|2)\.[\s\xa0]*(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*Pawła[\s\xa0]*)?do[\s\xa0]*Tesaloniczan|Tesalonic(?:ens[o\xF3]w|zan))|II[\s\xa0]*(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*Pawła[\s\xa0]*)?do[\s\xa0]*Tesaloniczan|Tesalonic(?:ens[o\xF3]w|zan))|2(?:[\s\xa0]*List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*Pawła[\s\xa0]*)?do[\s\xa0]*Tesaloniczan|[\s\xa0]*Tesalonicens[o\xF3]w|[\s\xa0]*Tesaloniczan|Thess|[\s\xa0]*Tes))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Thess"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Pierwsz[aey][\s\xa0]*(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*Pawła[\s\xa0]*)?do[\s\xa0]*Tesaloniczan|Tesalonic(?:ens[o\xF3]w|zan))|[1I]\.[\s\xa0]*(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*Pawła[\s\xa0]*)?do[\s\xa0]*Tesaloniczan|Tesalonic(?:ens[o\xF3]w|zan))|1(?:[\s\xa0]*List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*Pawła[\s\xa0]*)?do[\s\xa0]*Tesaloniczan|[\s\xa0]*Tesalonicens[o\xF3]w|[\s\xa0]*Tesaloniczan|Thess|[\s\xa0]*Tes)|I[\s\xa0]*(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*Pawła[\s\xa0]*)?do[\s\xa0]*Tesaloniczan|Tesalonic(?:ens[o\xF3]w|zan)))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Tim"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Drug[ai][\s\xa0]*(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*Pawła[\s\xa0]*)?do[\s\xa0]*)?Tymoteusza|(?:II|2)\.[\s\xa0]*(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*Pawła[\s\xa0]*)?do[\s\xa0]*)?Tymoteusza|II[\s\xa0]*(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*Pawła[\s\xa0]*)?do[\s\xa0]*)?Tymoteusza|2(?:[\s\xa0]*List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*Pawła[\s\xa0]*)?do[\s\xa0]*Tymoteusza|[\s\xa0]*Tymoteusza|(?:[\s\xa0]*Ty|Ti|[\s\xa0]*T)m))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Tim"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Pierwsz[aey][\s\xa0]*(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*Pawła[\s\xa0]*)?do[\s\xa0]*Tymoteusza|Tym(?:oteusza)?)|[1I]\.[\s\xa0]*(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*Pawła[\s\xa0]*)?do[\s\xa0]*Tymoteusza|Tym(?:oteusza)?)|1(?:[\s\xa0]*List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*Pawła[\s\xa0]*)?do[\s\xa0]*Tymoteusza|[\s\xa0]*Tymoteusza|(?:[\s\xa0]*Ty|Ti|[\s\xa0]*T)m)|I[\s\xa0]*(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*Pawła[\s\xa0]*)?do[\s\xa0]*Tymoteusza|Tym(?:oteusza)?))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Titus"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*Pawła[\s\xa0]*)?do[\s\xa0]*Tytusa|T(?:ytusa|itus|yt|t))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Phlm"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*Pawła[\s\xa0]*)?do[\s\xa0]*Filemona|Filemona|(?:File|(?:Ph|F)l)m)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Heb"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:List[\s\xa0]*do[\s\xa0]*(?:Hebrajczyk[o\xF3]|[ZŻ]yd[o\xF3])w|Hebrajczyk[o\xF3]w|[ZŻ]yd[o\xF3]w|Hebr?|[ZŻ]yd|Hbr)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Jas"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:List[\s\xa0]*(?:powszechny[\s\xa0]*[SŚ]wi[eę]tego[\s\xa0]*Iakuba[\s\xa0]*Apostoł|(?:[sś]w\.?[\s\xa0]*)?Jakub)a|J(?:akuba|ak|as|k))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Pet"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:2Pet)|(?:Drug[ai][\s\xa0]*(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*)?Piotra|Piotra?)|(?:II|2)\.[\s\xa0]*(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*)?Piotra|Piotra?)|II[\s\xa0]*(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*)?Piotra|Piotra?)|2[\s\xa0]*(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*)?Piotra|P(?:iotra|iotr)?))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Pet"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:1Pet)|(?:Pierwsz[aey][\s\xa0]*(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*)?Piotra|Piotra?)|[1I]\.[\s\xa0]*(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*)?Piotra|Piotra?)|1[\s\xa0]*(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*)?Piotra|P(?:iotra|iotr)?)|I[\s\xa0]*(?:List[\s\xa0]*(?:[sś]w\.?[\s\xa0]*)?Piotra|Piotra?))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Jude"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:List[\s\xa0]*(?:powszechny[\s\xa0]*[SŚ]wi[eę]tego[\s\xa0]*Iudasa[\s\xa0]*Apostoła|(?:[sś]w\.?[\s\xa0]*)?Judy)|J(?:ud[ey]|ud|d))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Tob"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ks(?:i[eę]g[ai][\s\xa0]*Tobi(?:asz|t)|\.[\s\xa0]*Tobi(?:asz|t)|[\s\xa0]*Tobi(?:asz|t))a|To?b)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Jdt"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Judyty|J(?:udyty|dt))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Bar"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Barucha|Ba(?:rucha|r)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Sus"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Opowiadaniem[\s\xa0]*o[\s\xa0]*Zuzannie|Zuzanna|Sus)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Macc"]
		apocrypha: true
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Drug[ai][\s\xa0]*Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Machabejska|(?:II|2)\.[\s\xa0]*Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Machabejska|II[\s\xa0]*Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Machabejska|2(?:[\s\xa0]*Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Machabejska|[\s\xa0]*Ma?ch|Macc))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["3Macc"]
		apocrypha: true
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Trzeci(?:a[\s\xa0]*Ks(?:i[eę]g[ai]|\.)?|[\s\xa0]*Ks(?:i[eę]g[ai]|\.)?)[\s\xa0]*Machabejska|(?:III|3)\.[\s\xa0]*Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Machabejska|III[\s\xa0]*Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Machabejska|3(?:[\s\xa0]*Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Machabejska|[\s\xa0]*Ma?ch|Macc))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["4Macc"]
		apocrypha: true
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Czwarta[\s\xa0]*Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Machabejska|(?:IV|4)\.[\s\xa0]*Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Machabejska|IV[\s\xa0]*Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Machabejska|4(?:[\s\xa0]*Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Machabejska|[\s\xa0]*Ma?ch|Macc))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Macc"]
		apocrypha: true
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Pierwsz[aey][\s\xa0]*Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Machabejska|[1I]\.[\s\xa0]*Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Machabejska|1(?:[\s\xa0]*Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Machabejska|[\s\xa0]*Ma?ch|Macc)|I[\s\xa0]*Ks(?:i[eę]g[ai]|\.)?[\s\xa0]*Machabejska)
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
