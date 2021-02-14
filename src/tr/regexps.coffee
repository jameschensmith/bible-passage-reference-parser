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
				  | ba[şs]l[İIiı]k (?! [a-z] )		#could be followed by a number
				  | baplar | ayeti | ayet | bap | ile | a\. | bp | vs | vd | ve
				  | [b-e] (?! \w )			#a-e allows 1:1a
				  | $						#or the end of the string
				 )+
		)
	///gi
# These are the only valid ways to end a potential passage match. The closing parenthesis allows for fully capturing parentheses surrounding translations (ESV**)**. The last one, `[\d\x1f]` needs not to be +; otherwise `Gen5ff` becomes `\x1f0\x1f5ff`, and `adjust_regexp_end` matches the `\x1f5` and incorrectly dangles the ff.
bcv_parser::regexps.match_end_split = ///
	  \d \W* ba[şs]l[İIiı]k
	| \d \W* (?:vs|vd) (?: [\s\xa0*]* \.)?
	| \d [\s\xa0*]* [b-e] (?! \w )
	| \x1e (?: [\s\xa0*]* [)\]\uff09] )? #ff09 is a full-width closing parenthesis
	| [\d\x1f]
	///gi
bcv_parser::regexps.control = /[\x1e\x1f]/g
bcv_parser::regexps.pre_book = "[^A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ]"

bcv_parser::regexps.first = "(?:1|I|Bir|Birinci|[İIiı]lk)\\.?#{bcv_parser::regexps.space}*"
bcv_parser::regexps.second = "(?:2|II|[İIiı]ki|[İIiı]kinci)\\.?#{bcv_parser::regexps.space}*"
bcv_parser::regexps.third = "(?:3|III|[ÜU][çc]|[ÜU][çc][üu]nc[üu])\\.?#{bcv_parser::regexps.space}*"
bcv_parser::regexps.range_and = "(?:[&\u2013\u2014-]|ve|ile)"
bcv_parser::regexps.range_only = "(?:[\u2013\u2014-]|ile)"
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
		(?:Yar(?:at[Iİı]l[Iİı][sş])?|Te(?:sn[Iİı]ye|kv[Iİı]n)|Gen)|(?:Yarat(?:il[Iiİı][sş]|[Iİı]li[sş])|Te(?:sniye|kvin))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Exod"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:M[Iİı]s[Iİı]r(?:['’]dan[\s\xa0]*[C\xC7][Iİı]k[Iİı][sş]|dan[\s\xa0]*[C\xC7][Iİı]k[Iİı][sş])|Exod|[C\xC7][Iİı]k)|(?:M(?:is[Iiİı]r(?:['’]dan[\s\xa0]*[C\xC7][Iiİı]|dan[\s\xa0]*[C\xC7][Iiİı])k[Iiİı][sş]|[Iİı]s(?:ir(?:['’]dan[\s\xa0]*[C\xC7][Iiİı]|dan[\s\xa0]*[C\xC7][Iiİı])k[Iiİı][sş]|[Iİı]r(?:['’]dan[\s\xa0]*[C\xC7](?:ik[Iiİı][sş]|[Iİı]ki[sş])|dan[\s\xa0]*[C\xC7](?:ik[Iiİı][sş]|[Iİı]ki[sş]))))|(?:[C\xC7]ik[Iiİı]|[C\xC7][Iİı]k[Iiİı])[sş]|[C\xC7]ik)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Bel"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Bel(?:[\s\xa0]*ve[\s\xa0]*Ejderha)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Lev"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Lev(?:[Iiİı]l[Iiİı]ler)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Num"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:[C\xC7][o\xF6]lde[\s\xa0]*Say[Iİı]m|Say(?:[Iİı]lar)?|Num)|(?:[C\xC7][o\xF6]lde[\s\xa0]*Sayim|Sayilar)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Sir"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:S(?:ir(?:ak)?|[Iİı]rak))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Wis"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:B[Iiİı]lgelik|Wis)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Lam"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:A[gğ][Iiİı](?:tlar)?|Lam)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["EpJer"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Yeremya(?:['’]n[Iiİı]|n[Iiİı])n[\s\xa0]*Mektubu|EpJer)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Rev"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Va(?:h(?:[Iiİı]y)?)?|Rev)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["PrMan"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Mana[sş][sş]e(?:['’]n[Iİı]n[\s\xa0]*Duas[Iİı]|n[Iİı]n[\s\xa0]*Duas[Iİı])|PrMan)|(?:Mana[sş][sş]e(?:['’]n(?:in[\s\xa0]*Duas[Iiİı]|[Iİı]n[\s\xa0]*Duasi)|n(?:in[\s\xa0]*Duas[Iiİı]|[Iİı]n[\s\xa0]*Duasi)))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Deut"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Yas(?:a(?:['’]n[Iİı]n[\s\xa0]*Tekrar[Iİı]|n[Iİı]n[\s\xa0]*Tekrar[Iİı]))?|Deut)|(?:Yasa(?:['’]n(?:in[\s\xa0]*Tekrar[Iiİı]|[Iİı]n[\s\xa0]*Tekrari)|n(?:in[\s\xa0]*Tekrar[Iiİı]|[Iİı]n[\s\xa0]*Tekrari)))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Josh"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Y(?:e[sş]|[sş])u|Josh)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Judg"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Hak(?:[Iiİı]mler)?|Judg)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Ruth"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ruth?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Esd"]
		apocrypha: true
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Bir(?:inci)?[\s\xa0]*Esdras|(?:[iİı]lk|I(?:lk|\.)|1\.)[\s\xa0]*Esdras|[1I][\s\xa0]*Esdras|1Esd)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Esd"]
		apocrypha: true
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:[iİı]ki(?:nci)?[\s\xa0]*Esdras|I(?:ki(?:nci)?|I\.?)[\s\xa0]*Esdras|2(?:\.[\s\xa0]*Esdras|[\s\xa0]*Esdras|Esd))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Isa"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:(?:Y(?:e[sş]ay|[sş])|Is)a)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Sam"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:2Sam)|(?:[iİı]ki(?:nci)?[\s\xa0]*Samuel|I(?:ki(?:nci)?|I\.?)[\s\xa0]*Samuel|2(?:\.?[\s\xa0]*Samuel|(?:\.?[\s\xa0]*)?Sa))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Sam"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:1Sam)|(?:Bir(?:inci)?[\s\xa0]*Samuel|(?:[iİı]lk|I(?:lk|\.))[\s\xa0]*Samuel|1(?:\.?[\s\xa0]*Samuel|(?:\.?[\s\xa0]*)?Sa)|I[\s\xa0]*Samuel)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Kgs"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:[iİı]ki(?:nci)?[\s\xa0]*Krallar|I(?:ki(?:nci)?|I\.?)[\s\xa0]*Krallar|2(?:\.?[\s\xa0]*Krallar|\.?[\s\xa0]*Kr|K(?:gs|r)))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Kgs"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Bir(?:inci)?[\s\xa0]*Krallar|(?:[iİı]lk|I(?:lk|\.))[\s\xa0]*Krallar|1(?:\.?[\s\xa0]*Krallar|\.?[\s\xa0]*Kr|K(?:gs|r))|I[\s\xa0]*Krallar)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Chr"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:[İı]ki(?:nci[\s\xa0]*Tar[Iİı]|[\s\xa0]*Tar[Iİı])hler|I(?:ki(?:nci[\s\xa0]*Tar[Iİı]|[\s\xa0]*Tar[Iİı])|I(?:\.[\s\xa0]*Tar[Iİı]|[\s\xa0]*Tar[Iİı]))hler|2(?:\.?[\s\xa0]*Tar[Iİı]hler|(?:\.?[\s\xa0]*)?Ta|Chr))|(?:(?:iki(?:nci[\s\xa0]*Tar[Iiİı]|[\s\xa0]*Tar[Iiİı])|[İı]ki(?:nci)?[\s\xa0]*Tari|I(?:ki(?:nci)?|I\.?)[\s\xa0]*Tari|2\.[\s\xa0]*Tari|2[\s\xa0]*Tari)hler)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Chr"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Bir(?:inci[\s\xa0]*Tar[Iİı]|[\s\xa0]*Tar[Iİı])hler|(?:[İı]lk|I(?:lk|\.))[\s\xa0]*Tar[Iİı]hler|1(?:\.?[\s\xa0]*Tar[Iİı]hler|(?:\.?[\s\xa0]*)?Ta|Chr)|I[\s\xa0]*Tar[Iİı]hler)|(?:(?:Bir(?:inci)?[\s\xa0]*Tari|ilk[\s\xa0]*Tar[Iiİı]|(?:[İı]lk|I(?:lk|\.)|1\.)[\s\xa0]*Tari|[1I][\s\xa0]*Tari)hler)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Ezra"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ezra?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Neh"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Neh(?:emya)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["GkEsth"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Yunanca[\s\xa0]*Ester|G(?:rek[c\xE7]e[\s\xa0]*Ester|kEsth))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Esth"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Est(?:er|h)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Job"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ey[u\xFC]p?|Job)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Ps"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Mez(?:mur(?:lar)?)?|Ps)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["PrAzar"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Azarya(?:['’]n[Iİı]n[\s\xa0]*Duas[Iİı]|n[Iİı]n[\s\xa0]*Duas[Iİı])|PrAzar)|(?:Azarya(?:['’]n(?:in[\s\xa0]*Duas[Iiİı]|[Iİı]n[\s\xa0]*Duasi)|n(?:in[\s\xa0]*Duas[Iiİı]|[Iİı]n[\s\xa0]*Duasi)))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Prov"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:S[u\xFC]leyman(?:['’][Iİı]n[\s\xa0]*(?:[O\xD6]zdey[Iİı][sş]ler[Iİı]|Meseller[Iİı])|[Iİı]n[\s\xa0]*(?:[O\xD6]zdey[Iİı][sş]ler[Iİı]|Meseller[Iİı]))|Meseller|Prov|[O\xD6]zd)|(?:S[u\xFC]leyman(?:['’](?:in[\s\xa0]*(?:[O\xD6]zdey[Iiİı][sş]ler[Iiİı]|Meseller[Iiİı])|[Iİı]n[\s\xa0]*(?:[O\xD6]zdey(?:i[sş]ler[Iiİı]|[Iİı][sş]leri)|Meselleri))|in[\s\xa0]*(?:[O\xD6]zdey[Iiİı][sş]ler[Iiİı]|Meseller[Iiİı])|[Iİı]n[\s\xa0]*(?:[O\xD6]zdey(?:i[sş]ler[Iiİı]|[Iİı][sş]leri)|Meselleri)))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Eccl"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Va(?:[Iiİı]z|[Iiİı])|Eccl)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["SgThree"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:[U\xDC][c\xE7][\s\xa0]*Gen[c\xE7][\s\xa0]*Adam[Iİı]n[\s\xa0]*Ezg[Iİı]s[Iİı]|SgThree)|(?:[U\xDC][c\xE7][\s\xa0]*Gen[c\xE7][\s\xa0]*Adam(?:in[\s\xa0]*Ezg[Iiİı]s[Iiİı]|[Iİı]n[\s\xa0]*Ezg(?:is[Iiİı]|[Iİı]si)))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Song"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ezg(?:[Iİı]ler[\s\xa0]*Ezg[Iİı]s[Iİı])?|Song)|(?:Ezg(?:iler[\s\xa0]*Ezg[Iiİı]s[Iiİı]|[Iİı]ler[\s\xa0]*Ezg(?:is[Iiİı]|[Iİı]si)))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Jer"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Yer(?:emya)?|Jer)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Ezek"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Hez(?:ek[Iiİı]el)?|Ezek)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Dan"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Dan(?:[Iiİı]el)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Hos"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ho(?:s(?:ea)?|ş))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Joel"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Yoel?|Joel)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Amos"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Amos?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Obad"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:O(?:va(?:dya)?|bad))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Jonah"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Yun(?:us)?|Jonah)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Mic"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:M(?:i(?:ka?|c)|[Iİı]ka?))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Nah"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Nah(?:um)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Hab"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Hab(?:akkuk)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Zeph"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Sef(?:anya)?|Zeph)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Hag"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Hag(?:ay)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Zech"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Ze(?:k(?:er[Iiİı]ya)?|ch))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Mal"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Mal(?:ak[Iiİı])?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Matt"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Mat(?:t(?:a(?:['’](?:ya[\s\xa0]*G[o\xF6]re[\s\xa0]*[Iİı]ncil|a[\s\xa0]*G[o\xF6]re[\s\xa0]*[Iİı]ncil|(?:n[Iuİı]n[\s\xa0]*[Iİı]|[Iuİı]n[\s\xa0]*[Iİı])ncili)|ya[\s\xa0]*G[o\xF6]re[\s\xa0]*[Iİı]ncil|a[\s\xa0]*G[o\xF6]re[\s\xa0]*[Iİı]ncil|(?:n[Iuİı]n[\s\xa0]*[Iİı]|[Iİı]n[\s\xa0]*[Iİı]|un[\s\xa0]*[Iİı]|[Iİı])ncili))?)?)|(?:Matta(?:['’](?:ya[\s\xa0]*G[o\xF6]re[\s\xa0]*incil|a[\s\xa0]*G[o\xF6]re[\s\xa0]*incil|(?:n(?:in[\s\xa0]*[Iiİı]|[Iuİı]n[\s\xa0]*i)|in[\s\xa0]*[Iiİı]|[Iuİı]n[\s\xa0]*i)ncili)|ya[\s\xa0]*G[o\xF6]re[\s\xa0]*incil|a[\s\xa0]*G[o\xF6]re[\s\xa0]*incil|(?:n(?:in[\s\xa0]*[Iiİı]|[Iuİı]n[\s\xa0]*i)n|in(?:[\s\xa0]*[Iiİı]n)?|[Iuİı]n[\s\xa0]*in)cili)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Mark"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Mar(?:k(?:os(?:['’](?:ya[\s\xa0]*G[o\xF6]re[\s\xa0]*[Iİı]ncil|a[\s\xa0]*G[o\xF6]re[\s\xa0]*[Iİı]ncil|(?:n[Iuİı]n[\s\xa0]*[Iİı]|[Iuİı]n[\s\xa0]*[Iİı])ncili)|ya[\s\xa0]*G[o\xF6]re[\s\xa0]*[Iİı]ncil|a[\s\xa0]*G[o\xF6]re[\s\xa0]*[Iİı]ncil|(?:n[Iuİı]n[\s\xa0]*[Iİı]|[Iİı]n[\s\xa0]*[Iİı]|un[\s\xa0]*[Iİı]|[Iİı])ncili))?)?)|(?:Markos(?:['’](?:ya[\s\xa0]*G[o\xF6]re[\s\xa0]*incil|a[\s\xa0]*G[o\xF6]re[\s\xa0]*incil|(?:n(?:in[\s\xa0]*[Iiİı]|[Iuİı]n[\s\xa0]*i)|in[\s\xa0]*[Iiİı]|[Iuİı]n[\s\xa0]*i)ncili)|ya[\s\xa0]*G[o\xF6]re[\s\xa0]*incil|a[\s\xa0]*G[o\xF6]re[\s\xa0]*incil|(?:n(?:in[\s\xa0]*[Iiİı]|[Iuİı]n[\s\xa0]*i)n|in(?:[\s\xa0]*[Iiİı]n)?|[Iuİı]n[\s\xa0]*in)cili)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Luke"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Luk(?:a(?:['’](?:ya[\s\xa0]*G[o\xF6]re[\s\xa0]*[Iİı]ncil|a[\s\xa0]*G[o\xF6]re[\s\xa0]*[Iİı]ncil|(?:n[Iuİı]n[\s\xa0]*[Iİı]|[Iuİı]n[\s\xa0]*[Iİı])ncili)|ya[\s\xa0]*G[o\xF6]re[\s\xa0]*[Iİı]ncil|a[\s\xa0]*G[o\xF6]re[\s\xa0]*[Iİı]ncil|(?:n[Iuİı]n[\s\xa0]*[Iİı]|[Iİı]n[\s\xa0]*[Iİı]|un[\s\xa0]*[Iİı]|[Iİı])ncili)|e)?)|(?:Luka(?:['’](?:ya[\s\xa0]*G[o\xF6]re[\s\xa0]*incil|a[\s\xa0]*G[o\xF6]re[\s\xa0]*incil|(?:n(?:in[\s\xa0]*[Iiİı]|[Iuİı]n[\s\xa0]*i)|in[\s\xa0]*[Iiİı]|[Iuİı]n[\s\xa0]*i)ncili)|ya[\s\xa0]*G[o\xF6]re[\s\xa0]*incil|a[\s\xa0]*G[o\xF6]re[\s\xa0]*incil|(?:n(?:in[\s\xa0]*[Iiİı]|[Iuİı]n[\s\xa0]*i)n|in(?:[\s\xa0]*[Iiİı]n)?|[Iuİı]n[\s\xa0]*in)cili)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1John"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Bir(?:inci)?[\s\xa0]*Yuhanna|(?:[iİı]lk|I(?:lk|\.))[\s\xa0]*Yuhanna|1(?:\.?[\s\xa0]*Yuhanna|\.?[\s\xa0]*Yu|John|Yu)|I[\s\xa0]*Yuhanna)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2John"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:[iİı]ki(?:nci)?[\s\xa0]*Yuhanna|I(?:ki(?:nci)?|I\.?)[\s\xa0]*Yuhanna|2(?:\.?[\s\xa0]*Yuhanna|\.?[\s\xa0]*Yu|John|Yu))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["3John"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:[U\xDC][c\xE7](?:[u\xFC]nc[u\xFC])?[\s\xa0]*Yuhanna|III\.[\s\xa0]*Yuhanna|III[\s\xa0]*Yuhanna|3(?:\.?[\s\xa0]*Yuhanna|\.?[\s\xa0]*Yu|John|Yu))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["John"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Yu(?:h(?:anna(?:['’](?:ya[\s\xa0]*G[o\xF6]re[\s\xa0]*[Iİı]ncil|a[\s\xa0]*G[o\xF6]re[\s\xa0]*[Iİı]ncil|(?:n[Iuİı]n[\s\xa0]*[Iİı]|[Iuİı]n[\s\xa0]*[Iİı])ncili)|ya[\s\xa0]*G[o\xF6]re[\s\xa0]*[Iİı]ncil|a[\s\xa0]*G[o\xF6]re[\s\xa0]*[Iİı]ncil|(?:n[Iuİı]n[\s\xa0]*[Iİı]|[Iİı]n[\s\xa0]*[Iİı]|un[\s\xa0]*[Iİı]|[Iİı])ncili))?)?|John)|(?:Yuhanna(?:['’](?:ya[\s\xa0]*G[o\xF6]re[\s\xa0]*incil|a[\s\xa0]*G[o\xF6]re[\s\xa0]*incil|(?:n(?:in[\s\xa0]*[Iiİı]|[Iuİı]n[\s\xa0]*i)|in[\s\xa0]*[Iiİı]|[Iuİı]n[\s\xa0]*i)ncili)|ya[\s\xa0]*G[o\xF6]re[\s\xa0]*incil|a[\s\xa0]*G[o\xF6]re[\s\xa0]*incil|(?:n(?:in[\s\xa0]*[Iiİı]|[Iuİı]n[\s\xa0]*i)n|in(?:[\s\xa0]*[Iiİı]n)?|[Iuİı]n[\s\xa0]*in)cili)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Acts"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:El[c\xE7](?:[Iİı]ler[Iİı]n[\s\xa0]*[Iİı][sş]ler[Iİı])?|Acts)|(?:El[c\xE7](?:iler[Iiİı]n[\s\xa0]*[Iiİı][sş]ler[Iiİı]|[Iİı]ler(?:in[\s\xa0]*[Iiİı][sş]ler[Iiİı]|[Iİı]n[\s\xa0]*(?:i[sş]ler[Iiİı]|[Iİı][sş]leri))))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Rom"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Rom(?:al[Iiİı]lar)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Cor"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:[İı]ki(?:nci[\s\xa0]*Kor[Iİı]nt(?:oslula|l[Iİı]le)|[\s\xa0]*Kor[Iİı]nt(?:oslula|l[Iİı]le))r|I(?:ki(?:nci[\s\xa0]*Kor[Iİı]nt(?:oslula|l[Iİı]le)|[\s\xa0]*Kor[Iİı]nt(?:oslula|l[Iİı]le))|I(?:\.[\s\xa0]*Kor[Iİı]nt(?:oslula|l[Iİı]le)|[\s\xa0]*Kor[Iİı]nt(?:oslula|l[Iİı]le)))r|2(?:\.?[\s\xa0]*Kor[Iİı]nt(?:oslula|l[Iİı]le)r|(?:\.?[\s\xa0]*)?Ko|Cor))|(?:(?:iki(?:nci[\s\xa0]*Kor[Iiİı]|[\s\xa0]*Kor[Iiİı])nt(?:oslula|l[Iiİı]le)|[İı]ki(?:nci[\s\xa0]*Kor(?:int(?:oslula|l[Iiİı]le)|[Iİı]ntlile)|[\s\xa0]*Kor(?:int(?:oslula|l[Iiİı]le)|[Iİı]ntlile))|I(?:ki(?:nci[\s\xa0]*Kor(?:int(?:oslula|l[Iiİı]le)|[Iİı]ntlile)|[\s\xa0]*Kor(?:int(?:oslula|l[Iiİı]le)|[Iİı]ntlile))|I(?:\.[\s\xa0]*Kor(?:int(?:oslula|l[Iiİı]le)|[Iİı]ntlile)|[\s\xa0]*Kor(?:int(?:oslula|l[Iiİı]le)|[Iİı]ntlile)))|2\.[\s\xa0]*Kor(?:int(?:oslula|l[Iiİı]le)|[Iİı]ntlile)|2[\s\xa0]*Kor(?:int(?:oslula|l[Iiİı]le)|[Iİı]ntlile))r)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Cor"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Bir(?:inci[\s\xa0]*Kor[Iİı]nt(?:oslula|l[Iİı]le)|[\s\xa0]*Kor[Iİı]nt(?:oslula|l[Iİı]le))r|(?:[İı]lk|I(?:lk|\.))[\s\xa0]*Kor[Iİı]nt(?:oslula|l[Iİı]le)r|1(?:\.?[\s\xa0]*Kor[Iİı]nt(?:oslula|l[Iİı]le)r|(?:\.?[\s\xa0]*)?Ko|Cor)|I[\s\xa0]*Kor[Iİı]nt(?:oslula|l[Iİı]le)r)|(?:(?:Bir(?:inci[\s\xa0]*Kor(?:int(?:oslula|l[Iiİı]le)|[Iİı]ntlile)|[\s\xa0]*Kor(?:int(?:oslula|l[Iiİı]le)|[Iİı]ntlile))|ilk[\s\xa0]*Kor[Iiİı]nt(?:oslula|l[Iiİı]le)|(?:[İı]lk|I(?:lk|\.)|1\.)[\s\xa0]*Kor(?:int(?:oslula|l[Iiİı]le)|[Iİı]ntlile)|[1I][\s\xa0]*Kor(?:int(?:oslula|l[Iiİı]le)|[Iİı]ntlile))r)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Gal"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Gal(?:atyal[Iiİı]lar)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Eph"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:E(?:f(?:e(?:sl[Iiİı]ler)?)?|ph))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Phil"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:F(?:[Iİı]l[Iİı]p[Iİı]l[Iİı]ler|lp)|Phil)|(?:F(?:il[Iiİı]p[Iiİı]l[Iiİı]|[Iİı]l(?:ip[Iiİı]l[Iiİı]|[Iİı]p(?:il[Iiİı]|[Iİı]li)))ler)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Col"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Kol(?:osel[Iiİı]ler)?|Col)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Thess"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:[İı]ki(?:nci[\s\xa0]*Selan[Iİı]kl[Iİı]|[\s\xa0]*Selan[Iİı]kl[Iİı])ler|I(?:ki(?:nci[\s\xa0]*Selan[Iİı]kl[Iİı]|[\s\xa0]*Selan[Iİı]kl[Iİı])|I(?:\.[\s\xa0]*Selan[Iİı]kl[Iİı]|[\s\xa0]*Selan[Iİı]kl[Iİı]))ler|2(?:\.?[\s\xa0]*Selan[Iİı]kl[Iİı]ler|Thess|\.?[\s\xa0]*Se|Se))|(?:(?:iki(?:nci[\s\xa0]*Selan[Iiİı]|[\s\xa0]*Selan[Iiİı])kl[Iiİı]|[İı]ki(?:nci[\s\xa0]*Selan(?:ikl[Iiİı]|[Iİı]kli)|[\s\xa0]*Selan(?:ikl[Iiİı]|[Iİı]kli))|I(?:ki(?:nci[\s\xa0]*Selan(?:ikl[Iiİı]|[Iİı]kli)|[\s\xa0]*Selan(?:ikl[Iiİı]|[Iİı]kli))|I(?:\.[\s\xa0]*Selan(?:ikl[Iiİı]|[Iİı]kli)|[\s\xa0]*Selan(?:ikl[Iiİı]|[Iİı]kli)))|2\.[\s\xa0]*Selan(?:ikl[Iiİı]|[Iİı]kli)|2[\s\xa0]*Selan(?:ikl[Iiİı]|[Iİı]kli))ler)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Thess"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Bir(?:inci[\s\xa0]*Selan[Iİı]kl[Iİı]|[\s\xa0]*Selan[Iİı]kl[Iİı])ler|(?:[İı]lk|I(?:lk|\.))[\s\xa0]*Selan[Iİı]kl[Iİı]ler|1(?:\.?[\s\xa0]*Selan[Iİı]kl[Iİı]ler|Thess|\.?[\s\xa0]*Se|Se)|I[\s\xa0]*Selan[Iİı]kl[Iİı]ler)|(?:(?:Bir(?:inci[\s\xa0]*Selan(?:ikl[Iiİı]|[Iİı]kli)|[\s\xa0]*Selan(?:ikl[Iiİı]|[Iİı]kli))|ilk[\s\xa0]*Selan[Iiİı]kl[Iiİı]|(?:[İı]lk|I(?:lk|\.)|1\.)[\s\xa0]*Selan(?:ikl[Iiİı]|[Iİı]kli)|[1I][\s\xa0]*Selan(?:ikl[Iiİı]|[Iİı]kli))ler)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Tim"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:2Tim)|(?:[İı]ki(?:nci[\s\xa0]*T[Iİı]|[\s\xa0]*T[Iİı])moteos|I(?:ki(?:nci[\s\xa0]*T[Iİı]|[\s\xa0]*T[Iİı])|I(?:\.[\s\xa0]*T[Iİı]|[\s\xa0]*T[Iİı]))moteos|2(?:(?:\.[\s\xa0]*T[Iİı]|[\s\xa0]*T[Iİı])moteos|\.[\s\xa0]*T[Iİı]|[\s\xa0]*T[Iİı]|Ti))|(?:iki(?:nci[\s\xa0]*T[Iiİı]|[\s\xa0]*T[Iiİı])moteos|[İı]ki(?:nci)?[\s\xa0]*Timoteos|I(?:ki(?:nci)?|I\.?)[\s\xa0]*Timoteos|2(?:\.?[\s\xa0]*Timoteos|\.?[\s\xa0]*Ti))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Tim"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:1Tim)|(?:Bir(?:inci[\s\xa0]*T[Iİı]|[\s\xa0]*T[Iİı])moteos|(?:[İı]lk|I(?:lk|\.))[\s\xa0]*T[Iİı]moteos|1(?:(?:\.[\s\xa0]*T[Iİı]|[\s\xa0]*T[Iİı])moteos|\.[\s\xa0]*T[Iİı]|[\s\xa0]*T[Iİı]|Ti)|I[\s\xa0]*T[Iİı]moteos)|(?:Bir(?:inci)?[\s\xa0]*Timoteos|ilk[\s\xa0]*T[Iiİı]moteos|(?:[İı]lk|I(?:lk|\.))[\s\xa0]*Timoteos|1(?:\.?[\s\xa0]*Timoteos|\.?[\s\xa0]*Ti)|I[\s\xa0]*Timoteos)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Titus"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:T[Iiİı]t(?:us)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Phlm"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:F(?:[Iiİı]l[Iiİı]mon|lm)|Phlm)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Heb"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:[Iİı]br(?:an[Iİı]ler)?|Heb)|(?:ibr(?:an[Iiİı]ler)?|[Iİı]braniler)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Jas"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Yak(?:up)?|Jas)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Pet"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:2Pet)|(?:[iİı]ki(?:nci)?[\s\xa0]*Petrus|I(?:ki(?:nci)?|I\.?)[\s\xa0]*Petrus|2(?:\.?[\s\xa0]*Petrus|(?:\.?[\s\xa0]*)?Pe))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Pet"]
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:1Pet)|(?:Bir(?:inci)?[\s\xa0]*Petrus|(?:[iİı]lk|I(?:lk|\.))[\s\xa0]*Petrus|1(?:\.?[\s\xa0]*Petrus|(?:\.?[\s\xa0]*)?Pe)|I[\s\xa0]*Petrus)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Jude"]
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Yah(?:uda)?|Jude)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Tob"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Tob(?:[Iiİı]t)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Jdt"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:(?:Yud[Iiİı]|Jd)t)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Bar"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Bar(?:uk)?)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["Sus"]
		apocrypha: true
		regexp: ///(^|#{bcv_parser::regexps.pre_book})(
		(?:Su(?:zanna|s))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["2Macc"]
		apocrypha: true
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:[iİı]ki(?:nci)?[\s\xa0]*Makabeler|I(?:ki(?:nci)?|I\.?)[\s\xa0]*Makabeler|2(?:\.[\s\xa0]*Makabeler|[\s\xa0]*Makabeler|Macc))
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["3Macc"]
		apocrypha: true
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:[U\xDC][c\xE7](?:[u\xFC]nc[u\xFC])?[\s\xa0]*Makabeler|(?:III|3)\.[\s\xa0]*Makabeler|(?:III|3)[\s\xa0]*Makabeler|3Macc)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["4Macc"]
		apocrypha: true
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:D[o\xF6]r(?:d[u\xFC]nc[u\xFC]|t)[\s\xa0]*Makabeler|(?:IV|4)\.[\s\xa0]*Makabeler|(?:IV|4)[\s\xa0]*Makabeler|4Macc)
			)(?:(?=[\d\s\xa0.:,;\x1e\x1f&\(\)\uff08\uff09\[\]/"'\*=~\-\u2013\u2014])|$)///gi
	,
		osis: ["1Macc"]
		apocrypha: true
		regexp: ///(^|[^0-9A-Za-zªµºÀ-ÖØ-öø-ɏḀ-ỿⱠ-ⱿꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꟿ])(
		(?:Bir(?:inci)?[\s\xa0]*Makabeler|(?:[iİı]lk|I(?:lk|\.)|1\.)[\s\xa0]*Makabeler|[1I][\s\xa0]*Makabeler|1Macc)
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
